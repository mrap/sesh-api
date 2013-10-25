class Sesh
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  scope :recent, ->{ order_by(created_at: :desc) }

  field   :title
  belongs_to :author, class_name: 'User', inverse_of: :seshes
  field :is_anonymous, type: Boolean, default: false
  has_mongoid_attached_file :audio, dependent: :destroy
  validates_presence_of :author

  before_create :set_default_title

  private

    def set_default_title
      self.title ||= self.id.to_s
    end

end
