require 'spec_helper'

describe 'DELETE sesh' do
  before { @sesh = create(:sesh) }

  context 'with valid auth_token' do
    before do
      delete "/api/v1/seshes/#{@sesh.id}",
        auth_token: @sesh.author.authentication_token
    end

    it 'returns 202 code (accepted)' do
      response.status.should eq 202
    end

    it 'deletes the sesh' do
      Sesh.where(id: @sesh.id).exists?.should be_false
    end

    it 'exposes the deleted sesh' do
      json['id']['$oid'].should match @sesh.id
    end
  end

  context 'when no valid auth_token in request' do
    before do
      delete "/api/v1/seshes/#{@sesh.id}"
    end

    it 'returns 401 code (unauthorized)' do
      response.status.should eq 401
    end
  end
end
