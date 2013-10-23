require 'spec_helper'

describe Sesh do
  subject(:sesh) { create(:sesh) }

  it { should belong_to(:author) }
  its(:title)         { should_not be_nil }
  its(:author)        { should_not be_nil }
  its(:is_anonymous)  { should be_false }
  it { should respond_to(:audio) }

  # Validations
  it { should validate_presence_of(:author) }

  context 'when created without a title' do
    subject(:sesh) { create(:sesh, title: nil) }
    it 'should default title to id' do
      sesh.title.should match sesh.id.to_s
    end
  end
end
