require 'spec_helper'

describe Request do
  it { should have_db_column(:text).of_type(:string) }
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:church_id).of_type(:integer) }
  it { should have_db_column(:visibility).of_type(:string) }
  it { should have_db_column(:anonymous).of_type(:boolean) }
  it { should have_db_column(:ip_address).of_type(:string) }

  it { should belong_to(:user) }
  it { should belong_to(:church) }
  it { should have_many(:prayers) }

  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:user_id) }

  describe '.create' do
    context 'when no visibility is provided' do
      let(:request) { FactoryGirl.build :request, visibility: [] }

      context 'when built' do
        it 'should have no visibility' do
          request.visibility.should be_empty
        end
      end

      context 'when saved' do
        it 'should be assigned the visible visibility' do
          request.save!
          request.visibility.should include("visible")
        end
      end
    end

    context 'when a role is provided' do
      let (:request) { FactoryGirl.build :request }

      context 'when built' do
        it 'should have a role' do
          request.visibility.should_not be_empty
        end
      end

      context 'when saved' do
        it 'role should be present' do
          request.save!
          request.visibility.should include("visible")
          request.visibility.should_not be_empty
        end
      end
    end
  end
end
