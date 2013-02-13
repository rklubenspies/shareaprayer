require 'spec_helper'

describe Prayer do
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:request_id).of_type(:integer) }
  it { should have_db_column(:ip_address).of_type(:string) }

  it { should belong_to(:user) }
  it { should belong_to(:request) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:request_id) }
end
