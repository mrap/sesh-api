require 'spec_helper'

describe "GET a user" do

  before do
    @user           = create(:user)
    @sesh           = create(:sesh, author_id: @user.id)
    @anonymous_sesh = create(:anonymous_sesh, author_id: @user.id)
    get "/api/v1/users/#{@user.slug}"

  end

  it 'is successful' do
    response.status.should eq 200
  end

  it 'exposes user id' do
    json['id']['$oid'].should match @user.id
  end

  it 'exposes correct user info' do
    @info = json['info']
    @info['username'].should match @user.username
  end

  it 'exposes non-anonymous seshes only' do
    json['seshes'].length.should eq 1
  end

  context 'when requested with valid auth token' do
    before do
      get "/api/v1/users/#{@user.slug}", auth_token: @user.authentication_token
    end

    it 'exposes all user seshes (includes anonymous)' do
      json['seshes'].length.should eq 2
    end
  end

  context 'when user not found' do
    before { get "/api/v1/users/invalid-slug" }


    it 'is not found' do
      response.status.should eq 404
    end
  end
end
