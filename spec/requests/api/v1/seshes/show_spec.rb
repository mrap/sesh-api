require 'spec_helper'

describe 'GET sesh' do

  let(:get_request) { get "/api/v1/seshes/#{@sesh.id}" }

  before do
    @sesh = create(:sesh)
    @comment = create(:comment, sesh: @sesh)
    get_request
  end

  it 'succeeds' do
    response.code.should eq "200"
  end

  it 'exposes sesh id' do
    json['id']['$oid'].should match @sesh.id
  end

  it 'exposes sesh info' do
    json['info']['title'].should match @sesh.title
    json['info']['favorites_count'].should eq @sesh.favoriters_count
    json['info']['listens_count'].should eq @sesh.listens_count
  end

  it 'exposes sesh comments' do
    json['comments'][0]['content'].should match @comment.content
  end

  it 'exposes sesh assets' do
    json['assets']['audio_url'].should eq @sesh.audio.url
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

