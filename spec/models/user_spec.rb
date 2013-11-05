require 'spec_helper'

describe User do

  subject(:user) { create(:user) }

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should embed_one(:api_key).with_autobuild }
  its(:username)              { should_not be_nil }
  its(:slug)                  { should_not be_nil }
  its(:authentication_token)  { should_not be_nil }
  it { should have_many(:seshes).with_dependent(:destroy) }
  it { should have_and_belong_to_many(:favorite_seshes) }
  it { should have_many(:comments).with_dependent(:destroy) }

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

    it '.public_seshes' do
      @user.public_seshes.to_a.should include @sesh1
      @user.public_seshes.to_a.should_not include @anonymous_sesh
    end
  end

  describe 'add_sesh_to_favorites' do
    before { @sesh = create(:sesh) }

    it 'works' do
      expect{ user.add_sesh_to_favorites(@sesh) }.to change{ user.favorite_seshes.count }.by(1)
    end
  end
end
