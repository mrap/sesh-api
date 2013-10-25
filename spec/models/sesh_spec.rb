require 'spec_helper'

describe Sesh do
  subject(:sesh) { create(:sesh) }

  it { should belong_to(:author) }
  its(:title)         { should_not be_nil }
  its(:author)        { should_not be_nil }
  its(:is_anonymous)  { should be_false }
  it { should respond_to(:audio) }
  its(:created_at)    { should_not be_nil }

  # Validations
  it { should validate_presence_of(:author) }

  context 'when created without a title' do
    subject(:sesh) { create(:sesh, title: nil) }
    it 'should default title to id' do
      sesh.title.should match sesh.id.to_s
    end
  end

  describe 'named scopes' do
    before do
      @seshes = []
      for i in 1..3 do
        sesh = create(:sesh)
        sesh.update(created_at: DateTime.now.advance(seconds: i))
        @seshes << sesh
      end
    end

    describe '.recent' do
      it 'sorts sesh order from newest to oldest' do
        Sesh.recent.should eq @seshes.reverse
      end
    end
  end
end
