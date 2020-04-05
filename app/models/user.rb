class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :locale, type: String, default: 'en'

  has_many :orders, inverse_of: :user, dependent: :destroy
end
