require 'spec_helper'

describe 'destroying a token' do

  before do
    @user = create(:user)
    @auth_token = @user.authentication_token
  end

  context 'with valid auth_token' do
    before do
      delete "/api/v1/tokens/#{@auth_token}"
    end

    it 'returns 200 status code' do
      response.status.should eq 200
    end

    it 'deletes the token' do
      User.where(authentication_token: @auth_token).exists?.should be_false
    end
  end

  context 'with invalid auth_token' do
    before do
      delete "/api/v1/tokens/invalid-auth-token"
    end

    it 'returns 404 status code (bad request)' do
      response.status.should eq 400
    end

    it 'returns blank response body' do
      response.body.should be_blank
    end
  end
end
