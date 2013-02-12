require 'spec_helper'

describe Church do
  it { should have_db_column(:name).of_type(:string) }

  it { should have_many(:church_memberships) }
  it { should have_many(:users).through(:church_memberships) }
  it { should have_many(:requests) }
end
