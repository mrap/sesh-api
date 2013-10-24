require 'spec_helper'

describe User do

  describe 'valid user' do
    subject { create(:user) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    its(:username)              { should_not be_nil }
    its(:slug)                  { should_not be_nil }
    its(:authentication_token)  { should_not be_nil }
    it { should have_many(:seshes) }
  end

  describe ".slug" do
    subject(:user) { create(:user, username: 'MikeRoland') }

    it 'sets unique slug' do
      user.slug.should match 'mikeroland'
    end
  end

  describe "getting user's sesh ids" do

    before do
      @user = create(:user)
      @sesh1 = create(:sesh, author_id: @user.id)
      @sesh2 = create(:sesh, author_id: @user.id)
      @anonymous_sesh = create(:sesh, author_id: @user.id, is_anonymous: true)
    end
    subject { @user }

    its(:public_sesh_ids) { should eq [@sesh1.id, @sesh2.id] }
    its(:sesh_ids)        { should eq [@sesh1.id, @sesh2.id, @anonymous_sesh.id] }
  end
end
