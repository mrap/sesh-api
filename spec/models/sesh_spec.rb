require 'spec_helper'

describe Sesh do
  subject { create(:sesh) }

  it { should belong_to(:author) }

  its(:title)   { should_not be_nil }
  its(:author)  { should_not be_nil }

  # Validations
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:author) }

end
