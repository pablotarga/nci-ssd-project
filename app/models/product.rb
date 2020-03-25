class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Fetchable

  field :title, type: String
  field :quantity, type: Integer, default: 0
  field :price, type: Numeric, default: 0
  field :cost, type: Numeric, default: 0
  field :description, type: String
  field :highlighted, type: Boolean

  scope :search, ->(q){
    scoped
  }

  # required is the amount you need so if there is only 4 items in stock
  # product.in_stock? => true
  # product.in_stock?(4) => true
  # product.in_stock?(5) => false
  def in_stock?(required=nil)
    required ? quantity >= required : quantity > 0
  end
end
