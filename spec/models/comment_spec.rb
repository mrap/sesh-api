require 'spec_helper'

describe Comment do

  # Relations
  it { should belong_to(:sesh) }
  it { should belong_to(:user) }
  it { should have_many(:replies) }

  # Fields
  it { should have_fields(:content, :created_at) }

  # Validations
  it { should validate_presence_of :sesh }
  it { should validate_presence_of :user }
  it { should validate_presence_of :content }

  describe "scopes" do
    describe ".recent" do
      before do
        @oldest = create(:comment)
        @newest = create(:comment, created_at: DateTime.now.advance(minutes: 1))
      end

      it "orders comments newest to oldest" do
        Comment.recent.first.should eq @newest
        Comment.recent.last.should eq @oldest
      end
    end
  end
end
