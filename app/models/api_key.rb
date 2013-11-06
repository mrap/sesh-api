class ApiKey
  include Mongoid::Document

  after_initialize :set_access_token

  belongs_to :user
  field :access_token
  validates :access_token, presence: true, uniqueness: true

  private

    def set_access_token
      self.access_token ||= ApiKey.unique_token
    end

    def self.unique_token
      loop do
        new_token = SecureRandom.hex
        return new_token unless ApiKey.where(access_token: new_token).exists?
      end
    end

    def self.find_user_with_token(token)
      return nil unless token.is_a?(String)
      api_key = ApiKey.find_by(access_token: token)
      return User.find(api_key.user_id)
    end

end
