class order
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user
    has_many :orderItem
    has_many :payments

    field :status, type: String
    field :delivery_country, type: String
    field :delivery_administrative, type: String
    field :delivery_city, type: String
    field :delivery_address, type: String
    field :delivery_fee, type: Numeric, default: 0
    field :delivery_eta_date, type: DateTime
    field :total, type: Numeric, default: 0
    field :dispatch_at, type: DateTime

    def pending!
        update_attribute :status, "pending"
    end

    def waiting_payment!
        update_attribute :status, "waiting_payment"
    end

    def accepted!
        update_attribute :status, "accepted"
    end

    def dispatched!
        update_attribute :status, "dispatched"
    end

    def closed!
        update_attribute :status, "closed"
    end

    def denied!
        update_attribute :status, "denied"
    end

    def waiting_refund!
        update_attribute :status, "waiting_refund"
    end

    def refunded!
        update_attribute, :status, "refunded"
    end
end