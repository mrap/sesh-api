require 'spec_helper'

describe 'create a new sesh' do
  before { @user = create(:user) }

  context 'with auth_token' do
    before do
      post '/api/v1/seshes',
        auth_token: @user.authentication_token,
        sesh: {
          author_id: @user.id,
          asset: {
            audio: File.new(Rails.root + 'spec/factories/paperclip/test_audio.mp3')
          }
        }
      @sesh = @user.seshes.last
    end

    it 'returns 201 code (created)' do
      response.status.should eq 201
    end

    it 'successfully creates the sesh' do
      @sesh.should_not be_nil
    end

    it 'exposes newly created sesh' do
      json['id']['$oid'].should match @sesh.id
    end

    it 'has audio' do
      @sesh.audio.should_not be_nil
    end
  end

  context 'when no valid auth_token in request' do
    before do
      post '/api/v1/seshes',
        sesh: {
          author_id: @user.id,
          asset: {
            audio: File.new(Rails.root + 'spec/factories/paperclip/test_audio.mp3')
          }
        }
    end

    it 'returns 401 code (Unauthorized)' do
      response.status.should eq 401
    end
  end
end
