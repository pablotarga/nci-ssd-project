class Person < User
  include ActiveModel::SecurePassword

  field :title, type: String
  field :email, type: String
  field :name, type: String
  field :password_digest, type: String

  field :reset_token, type: String
  field :reset_token_expire_at, type: DateTime

  field :admin, type: Boolean, default: false

  has_secure_password

  validates :email, uniqueness: true, presence: true, allow_blank: false

  def self.by_reset_token token
    where(:reset_token_expire_at.gt => Time.now, reset_token: token).actives.first
  end

  def setup_reset_token!
    self.reset_token_expire_at = 1.hour.from_now
    self.reset_token = SecureRandom.urlsafe_base64(64)
    self.save

    self.reset_token
  end

  def clear_reset_token!
    unset(:reset_token, :reset_token_expire_at)
  end
end
