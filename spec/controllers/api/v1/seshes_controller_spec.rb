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
    before { @user = create(:user) }

    context "when authentication_token does not match author.authentication_token" do
      before do
        post :create,
          { sesh:
            { author_id: @user.id,
              asset:
                {
                  audio: File.new(Rails.root + 'spec/factories/paperclip/test_audio.mp3')
                }
            }
          }
        @sesh = @user.seshes.last
      end

      it 'should have a 401 status (Unauthorized)' do
        response.status.should eq 401
      end

      it 'should have not created a new sesh' do
        Sesh.where(author: @user).exists?.should be_false
      end
    end

    context 'when valid authentication_token present' do
      before do
        post :create, authentication_token: @user.authentication_token,
            sesh:
              {
                author_id: @user.id,
                asset: { audio: File.new(Rails.root + 'spec/factories/paperclip/test_audio.mp3') }
              }
        @sesh = @user.seshes.last
      end


      it 'returns 201 status code' do
        response.status.should eq 201 # created
      end

      it 'should be a singular resource' do
        response.should be_singular_resource
      end

      it 'successfully creates the sesh' do
        Sesh.where(author: @user).exists?.should be_true
      end

      it 'returns the newly created sesh' do
        response.should have_exposed @sesh
      end

      it '@user should have sesh' do
        @user.seshes.count.should eq 1
      end

      it 'has audio' do
        @sesh.audio.should_not be_nil
      end
    end
  end

  describe 'DELETE sesh' do
    before { @sesh = create(:sesh) }

    context 'when sending valid authentication_token (authorized user)' do
      before do
        @user = @sesh.author
        delete :destroy, id: @sesh.id,
          authentication_token: @user.authentication_token
      end

      context 'when requesting with valid :id' do
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

    context 'when no valid authentication_token presented' do
      before { delete :destroy, id: @sesh.id }
      it 'returns 401 status code (unauthorized)' do
        response.status.should eq 401
      end
    end
  end

  describe 'PUT sesh' do
    before { @sesh = create(:sesh) }

    context 'when updating the title' do
      before do
        put :update, id: @sesh.id,
          sesh: { title: 'New Sesh Title' },
          authentication_token: @sesh.author.authentication_token
      end

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

    context 'when no valid authentication_token presented' do
      before do
        put :update, id: @sesh.id,
          sesh: {title: 'New Sesh Title'}
      end
      subject { response }

      it 'returns a 401 status code (Unauthorized)' do
        response.status.should eq 401
      end
    end
  end

  describe 'favoriting a sesh' do
    before do
      @user = create(:user)
      @sesh = create(:sesh)
    end

    context 'when correct authentication token presented' do
      before do
        put :favorite,  id: @sesh,
                        favoriter_authentication_token: @user.authentication_token
      end

      it 'should be successful' do
        response.status.should eq 200
      end

      it 'should expose the favorited sesh' do
        content_body['title'].should eq @sesh.title
      end
    end

    context 'when nil/invalid authentication_token sent' do
      before do
        put :favorite,  id: @sesh
      end

      it 'should return with 401 code (unauthorized)' do
        response.status.should eq 401
      end
    end
  end
end
