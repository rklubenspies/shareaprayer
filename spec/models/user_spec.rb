require 'spec_helper'

describe User do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:email).of_type(:string) }
  it { should have_db_column(:roles).of_type(:string) }

  it { should have_many(:church_memberships) }
  it { should have_many(:churches).through(:church_memberships) }
  it { should have_many(:requests) }
  it { should have_many(:prayers) }

  describe '.create' do
    context 'when no role is provided' do
      let (:user) { FactoryGirl.build :user, roles: [] }

      context 'when user is built' do
        it 'should have no role' do
          user.roles.should be_empty
        end
      end

      context 'when user is saved' do
        it 'should be assigned the invisible role' do
          user.save!
          user.roles.should include("invisible")
        end
      end
    end

    context 'when a role is provided' do
      let (:user) { FactoryGirl.build :user, roles: ["invisible"] }

      context 'when user is built' do
        it 'should have a role' do
          user.roles.should_not be_empty
        end
      end

      context 'when user is saved' do
        it 'role should be present' do
          user.save!
          user.roles.should include("invisible")
          user.roles.should_not be_empty
        end
      end
    end
  end

  describe '#roles' do
    context 'when user is invisible' do
      let (:user) { FactoryGirl.create :user, roles: ["invisible"] }

      specify { user.roles.include?("invisible").should be_true }
    end
  end

  describe '#join_church' do
    let (:church) { FactoryGirl.create :church }

    context 'when user is not signed up' do
      let (:user) { FactoryGirl.create :user, roles: ["invisible"] }

      it { expect { user.join_church(church.id) }.to raise_error("UserNotSignedUp") }
    end

    context 'when user is signed up' do
      let (:user) { FactoryGirl.create :user }

      context 'and is not a part of church already' do
        it { expect { user.join_church(church.id) }.to change { ChurchMembership.count }.by(1) }
      end

      context 'and is part of church already' do
        before { ChurchMembership.create(user_id: user.id, church_id: church.id) }

        it { expect { user.join_church(church.id) }.to raise_error("UserAlreadyChurchMember") }
      end
    end
  end

  describe '#leave_church!' do
    let (:user) { FactoryGirl.create :user }
    let (:church) { FactoryGirl.create :church }
    
    context 'when user is not a part of church already' do
      it { expect { user.leave_church!(church.id) }.to raise_error("UserNotChurchMember") }
    end

    context 'when user is part of church already' do
      before { ChurchMembership.create(user_id: user.id, church_id: church.id) }

      it { expect { user.leave_church!(church.id) }.to change { ChurchMembership.count }.by(-1) }
    end
  end

  describe '#is_church_member?' do
    let (:user) { FactoryGirl.create :user }
    let (:church) { FactoryGirl.create :church }

    context 'user is not part of church' do
      it 'should return false' do
        user.is_church_member?(church.id).should be_false
      end
    end

    context 'user is part of church' do
      before { ChurchMembership.create(user_id: user.id, church_id: church.id) }

      it 'should return true' do
        user.is_church_member?(church.id).should be_true
      end
    end
  end

  describe '#is_not_church_member?' do
    let (:user) { FactoryGirl.create :user }
    let (:church) { FactoryGirl.create :church }

    context 'user is part of church' do
      before { ChurchMembership.create(user_id: user.id, church_id: church.id) }

      it 'should return false' do
        user.is_not_church_member?(church.id).should be_false
      end
    end

    context 'user is not part of church' do
      it 'should return true' do
        user.is_not_church_member?(church.id).should be_true
      end
    end
  end

  describe '#post_request' do
    let (:user) { FactoryGirl.create :user }
    let (:church) { FactoryGirl.create :church }
    let (:request_opts) { FactoryGirl.attributes_for(:post_request_opts) }

    context 'user is posting into church' do
      context 'user is not part of church' do
        it { expect { user.post_request(request_opts, church.id) }.to raise_error("UserNotChurchMember") }
      end

      context 'user is part of church' do
        before { ChurchMembership.create(user_id: user.id, church_id: church.id) }

        it { expect { user.post_request(request_opts, church.id) }.to change { Request.count }.by(1) }
        it { expect { user.post_request(request_opts, church.id) }.to change { church.requests.count }.by(1) }
      end
    end

    context 'saving request' do
      context 'it should set the anonymous attribute' do
        context 'to true if specified' do
          let (:request_opts) { FactoryGirl.attributes_for(:post_request_opts, anonymous: true) }

          it 'should be true' do
            user.post_request(request_opts).anonymous.should be_true
          end
        end

        context 'to false otherwise' do
          it 'should be false' do
            user.post_request(request_opts).anonymous.should be_false
          end
        end
      end

      it { expect { user.post_request(request_opts) }.to change { Request.count }.by(1) }
    end
  end

  describe '#pray_for' do
    let (:request) { FactoryGirl.create :request }
    let (:user) { request.user }

    context 'user has not prayed for request' do
      it { expect { user.pray_for(request.id) }.to change { request.prayers.count }.by(1) }
    end

    context 'user has prayed for request already' do
      before { user.pray_for(request.id) }

      it { expect { user.pray_for(request.id) }.to raise_error("UserAlreadyPrayedForRequest") }
    end
  end

  describe '#has_prayed_for?' do
    let (:request) { FactoryGirl.create :request }
    let (:user) { request.user }

    context 'user has not prayed for request' do
      it 'should return false' do
        user.has_prayed_for?(request.id).should be_false
      end
    end

    context 'user has prayed for request' do
      before { user.pray_for(request.id) }

      it 'should return true' do
        user.has_prayed_for?(request.id).should be_true
      end
    end
  end

  describe '#has_not_prayed_for?' do
    let (:request) { FactoryGirl.create :request }
    let (:user) { request.user }

    context 'user has not prayed for request' do
      it 'should return true' do
        user.has_not_prayed_for?(request.id).should be_true
      end
    end

    context 'user has prayed for request' do
      before { user.pray_for(request.id) }

      it 'should return false' do
        user.has_not_prayed_for?(request.id).should be_false
      end
    end
  end
end
