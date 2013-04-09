require 'spec_helper'

describe ChurchManagership do
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:church_id).of_type(:integer) }

  it { should belong_to(:user) }
  it { should belong_to(:church) }
end
