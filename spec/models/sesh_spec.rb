require 'spec_helper'

describe Sesh do
  before do
    @sesh = create(:sesh)
  end
  subject { @sesh }

  it { should belong_to(:author) }

  its(:title)   { should_not be_nil }
  its(:author)  { should_not be_nil }
  it { should respond_to(:audio) }

  # Validations
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:author) }
  it { should validate_presence_of(:audio)}

end
