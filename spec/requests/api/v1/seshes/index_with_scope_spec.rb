require 'spec_helper'

describe 'getting list of scoped/sorted seshes' do

  describe "recent" do
    before do
      now = DateTime.now
      @old_sesh = create(:sesh)
      @new_sesh = create(:sesh, created_at: now.advance(minutes: 1))
      get "/api/v1/seshes", sort_options: ["recent"]
    end

    it 'is successful' do
      response.status.should eq 200
    end

    it 'returns seshes ordered by recency' do
      json['seshes'][0]['id']['$oid'].should match @new_sesh.id
    end
  end

  describe "anonymous_only" do
    before do
      5.times { create(:sesh) }
      @anonymous_sesh = create(:anonymous_sesh)
      get "/api/v1/seshes", sort_options: ["anonymous_only"]
    end

    it 'is successful' do
      response.status.should eq 200
    end

    it 'returns only anonymous seshes' do
      json['seshes'].count.should eq 1
      json['seshes'][0]['id']['$oid'].should match @anonymous_sesh.id
    end
  end

  context "when multiple sort_options are chained together" do
    before do
      5.times { create(:sesh) }
      now = DateTime.now
      @old_anonymous_sesh = create(:anonymous_sesh)
      @new_anonymous_sesh = create(:anonymous_sesh, created_at: now.advance(minutes: 1))
      get "/api/v1/seshes", sort_options: ["recent", "anonymous_only"]
    end

    it 'is successful' do
      response.status.should eq 200
    end

    it 'returns only anonymous seshes' do
      json['seshes'].count.should eq 2
      json['seshes'][0]['id']['$oid'].should match @new_anonymous_sesh.id
      json['seshes'][1]['id']['$oid'].should match @old_anonymous_sesh.id
    end
  end
end
