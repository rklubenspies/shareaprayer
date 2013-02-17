require 'spec_helper'

describe User do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:email).of_type(:string) }

  it { should have_many(:church_memberships) }
  it { should have_many(:churches).through(:church_memberships) }
  it { should have_many(:church_managerships) }
  it { should have_many(:managed_churches).through(:church_managerships) }
  it { should have_many(:requests) }
  it { should have_many(:prayers) }
  it { should have_many(:reported_content) }

  describe '#roles' do
    context 'when user is site_user' do
      let! (:user) { FactoryGirl.create :user }

      specify { user.has_role?("site_user").should be_true }
    end

    context 'when user is invisible_user' do
      let! (:user) { FactoryGirl.create :invisible_user }

      specify { user.has_role?("invisible_user").should be_true }
    end
  end

  describe '#join_church' do
    let (:church) { FactoryGirl.create :church }

    context 'when user is not signed up' do
      let (:user) { FactoryGirl.create :invisible_user }

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

  describe '#is_church_manager?' do
    let (:user) { FactoryGirl.create :user }
    let (:church) { FactoryGirl.create :church }

    context 'user is not part of church' do
      it 'should return false' do
        user.is_church_manager?(church.id).should be_false
      end
    end

    context 'user is part of church' do
      before { ChurchManagership.create(user_id: user.id, church_id: church.id) }

      it 'should return true' do
        user.is_church_manager?(church.id).should be_true
      end
    end
  end

  describe '#is_not_church_member?' do
    let (:user) { FactoryGirl.create :user }
    let (:church) { FactoryGirl.create :church }

    context 'user is part of church' do
      before { ChurchManagership.create(user_id: user.id, church_id: church.id) }

      it 'should return false' do
        user.is_not_church_manager?(church.id).should be_false
      end
    end

    context 'user is not part of church' do
      it 'should return true' do
        user.is_not_church_manager?(church.id).should be_true
      end
    end
  end

  describe '#post_request' do
    let (:user) { FactoryGirl.create :user }
    let (:church) { FactoryGirl.create :church }
    let (:request_opts) { FactoryGirl.attributes_for(:post_request_opts) }

    context 'no church_id was provided' do
      it { expect { user.post_request(request_opts, nil) }.to raise_error("ChurchRequiredToPost") }
    end

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
      before { ChurchMembership.create(user_id: user.id, church_id: church.id) }
      
      context 'it should set the anonymous attribute' do
        context 'to true if specified' do
          let (:request_opts) { FactoryGirl.attributes_for(:post_request_opts, anonymous: true) }

          it 'should be true' do
            user.post_request(request_opts, church.id).anonymous.should be_true
          end
        end

        context 'to false otherwise' do
          it 'should be false' do
            user.post_request(request_opts, church.id).anonymous.should be_false
          end
        end
      end
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

  describe '#report_object' do
    let (:request) { FactoryGirl.create :request }
    let (:user) { request.user }

    context 'user wants to report a request' do
      context 'user has not reported request' do
        context 'user reports content' do
          it 'should set a priority of 0 if not specified' do
            user.report_object(request).priority.should == 0
          end

          it 'should accept a priority if specified' do
            user.report_object(request, { priority: 9 }).priority.should == 9
          end
          
          it { expect { user.report_object(request) }.to change { request.reports.count }.by(1) }
        end
      end

      context 'user has reported request already' do
        before { user.report_object(request) }

        it { expect { user.report_object(request) }.to raise_error("UserAlreadyReportedObject") }
      end
    end
  end

  describe '#has_reported_object?' do
    let (:request) { FactoryGirl.create :request }
    let (:user) { request.user }

    context 'user has not reported object' do
      it 'should return false' do
        user.has_reported_object?(request).should be_false
      end
    end

    context 'user has reported object' do
      before { user.report_object(request) }

      it 'should return true' do
        user.has_reported_object?(request).should be_true
      end
    end
  end

  describe '#has_not_reported_for?' do
    let (:request) { FactoryGirl.create :request }
    let (:user) { request.user }

    context 'user has not reported object' do
      it 'should return true' do
        user.has_not_reported_object?(request).should be_true
      end
    end

    context 'user has reported object' do
      before { user.report_object(request) }

      it 'should return false' do
        user.has_not_reported_object?(request).should be_false
      end
    end
  end
end
