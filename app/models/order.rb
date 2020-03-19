class Order
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Enum

    belongs_to :user
    has_many :order_items
    #has_many :payments

    enum :status, [:pending, :waiting_payment, :accepted, :dispatched, :closed, :denied, :waiting_refund, :refunded]

    field :delivery_country, type: String
    field :delivery_administrative, type: String
    field :delivery_city, type: String
    field :delivery_address, type: String
    field :delivery_fee, type: Numeric, default: 0
    field :delivery_eta_date, type: DateTime
    field :total, type: Numeric, default: 0
    field :dispatch_at, type: DateTime

end