class Favorite
  include Mongoid::Document

  # Relations
  belongs_to :favoriter, polymorphic: true
  belongs_to :favorited, polymorphic: true

  validates_presence_of :favoriter, :favorited

end
