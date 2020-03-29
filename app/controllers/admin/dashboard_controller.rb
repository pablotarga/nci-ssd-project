class Admin::DashboardController < AdminController

  def show
    @counters = {
      products: Product.count,
      users: User.count,
      people: Person.count,
      guests: Guest.count,
      orders: 123
    }
  end
end
