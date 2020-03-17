class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :quantity, type: Integer, default: 0
  field :price, type: Numeric, default: 0
  field :cost, type: Numeric, default: 0
  field :description, type: String
  field :highlighted, type: Boolean
end
