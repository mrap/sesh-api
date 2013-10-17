class User
  include Mongoid::Document

  field :username
  validates :username, presence: true, uniqueness: true

end
