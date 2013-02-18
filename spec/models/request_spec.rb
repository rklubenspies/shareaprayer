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
  it { should have_many(:reports) }

  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:user_id) }

  describe '.create' do
    context 'when no visibility is provided' do
      let(:request) { FactoryGirl.build :request }

      context 'when saved' do
        it 'should have a visible state' do
          request.save!
          request.visible?.should be_true
        end
      end
    end
  end
end
