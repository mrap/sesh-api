require 'spec_helper'

describe "create a user" do

  context 'with valid parameters' do
    before do
      @new_user_attributes = {  username: 'roland',
                                email:    'roland@example.com',
                                password: 'password' }
      post "/api/v1/users", user: @new_user_attributes
    end

    it 'returns 201 code (created)' do
      response.status.should eq 201
    end

    it 'returns the correct user' do
      json['info']['username'].should eq @new_user_attributes[:username]
    end

    it 'exposes newly generated user auth token' do
      json['auth_token'].should_not be_nil
    end
  end

  context 'with invalid parameters' do
    before { post "/api/v1/users", user: { invalid_parameter: 'blah' } }

    it 'returns 422 code (unprocessable entity)' do
      response.status.should eq 422
    end

    it 'returns a blank body' do
      response.body.should be_blank
    end
  end
end
