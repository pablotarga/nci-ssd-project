class Person < User
  include ActiveModel::SecurePassword

  field :title, type: String
  field :email, type: String
  field :name, type: String
  field :password_digest, type: String

  field :reset_token, type: String
  field :reset_token_expire_at, type: DateTime

  field :admin, type: Boolean, default: false

  field :current_auth_at, type: DateTime
  field :current_auth_ip, type: String
  field :last_auth_at, type: DateTime
  field :last_auth_ip, type: String

  has_secure_password

  validates :email, uniqueness: true, presence: true, allow_blank: false
  validates :name, length: {minimum: 10}

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

  def has_last_auth_info?
    last_auth_at.present?
  end

  def has_shopping_cart?
    orders.pending.exists?
  end
end
