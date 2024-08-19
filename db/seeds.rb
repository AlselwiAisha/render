# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user1 = User.create(name: 'Aisha', password: '654321', password_confirmation: '654321', email: 'aisha@gmail.com')
user2 = User.create(name: 'Moathal', password: '123456', password_confirmation: '123456', email: 'moathal@mail.com')
group = Group.create!(name: 'something')
proto = Prototype.create!(group:, name: 'someproto')
shop = Shop.create!(name: 'kabeer', phone: 'bigNum', location: 'address', website: 'www.kabeer.com')
product = Product.create!(prototype: proto, shop:, name: 'horse', price: 300)
work = Work.create!(name: 'sanding', shop:)
product_work = ProductWork.create!(work:, product:, percent: 0.3)
shop_employee1 = ShopEmployee.create!(user: user1, shop:, role: 'employee')
shop_employee2 = ShopEmployee.create!(user: user2, shop:, role: 'owner')
DetailsOfWork.create!(shop_employee: shop_employee1, product_work:, percent_done: '1',
                      start_date: '2022-07-22 18:01:48')
