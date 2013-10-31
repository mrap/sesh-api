class Sesh
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  # Relations
  belongs_to :author,   class_name: 'User', inverse_of: :seshes
  has_and_belongs_to_many :favoriters, class_name: 'User', inverse_of: :favorite_seshes

  # Fields
  field :title,             type: String
  field :is_anonymous,      type: Boolean,  default: false
  field :favoriters_count,  type: Integer,  default: 0
  field :listeners_ids,     type: Array,    default: []
  field :listens_count,     type: Integer,  default: 0

  # Assets
  has_mongoid_attached_file :audio, dependent: :destroy

  # Validations
  validates_presence_of :author

  # Named Scopes
  scope :recent,         ->{ order_by(created_at: :desc) } # newest first
  scope :anonymous_only, ->{ where(is_anonymous: true) }
  scope :most_favorited, ->{ order_by(favoriters_count: :desc) }

  before_create :set_default_title
  before_save   :refresh_favoriters_count

  def add_user_id_to_listeners_ids(user_id)
    if User.where(id: user_id).exists? and not self.listeners_ids.include? user_id
      self.listeners_ids << user_id
      self.listens_count = self.listeners_ids.count
    end
  end

  private

    def refresh_favoriters_count
      self.favoriters_count = self.favoriters.count
    end

    def set_default_title
      self.title ||= self.id.to_s
    end

    def valid_scope?(scope)
      vaild_scopes = ["recent", "anonymous_only", "most_favorited"]
      valid_scopes.include?(scope)
    end

end
