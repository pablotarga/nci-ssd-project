class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :orders, inverse_of: :user
end
