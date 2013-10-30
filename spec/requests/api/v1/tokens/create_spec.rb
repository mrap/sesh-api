require 'spec_helper'

describe 'existing user gets new token by submitting login credentials' do

  before do
    @user = create(:user, email:    'roland@example.com',
                          password: 'password' )
  end

  describe 'fetching a new auth token' do

    context 'with valid credentials' do
      before do
        post "/api/v1/tokens",
          login: { email: @user.email, password: @user.password }
      end

      it 'returns 201 status code (created)' do
        response.status.should eq 201
      end

      it 'should provide a valid auth token' do
        @user_auth_token = User.find(@user.id).authentication_token
        json['auth_token'].should eq @user_auth_token
      end
    end

    context 'with invalid email or password' do
      before do
        post "/api/v1/tokens",
          login: { email: @user.email, password: 'incorrect password' }
      end

      it 'returns 401 status code' do
        response.status.should eq 401
      end

      it 'has a blank response body' do
        response.body.should be_blank
      end

    end
  end
end
