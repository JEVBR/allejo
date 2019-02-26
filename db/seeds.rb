# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Seeding categories"
Category.create(name: 'Futsal')
Category.create(name: 'Society')
category = Category.create(name: 'Campo')
puts "Categories seeded"

puts "Creating test user"
user = User.create(email: 'test@test.com', password: '123123', first_name: 'test', last_name: 'last_name', phone: 12341234, nickname: 'nickname', address: 'address', cpf:1111, owner: true)
puts "Test user created"

puts "Creating test Pitch"
Pitch.create(title: 'Campo do Ze', user_id: 1, category_id: 1, subtitle: 'vem jogar', cep: 12341234, cnpj: 1111111, address: 'rua mourato coelho 1404 Sao Paulo', price:80)
puts "Test pitch created"
