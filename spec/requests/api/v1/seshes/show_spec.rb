require 'spec_helper'

describe 'GET sesh' do

  before do
    @sesh = create(:sesh)
    get "/api/v1/seshes/#{@sesh.id}"
  end

  it 'succeeds' do
    response.code.should eq "200"
  end

  it 'exposes sesh id' do
    json['id']['$oid'].should match @sesh.id
  end

  it 'exposes sesh info' do
    json['info']['title'].should match @sesh.title
    json['info']['audio_url'].should eq @sesh.audio.url
  end

  it "exposes author's id and username" do
    @author = @sesh.author
    json['author']['id']['$oid'].should match @author.id
    json['author']['username'].should match @author.username
  end

  context 'when sesh is anonymous' do
    before do
      @anonymous_sesh = create(:anonymous_sesh)
      get "/api/v1/seshes/#{@anonymous_sesh.id}"
    end

    it 'does not expose the author' do
      json['author'].should be_nil
    end
  end

  context 'when not a valid sesh' do
    before do
      get '/api/v1/seshes/a-bad-sesh-id'
    end

    it 'returns json with error' do
      response.status.should eq 404
    end

    it 'does not expose any sesh' do
      response.body.should be_blank
    end
  end
end

