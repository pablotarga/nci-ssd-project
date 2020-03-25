class OrderItem
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :order
    belongs_to :product

    field :quantity, type: Integer, default: 0
end
