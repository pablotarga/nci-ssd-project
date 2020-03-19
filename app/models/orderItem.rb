class orderItem
    belongs_to :order
    belongs_to :product

    field :quantity, type: Integer    
end