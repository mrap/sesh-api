require 'spec_helper'

describe Api::V1::UsersController do
  default_version 1

  let(:content_body) { response.parsed_body['response'] }

  describe 'fetching a list of users' do
    before { 10.times { create(:user) } }
    subject { get :index }
    it { should be_collection_resource }
  end

  describe 'GET a user' do
    let!(:user) { create(:user) }

    context 'with valid slug' do
      before  { get :show, id: user.slug }
      subject { response }

      its(:status) { should eq 200 }

      it { should be_singular_resource }

      it "should return user's username in :info hash" do
        @info_hash = content_body['info']
        @info_hash['username'].should_not be_nil
      end

      context 'when user has seshes' do
        before do
          @sesh = create(:sesh, author_id: user.id)
          @anonymous_sesh = create(:sesh, author_id: user.id,
            is_anonymous: true)
        end

        context 'when user is not correct_user?' do
           before { get :show, id: user.slug }

          it 'should include all sesh ids' do
            content_body['seshes'].to_s.should include @sesh.id
          end

          it 'should not include anonymous seshes' do
            content_body['seshes'].to_s.should_not include @anonymous_sesh.id
          end
        end

        context 'when user is correct_user?' do
          before do
            get :show, id: user.slug, authentication_token: user.authentication_token
          end

          it 'should include all sesh ids' do
            content_body['seshes'].to_s.should include @anonymous_sesh.id
          end
        end
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

      its(:status) { should eq 201 } # created
      its(:decoded_body) { should have(1).username }
      it 'should return the correct user' do
        content_body['username'].should eq valid_user_attributes[:username]
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
