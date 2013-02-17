require 'spec_helper'

describe Church do
  it { should have_many(:church_memberships) }
  it { should have_many(:members).through(:church_memberships) }
  it { should have_many(:church_managerships) }
  it { should have_many(:managers).through(:church_managerships) }
  it { should have_many(:requests) }
  it { should have_one(:profile) }

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
          before { ChurchManagership.create(user_id: user.id, church_id: church.id) }

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
      before { ChurchManagership.create(user_id: user.id, church_id: church.id) }

      it { expect { church.remove_manager!(user.id) }.to change { ChurchManagership.count }.by(-1) }
    end
  end

  describe '.register' do
    context 'when no user_id is provided' do
      it { expect { Church.register({}, nil) }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when the user_id does not represent a site user' do
      let (:invisible_user) { FactoryGirl.create :invisible_user }

      it { expect { Church.register({}, invisible_user.id) }.to raise_error("UserNotSignedUp") }
    end

    context 'when the user_id is provided and valid' do
      let (:user) { FactoryGirl.create :user }

      it { expect { Church.register({}, user.id) }.to change { Church.count }.by(1) }
      it { expect { Church.register({}, user.id) }.to change { ChurchProfile.count }.by(1) }
      it { expect { Church.register({}, user.id) }.to change { ChurchMembership.count }.by(1) }
      it { expect { Church.register({}, user.id) }.to change { ChurchManagership.count }.by(1) }
    end
  end

  describe '#update_profile!' do
    let (:church) { FactoryGirl.create :church }
    let! (:profile) { church.profile }
    let! (:updates) { {
      name: profile.name,
      bio: "Some awesome new bio"
    } }

    context 'updates attribute' do
      it 'should call update_profile! with only changed attributes' do
        church.should_receive(:update_profile!).with(updates).once
        church.update_profile!(updates)
      end

      it 'should save the appropriate changes' do
        lambda { church.update_profile!(updates) }.should change { profile.bio }
        lambda { church.update_profile!(updates) }.should_not change { profile.name }
      end
    end
  end
end
