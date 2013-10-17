require 'spec_helper'

describe User do
  subject(:user) { create(:user) }

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  its(:username) { should_not be_nil }

end
