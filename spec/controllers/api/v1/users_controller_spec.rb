require 'spec_helper'

describe Api::V1::UsersController do
  default_version 1

  let(:content_body) { response.parsed_body['response'] }

  describe 'fetching a list of users' do
    before { 10.times { create(:user) } }
    subject { get :index }
    it { should be_collection_resource }
  end

  describe 'fetching a user' do
    let!(:user) { create(:user) }

    context 'with valid slug' do
      subject { get :show, id: user.slug}
      its(:status) { should eq 200 }
      it { should be_singular_resource }
      it { should have_exposed user }
    end

    context 'with invalid slug' do
      subject { get :show, id: 'invalid-slug'}
      its(:status) { should eq 404 }
      it { should have_exposed nil }
    end
  end

  describe 'creating a user' do

    context 'with valid parameters' do
      let(:valid_user) { build(:user) }
      before(:each) { post :create, user: valid_user.attributes }
      subject { response }

      its(:status) { should eq 201 }
      its(:decoded_body) { should have(1).username }
      it 'should return the correct user' do
        content_body['username'].should eq valid_user.username
      end
    end

    context 'with invalid parameters' do
      before(:each) { post :create, user: { invalid_parameter: 'blah' } }
      its(:status) { should eq 422 } # unprocessable entity
      it 'returns an invalid resource error' do
        response.should be_api_error RocketPants::InvalidResource
      end
    end
  end

end
