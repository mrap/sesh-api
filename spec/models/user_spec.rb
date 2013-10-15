require 'spec_helper'

describe User do
  subject(:user) { create(:user) }

  its(:username) { should_not be_nil }
  its(:email)    { should_not be_nil }
  its(:password) { should_not be_nil }

end
