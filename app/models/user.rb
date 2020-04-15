class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :locale, type: String, default: 'en'

  has_many :orders, inverse_of: :user, dependent: :destroy

  def has_shopping_cart?
    orders.pending.exists?
  end

  def has_previous_orders?
    orders.accepted.exists?
  end

end
