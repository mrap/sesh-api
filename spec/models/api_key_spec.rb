require 'spec_helper'

describe ApiKey do
  it { should be_embedded_in :user }
  it { should have_field :access_token }
  it { should validate_presence_of :access_token }
  it { should validate_uniqueness_of :access_token }
end
