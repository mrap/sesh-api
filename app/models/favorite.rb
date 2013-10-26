class Favorite
  include Mongoid::Document

  # Relations
  belongs_to :favoriter, class_name: 'User'
  belongs_to :favorited, class_name: 'Sesh', counter_cache: true

  validates_presence_of :favoriter, :favorited
  validates_uniqueness_of :favorited, :scope => :favoriter

end
