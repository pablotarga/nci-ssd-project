class Admin::DashboardController < AdminController

  def show
    @counters = {
      products: Product.count,
      users: User.count,
      people: Person.count,
      guests: Guest.count,
      orders: Order.count
    }
  end
end
