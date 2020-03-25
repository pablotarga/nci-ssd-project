
if Rails.env.test?
  Product.create([
    {title: "God of War 3", quantity: 100, price: 49.99, cost: 23.00, description: 'Short description...'},
    {title: "Borderland 3", quantity: 73, price: 49.99, cost: 29.00, description: 'Shoot-and-loot'},
    {title: "Mario Kart 8", quantity: 23, price: 49.99, cost: 24.00, description: 'It\'s a me!'},
    {title: "PS4 Pro", quantity: 30, price: 499.99, cost: 310.00, description: 'Game console'}
  ])
end
