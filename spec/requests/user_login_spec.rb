require 'spec_helper'

describe 'user login' do

  before do
    @user = create(:user, email:    'roland@example.com',
                          password: 'password' )
  end

  context 'with valid credentials' do
    before(:each) do
      post tokens_path(version: 1),
                    {
                      email: 'roland@example.com',
                      password: 'password'
                    }
    end
    subject { response }

    its(:status)  { should eq 200 }

    it 'should provide a token' do
      @token = json['token']
      @token.should_not be_nil
    end

    it 'should return a valid auth token' do
      @token = json['token']
      expect { User.find(authentication_token: @token) }.to_not be_nil
    end
  end
end
