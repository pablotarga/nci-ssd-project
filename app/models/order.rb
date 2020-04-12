class Order
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Enum

    belongs_to :user, inverse_of: :orders
    has_many :order_items, dependent: :destroy
    has_many :payments, inverse_of: :order, dependent: :destroy

    enum :status, [:pending, :waiting_payment, :accepted, :dispatched, :closed, :denied, :waiting_refund, :refunded]

    field :delivery_country, type: String
    field :delivery_administrative, type: String
    field :delivery_city, type: String
    field :delivery_address, type: String
    field :delivery_fee, type: Numeric, default: 0
    field :delivery_eta_date, type: DateTime
    field :total, type: Numeric, default: 0
    field :dispatch_at, type: DateTime

    def can_checkout?
        order_items.exists? && pending?
    end

    def calculate_total
        order_items.inject(0){|sum,e| sum += e.quantity * e.product.price}
    end

end
