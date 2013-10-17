class User
  include Mongoid::Document
  include Mongoid::Slug

  field :username
  validates :username,
    presence: true,
    uniqueness: true,
    format: { with: /\A[a-zA-Z0-9]+\Z/ } # no whitespace
  slug :username

end
