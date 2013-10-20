class Sesh
  include Mongoid::Document

  field   :title
  belongs_to :author, class_name: 'User', inverse_of: :owned_seshes

  validates_presence_of [:title, :author]
end
