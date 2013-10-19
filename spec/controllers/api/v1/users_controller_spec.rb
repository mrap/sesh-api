require 'spec_helper'

describe Api::V1::UsersController do
  default_version 1

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
end
