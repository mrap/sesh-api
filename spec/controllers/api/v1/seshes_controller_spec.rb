require 'spec_helper'

describe Api::V1::SeshesController do
  default_version 1
  let(:content_body) { response.parsed_body['response'] }

  describe 'GET sesh' do
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

      it 'should provide url audio' do
        @assets_hash = content_body['assets']
        @assets_hash['audio_url'].should_not be_nil
      end
    end

    context 'when sesh is anonymous' do
      before do
        @sesh.update(is_anonymous: true)
        get :show, id: @sesh.id
      end
      subject { response }

      it { should be_successful }

      it 'should not return a author_id' do
        content_body['author_id'].should be_nil
      end
    end

    context 'when params do not match a valid sesh' do
      before { get :show, id: 'a-obviously-bad-sesh-id' }
      subject { response }

      its(:status) { should eq 404 }
      it { should have_exposed nil }
    end
  end

  describe 'POST seshes' do
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

    it 'should return successful 201 status' do
      response.status.should eq 201 # created
    end

    it { should be_singular_resource }

    it 'should return the newly created sesh' do
      @sesh = Sesh.last
      response.should have_exposed @sesh
    end

    it '@user should have sesh' do
      @user.seshes.count.should eq 1
    end

    it 'sesh should have audio' do
      @sesh = @user.seshes.first
      @sesh.audio.should_not be_nil
    end
  end

  describe 'DELETE sesh' do
    before { @sesh = create(:sesh) }

    context 'when requesting with valid :id' do
      before { delete :destroy, id: @sesh.id }
      it { response.should be_successful }
      it 'should delete the resource' do
        Sesh.where(id: @sesh.id).exists?.should be_false
      end
    end

    context 'when requesting with invalid :id' do
      subject { delete :destroy, id: 'an-obviously-invalid-sesh-id' }
      it { should be_api_error RocketPants::NotFound }
    end
  end

  describe 'PUT sesh' do
    before { @sesh = create(:sesh) }

    context 'when updating the title' do
      before  { put :update, id: @sesh.id, sesh: {title: 'New Sesh Title'}}
      subject { response }

      it { should be_successful }

      it 'should update sesh title' do
        expect(Sesh.last.title).to eq 'New Sesh Title'
      end
    end

    context 'when requesting with invalid :id' do
      subject { put :update, id: 'an-obviously-invalid-sesh-id' }
      it { should be_api_error RocketPants::NotFound }
    end
  end
end
