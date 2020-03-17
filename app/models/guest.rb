class Guest < User
  before_validation :set_expiration_date, on: :create

  field :expiry_at, type: DateTime

  private

  def set_expiration_date
    self.expiry_at = 1.week.from_now
  end
end
