require 'spec_helper'

describe ChurchProfile do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:bio).of_type(:text) }
  it { should have_db_column(:address).of_type(:string) }
  it { should have_db_column(:email).of_type(:string) }
  it { should have_db_column(:phone).of_type(:string) }
  it { should have_db_column(:website).of_type(:string) }
  it { should have_db_column(:church_id).of_type(:integer) }

  it { should belong_to(:church) }
end
