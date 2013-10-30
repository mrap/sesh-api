require 'spec_helper'

describe 'favoriting a sesh' do

  before do
    @user = create(:user)
    @sesh = create(:sesh)
  end

  context 'with valid auth_token' do
    before do
      put "/api/v1/seshes/#{@sesh.id}/favorite",
        favoriter_authentication_token: @user.authentication_token
    end

    it 'is successful' do
      response.status.should eq 202
    end

    it 'exposes the favorited sesh' do
      json['id']['$oid'].should match @sesh.id
    end
  end

  context 'when nil/invalid authentication_token sent' do
    before do
      put "/api/v1/seshes/#{@sesh.id}/favorite"
    end

    it 'returns 401 code (unauthorized)' do
      response.status.should eq 401
    end
  end
end
