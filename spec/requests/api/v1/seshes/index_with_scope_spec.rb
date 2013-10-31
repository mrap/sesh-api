require 'spec_helper'

describe 'getting list of scoped/sorted seshes' do

  context "most recent" do
    before do
      now = DateTime.now
      @old_sesh = create(:sesh)
      @new_sesh = create(:sesh, created_at: now.advance(minutes: 1))
      get "/api/v1/seshes", sort: { recent: true }
    end

    it 'is successful' do
      response.status.should eq 200
    end

    it 'returns seshes ordered by recency' do
      json['seshes'][0]['id']['$oid'].should match @new_sesh.id
    end
  end
end
