require 'spec_helper'

describe Church do
  it { should have_db_column(:name).of_type(:string) }

  it { should have_many(:church_memberships) }
  it { should have_many(:users).through(:church_memberships) }
  it { should have_many(:church_managerships) }
  it { should have_many(:managers).through(:church_managerships) }
  it { should have_many(:requests) }

  describe '#add_manager' do
    let (:church) { FactoryGirl.create :church }

    context 'when user is not signed up' do
      let (:user) { FactoryGirl.create :invisible_user }

      it { expect { church.add_manager(user.id) }.to raise_error("UserNotSignedUp") }
    end

    context 'when user is signed up' do
      let (:user) { FactoryGirl.create :user }

      context 'and is not a part of church already' do
        it { expect { church.add_manager(user.id) }.to raise_error("UserNotChurchMember") }
      end

      context 'and is part of church already' do
        before { ChurchMembership.create(user_id: user.id, church_id: church.id) }

        context 'and is a manager of church already' do
          before { ChurchManagership.create(manager_id: user.id, church_id: church.id) }

          it { expect { church.add_manager(user.id) }.to raise_error("UserAlreadyChurchManager") }
        end

        context 'and is not a manager of church already' do
          it { expect { church.add_manager(user.id) }.to change { ChurchManagership.count }.by(1) }
        end
      end
    end
  end

  describe '#remove_manager!' do
    let (:user) { FactoryGirl.create :user }
    let (:church) { FactoryGirl.create :church }
    
    context 'when user is not a church manager already' do
      it { expect { church.remove_manager!(user.id) }.to raise_error("UserNotChurchManager") }
    end

    context 'when user is a church manager already' do
      before { ChurchManagership.create(manager_id: user.id, church_id: church.id) }

      it { expect { church.remove_manager!(user.id) }.to change { ChurchManagership.count }.by(-1) }
    end
  end
end
