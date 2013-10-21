require 'spec_helper'

describe Api::V1::SeshesController do
  default_version 1
  let(:content_body) { response.parsed_body['response'] }

  describe 'fetching a sesh' do
    before { @sesh = create(:sesh) }

    context 'when params match valid sesh' do
      before { get :show, id: @sesh.id }
      subject { response }

      its(:status) { should eq 200 }
      it { should be_singular_resource }

      it 'should provide the title' do
        content_body['title'].should_not be_nil
      end

      it 'should provide the author' do
        content_body['author_id'].should_not be_nil
      end

      it 'should provide url to audio'

    end

    context 'when params do not match a valid sesh' do
      before { get :show, id: 'a-obviously-bad-sesh-id' }
      subject { response }

      its(:status) { should eq 404 }
      it { should have_exposed nil }
    end
  end

  describe 'creating a sesh' do
    before do
      @user = create(:user)
      post :create,
        { sesh:
          { author_id: @user.id,
            asset:
              {
                audio: File.new(Rails.root + 'spec/factories/paperclip/test_audio.mp3')
              }
          }
        }
    end
    subject { response }

    it 'should be successful' do
      response.status.should eq 201 # created
    end

    it { should be_singular_resource }

    it '@user should have sesh' do
      @user.seshes.count.should eq 1
    end

    it 'sesh should have audio' do
      @sesh = @user.seshes.first
      @sesh.audio.should_not be_nil
    end
  end
end
