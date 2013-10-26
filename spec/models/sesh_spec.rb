require 'spec_helper'

describe Sesh do
  subject(:sesh) { create(:sesh) }

  it { should belong_to(:author) }
  its(:title)         { should_not be_nil }
  its(:author)        { should_not be_nil }
  its(:is_anonymous)  { should be_false }
  it { should respond_to(:audio) }
  its(:created_at)    { should_not be_nil }
  it { should have_many :favorites }

  # Validations
  it { should validate_presence_of(:author) }

  context 'when created without a title' do
    subject(:sesh) { create(:sesh, title: nil) }
    it 'should default title to id' do
      sesh.title.should match sesh.id.to_s
    end
  end

  describe 'scopes' do
    before do
      @seshes = []
      @anonymous_sesh = create(:sesh, is_anonymous: true)
      @seshes << @anonymous_sesh
      for i in 1..3 do
        sesh = create(:sesh)
        sesh.update(created_at: DateTime.now.advance(seconds: i))
        @seshes << sesh
      end
    end

    describe 'default_scope' do
      it 'sorts sesh order from newest to oldest' do
        Sesh.all.to_a.should eq @seshes.reverse
      end
    end

    describe '.anonymous_only' do
      it 'returns only anonymous seshes' do
        Sesh.anonymous_only.to_a.should eq [@anonymous_sesh]
      end
    end

  end
end
