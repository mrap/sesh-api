require 'spec_helper'

describe 'existing user gets new token by submitting login credentials' do

  before do
    @user = create(:user, email:    'roland@example.com',
                          password: 'password' )
  end

  describe 'fetching a new auth token' do

    context 'with valid credentials' do
      before do
        post tokens_path(version: 1),
          { login: { email: @user.email, password: @user.password } }
      end

      subject { response }

      its(:status)  { should eq 200 }

      it 'should provide a token' do
        json['auth_token'].should_not be_nil
      end

      it 'should return a valid auth token' do
        @token = json['auth_token']
        expect { User.find(authentication_token: @token) }.to_not be_nil
      end
    end

    context 'with invalid email or password' do
      before do
        post tokens_path(version: 1),
          { login: { email: @user.email, password: 'incorrect password' } }
      end

      subject { response }

      its(:status) { should eq 401 }
    end
  end
end
