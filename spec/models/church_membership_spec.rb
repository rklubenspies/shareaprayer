require 'spec_helper'

describe ChurchMembership do
  it { should belong_to(:user) }
  it { should belong_to(:church) }
end
