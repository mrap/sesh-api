require 'spec_helper'

describe Favorite do
  subject { create(:favorite) }
  its(:favoriter) { should_not be_nil }
  its(:favorited) { should_not be_nil }

  context 'when user attempts to favorite an already favorited sesh' do
    before do
      @user     = create(:user)
      @sesh     = create(:sesh)
      @favorite = create(:favorite, favoriter: @user, favorited: @sesh)
    end

    let(:refavorite) { Favorite.create!(favoriter: @user, favorited: @sesh) }

    it 'should not create favorite' do
      expect { refavorite }.to raise_error
    end
  end

end
