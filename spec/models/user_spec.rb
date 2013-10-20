require 'spec_helper'

describe User do

  describe 'valid user' do
    subject { create(:user) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    its(:username)  { should_not be_nil }
    its(:slug)      { should_not be_nil }
    it { should have_many(:owned_seshes) }
  end

  describe "when created with username: 'MikeRoland'" do
    subject(:user) { create(:user, username: 'MikeRoland') }
    its(:username)  { should match 'MikeRoland'}
    its(:slug)      { should match 'mikeroland' }
  end
end
