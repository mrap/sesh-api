require 'spec_helper'

describe Api::V1::UsersController do

  let(:content_body) { response.decoded_body.response }

  describe 'fetching a list of users' do

    before(:each) do
      10.times { create(:user) }
      get :index, version: 1
    end

    it 'should return a collection of users' do
      response.should be_collection_resource
    end
  end

  describe 'fetching a user by id: slug' do
    let!(:user) { create(:user) }
    subject { get :show, id: user.slug, version: 1 }

    it { should be_singular_resource }
  end

end