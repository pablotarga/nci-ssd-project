class Payment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  belongs_to :order, inverse_of: :payments

  enum :status, [:pending, :complete, :refunding, :canceled, :failed]

  field :total, type: Float, default: 0
  field :provider, type: String
  field :provider_id, type: String

  validates :total, numericality: {greater_than: 0}
end
