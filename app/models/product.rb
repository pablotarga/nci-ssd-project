class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Fetchable

  field :title, type: String
  field :quantity, type: Integer, default: 0
  field :price, type: Float, default: 0
  field :cost, type: Float, default: 0
  field :description, type: String
  field :image_url, type: String
  field :highlighted, type: Boolean
  field :tags, type: Array, default: []

  def self.search(q)
    return all unless q.present?

    full_text_search(q, match: :any)
  end

  search_in :title, :description, :tags

  # required is the amount you need so if there is only 4 items in stock
  # product.in_stock? => true
  # product.in_stock?(4) => true
  # product.in_stock?(5) => false
  def in_stock?(required=nil)
    required ? quantity >= required : quantity > 0
  end

  def tag_list
    tags.join(", ")
  end

  def tag_list=(v)
    self.tags = v.split(",").map(&:strip)
  end


end
