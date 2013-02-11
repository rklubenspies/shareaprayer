require 'spec_helper'

describe ChurchMembership do
  it { should have_db_column(:roles).of_type(:string) }

  it { should belong_to(:user) }
  it { should belong_to(:church) }

  describe '.create' do
    context 'when no role is provided' do
      let(:church_membership) { FactoryGirl.build :church_membership, roles: [] }

      context 'when built' do
        it 'should have no role' do
          church_membership.roles.should be_empty
        end
      end

      context 'when saved' do
        it 'should be assigned the invisible role' do
          church_membership.save!
          church_membership.roles.should include("member")
        end
      end
    end

    context 'when a role is provided' do
      let (:church_membership) { FactoryGirl.build :church_membership }
      subject { church_membership }

      context 'when built' do
        it 'should have a role' do
          subject.roles.should_not be_empty
        end
      end

      context 'when saved' do
        it 'role should be present' do
          church_membership.save!
          church_membership.roles.should include("member")
          church_membership.roles.should_not be_empty
        end
      end
    end
  end

  describe '#roles' do
    context 'when user has member role in church' do
      let!(:church_membership) { FactoryGirl.create :church_membership }

      specify { church_membership.roles.include?("member").should be_true }
    end
  end
end
