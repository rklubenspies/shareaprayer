require 'spec_helper'

describe ReportedContent do
  it { should have_db_column(:reason).of_type(:string) }
  it { should have_db_column(:priority).of_type(:integer) }
  it { should have_db_column(:owner_id).of_type(:integer) }
  it { should have_db_column(:reportable_id).of_type(:integer) }
  it { should have_db_column(:reportable_type).of_type(:string) }

  it { should belong_to(:reportable) }
  it { should belong_to(:owner) }
end
