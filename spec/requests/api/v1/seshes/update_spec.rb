require 'spec_helper'

describe 'Updating sesh info' do
  before { @sesh = create(:sesh) }

  context 'with valid auth_token' do
    before do
      put "/api/v1/seshes/#{@sesh.id}",
        sesh: { title: 'New Sesh Title' },
        auth_token: @sesh.author.authentication_token
    end

    it 'returns status 202 (Accepted)' do
      response.status.should eq 202
    end

    it 'updates the sesh title' do
      Sesh.find(@sesh.id).title.should eq 'New Sesh Title'
    end

    it 'exposes the sesh' do
      json['info']['id']['$oid'].should match @sesh.id
    end
  end

  context 'when requesting with invalid :id' do
    before do
      put "/api/v1/seshes/a-bad-sesh-id",
      sesh: { title: 'New Sesh Title' },
      auth_token: @sesh.author.authentication_token
    end

    it 'returns 404' do
      response.code.should eq "404"
    end

    it 'exposes correct error'

  end

  context 'when no valid auth_token in request' do
    before do
      put "/api/v1/seshes/#{@sesh.id}",
      sesh: { title: 'New Sesh Title' }
    end

    it 'returns 401 code (Unauthorized)' do
      response.status.should eq 401
    end

    it 'exposes correct error'

  end
end
