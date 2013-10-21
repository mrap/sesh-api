class Sesh
  include Mongoid::Document
  include Mongoid::Paperclip

  field   :title
  belongs_to :author, class_name: 'User', inverse_of: :owned_seshes
  has_mongoid_attached_file :audio, dependent: :destroy

  validates_presence_of [:title, :author, :audio]
end
