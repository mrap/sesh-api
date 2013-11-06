require 'spec_helper'

describe ApiKey do

  it { should belong_to :user }
  it { should have_field :access_token }
  it { should validate_presence_of :access_token }
  it { should validate_uniqueness_of :access_token }

  its(:access_token) { should_not be_nil }

  describe "query for user using access_token" do
    let(:user)    { create(:user) }
    let(:api_key) { create(:api_key, user: user) }

    it "can find user using token" do
      @token = api_key.access_token
      ApiKey.find_user_with_token(@token).should eq user
    end
  end

  describe "Class Methods" do
    it ".unique_token" do
      ApiKey.unique_token.should_not be_nil
    end
  end

end
