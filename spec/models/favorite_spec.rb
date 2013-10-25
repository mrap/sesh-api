require 'spec_helper'

describe Favorite do
  subject { create(:favorite) }
  its(:favoriter) { should_not be_nil }
  its(:favorited) { should_not be_nil }
end
