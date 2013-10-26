class User
  include Mongoid::Document
  include Mongoid::Slug

  # Relations
  has_many :seshes, class_name: 'Sesh', inverse_of: :author, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # Fields
  field :username
  slug  :username

  # Validations
  validates :username,
    presence: true,
    uniqueness: true,
    format: { with: /\A[a-zA-Z0-9]+\Z/ } # no whitespace

  # Devise
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  field :authentication_token, :type => String
  after_initialize :ensure_authentication_token!

  def favorite_sesh(sesh)
    if sesh.is_a?(Sesh)
      Favorite.create!(favoriter: self, favorited: sesh)
    end
  end

  def public_sesh_ids
    self.seshes.map { |sesh| sesh.id unless sesh.is_anonymous }.compact
  end

end
