class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  # Relations
  belongs_to  :sesh
  belongs_to  :user
  has_many    :replies, class_name: "Comment"

  # Fields
  field       :content, type: String

  # Validations
  validates_presence_of :sesh, :user, :content

  # Named Scopes
  scope :recent,         ->{ order_by(created_at: :desc) } # newest first

end
