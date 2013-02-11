require 'spec_helper'

describe User do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:email).of_type(:string) }
  it { should have_db_column(:roles).of_type(:string) }

  it { should have_many(:church_memberships) }
  it { should have_many(:churches).through(:church_memberships) }

  describe '.create' do
    context 'when no role is provided' do
      let(:user) { FactoryGirl.build :user, roles: [] }

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
      let!(:invisible_user) { FactoryGirl.create :user, roles: ["invisible"] }

      specify { invisible_user.roles.include?("invisible").should be_true }
    end
  end

  describe '#join_church!' do
    let (:church) { FactoryGirl.create :church }

    context 'when user is not signed up' do
      let (:user) { FactoryGirl.create :user, roles: ["invisible"] }

      it { expect { user.join_church!(church.id) }.to raise_error }
    end

    context 'when user is signed up' do
      context 'and is part of church already' do
        let (:user) { FactoryGirl.create :user }
        before { ChurchMembership.create(user_id: user.id, church_id: church.id) }

        it { expect { user.join_church!(church.id) }.to raise_error }
      end

      context 'and is not a part of church already' do
        let (:user) { FactoryGirl.create :user }

        it { expect { user.join_church!(church.id) }.to change { ChurchMembership.count }.by(1) }
      end
    end
  end

  describe '#leave_church!' do
    let (:church) { FactoryGirl.create :church }
    
    context 'when user is not a part of church already' do
      let (:user) { FactoryGirl.create :user }

      it { expect { user.leave_church!(church.id) }.to raise_error }
    end

    context 'when user is part of church already' do
      let (:user) { FactoryGirl.create :user }
      before { ChurchMembership.create(user_id: user.id, church_id: church.id) }

      it { expect { user.leave_church!(church.id) }.to change { ChurchMembership.count }.by(-1) }
    end
  end
end
