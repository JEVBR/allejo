# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Seeding categories"
Category.create(name: 'Campo')
Category.create(name: 'Society')
Category.create(name: 'Futsal')
puts "Categories seeded"

puts "Seeding positions(player)"
Position.create(name: 'Atacante')
Position.create(name: 'Zagueiro')
Position.create(name: 'Goleiro')
Position.create(name: 'Meio de campo')
puts "Positions added"
# puts "Creating test user"
# User.create(email: 'test@test.com', password: '123123', first_name: 'test', last_name: 'last_name', phone: 12341234, nickname: 'nickname', address: 'address', cpf:1111, owner: true)
# puts "Test user created"

# puts "Creating test Pitch"
# Pitch.create(title: 'Campo do Ze', user_id: 1, category_id: 1, title: 'vem jogar', cep: 12341234, cnpj: 1111111, address: 'rua mourato coelho 1404 Sao Paulo', price:80)
# puts "Test pitch created"



Tag = "photo"
seeds = YAML.load_file('seeds.yml')


puts 'Creating users...'
users = {}  # slug => Director
seeds["users"].each do |user|
  temp = User.create! user.slice(
                              "first_name",
                               "last_name",
                               "phone",
                               "nickname",
                               "password",
                               "email",
                               "address",
                               "cpf",
                               "position_id",
                               "owner")
  temp.remote_photo_url = user.slice(Tag)[Tag.to_s]
  temp.save
  p "saving:"
  p temp
  p "------------------------------"
end

puts 'Creating Pitches...'
pitches = {}  # slug => Director
seeds["pitches"].each do |pitch|
  temp = Pitch.create! pitch.slice(
                              "address",
                              "user_id",
                              "description",
                              "phone",
                              "company",
                              "title",
                              "price",
                              "cep",
                              "description",
                              "category_id",
                              "cnpj",
                              "opening_time",
                              "closing_time")
  #x.remote_photo_url = "http://res.cloudinary.com/dpkbckolo/image/upload/v1550847678/zgchnp4dlgst2hglh8go.jpg"
  temp.remote_photo_url = pitch.slice(Tag)[Tag.to_s]
  temp.save
  p "saving:"
  p temp
  p "------------------------------"
end

