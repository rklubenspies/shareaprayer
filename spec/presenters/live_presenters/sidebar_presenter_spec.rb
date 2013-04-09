require 'spec_helper'

describe LivePresenters::SidebarPresenter do
  describe '.initialize' do
    context 'when provided a valid user' do
      let (:user) { FactoryGirl.create :user}
      let (:sidebar) { LivePresenters::SidebarPresenter.new(user) }

      it 'should set the user instance variable' do
        sidebar.instance_variable_get(:@user).should == user
      end
    end

    context 'when provided an invalid user' do
      let (:user) { User.new() }

      it { expect { LivePresenters::SidebarPresenter.new(user) }.to raise_error("InvalidUser") }
    end
  end

  context 'presenter methods' do
    let (:user) { FactoryGirl.create :user }
    let (:church) { FactoryGirl.create :church }
    let (:sidebar) { LivePresenters::SidebarPresenter.new(user) }

    before { user.join_church(church.id) }

    describe '#user_name' do
      subject { sidebar.user_name }

      it { should == user.name}
    end

    describe '#churches' do
      subject { sidebar.churches }

      it { should == user.churches}
    end

    describe '#no_churches?' do
      subject { sidebar.no_churches? }

      context 'user has churches' do
        it { should be_false}
      end

      context 'user has no churches' do
        before { user.church_memberships.each { |c| c.destroy } }

        it { should be_true }
      end
    end
  end
end
