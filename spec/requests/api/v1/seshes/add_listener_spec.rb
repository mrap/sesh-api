require 'spec_helper'

describe "adding a listener to a sesh" do

  let(:user) { create(:user) }
  let(:sesh) { create(:sesh) }
  let(:request) { put "/api/v1/seshes/#{sesh.id}/add_listener",
      listener_id: user.id }

  before { request }

  it 'should be accepted' do
    response.status.should eq 202
  end

  it 'should expose updated listens_count' do
    json['info']['listens_count'].should eq 1
  end
end
