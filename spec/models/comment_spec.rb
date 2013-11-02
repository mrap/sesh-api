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

end
