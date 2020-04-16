class OrderItem
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :order
    belongs_to :product
    delegate :title, to: :product, prefix: true

    field :quantity, type: Integer, default: 0
    field :total, type: Float
end
