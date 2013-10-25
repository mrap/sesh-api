class Sesh
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  # Relations
  belongs_to :author,   class_name: 'User', inverse_of: :seshes
  has_many :favorites,  as: :favorited

  # Fields
  field :title,         type: String
  field :is_anonymous,  type: Boolean,  default: false

  # Assets
  has_mongoid_attached_file :audio, dependent: :destroy

  # Validations
  validates_presence_of :author

  # Named Scopes
  scope :recent, ->{ order_by(created_at: :desc) }
  scope :anonymous_only, ->{ where(is_anonymous: true)  }

  before_create :set_default_title

  private

    def set_default_title
      self.title ||= self.id.to_s
    end

end
