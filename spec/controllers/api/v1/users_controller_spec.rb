require 'spec_helper'

describe Api::V1::UsersController do
  default_version 1

  let(:content_body) { response.parsed_body['response'] }

  describe 'GET a user' do
    before do
      @user = create(:user)
      @sesh = create(:sesh, author_id: @user.id)
      @anonymous_sesh = create(:sesh, author_id: @user.id,
        is_anonymous: true)
    end

    context 'when requested with valid authentication_token' do
      before { get :show, id: @user.slug, authentication_token: @user.authentication_token }

      it 'is successful' do
        response.status.should eq 200
      end

      it 'exposes singular resource of @user' do
        response.should be_singular_resource
      end

      it 'exposes info hash' do
        content_body['info']['username'].should match @user.username
      end

      it "exposes all user's seshes (including anonymous seshes)" do
        content_body['seshes'].to_s.should include @sesh.id
        content_body['seshes'].to_s.should include @anonymous_sesh.id
      end
    end

    context 'when requested without a valid authentication_token' do
      before { get :show, id: @user.slug }

      it 'is successful' do
        response.status.should eq 200
      end

      it 'exposes singular resource of @user' do
        response.should be_singular_resource
      end

      it 'exposes info hash' do
        content_body['info']['username'].should match @user.username
      end

      it "exposes public sesh id's" do
        content_body['seshes'].to_s.should include @sesh.id
      end

      it 'does not expose anonymous seshes' do
        content_body['seshes'].to_s.should_not include @anonymous_sesh.id
      end
    end

    context 'with invalid slug' do
      subject { get :show, id: 'invalid-slug'}
      its(:status) { should eq 404 }
      it { should have_exposed nil }
    end
  end

  describe 'creating a user' do

    context 'with valid parameters' do
      let(:valid_user_attributes) { { username: 'roland',
                                      email:    'roland@example.com',
                                      password: 'password'  } }
      before  { post :create, user: valid_user_attributes }
      subject { response }

      its (:status) { should eq 200 }

      it 'should return the correct user' do
        content_body['info']['username'].should eq valid_user_attributes[:username]
      end

      it 'should return user athentication token' do
        content_body['authentication_token'].should_not be_nil
      end
    end

    context 'with invalid parameters' do
      before { post :create, user: { invalid_parameter: 'blah' } }

      its(:status) { should eq 422 } # unprocessable entity

      it 'returns an invalid resource error' do
        response.should be_api_error RocketPants::InvalidResource
      end
    end
  end

end
