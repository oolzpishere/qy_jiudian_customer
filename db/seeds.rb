# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product::Conference.create([
  {id: 1, name: "2019年秋季小学数学", start: "2019-09-13", finish: "2019-09-15", sale_from: "2019-09-13", sale_to: "2019-09-20"},
  {id: 2, name: "2019年秋小学语文", start: "2019-09-17", finish: "2019-09-19", sale_from: "2019-09-13", sale_to: "2019-09-26"}
  ])

hotels = Product::Hotel.create([
  {id: 1, name: "宜尚酒店（南宁青秀山店）", breakfast: 0, car: 0, tax_rate: 0.0, tax_point: 0.0, cover: nil, distance: nil, address: "青秀区柳园路8-1号"},
  {id: 2, name: "邕江宾馆", breakfast: 0, car: 0, tax_rate: 0.0, tax_point: 0.0, cover: nil, distance: nil, address: "青秀区临江路1号"}
  ])

Product::ConferenceHotel.create([
    {conference_id: 1, hotel_id: 1},
    {conference_id: 1, hotel_id: 2}
    ])

room_types = Product::RoomType.create([
  {id: 1, name: "双人房", name_eng: "twin_beds", position: 1},
  {id: 2, name: "大床房", name_eng: "queen_bed", position: 2},
  {id: 3, name: "三人间", name_eng: "three_beds", position: 3},
  {id: 4, name: "其它双人间", name_eng: "other_twin_beds", position: 4}
  ])

hotel_room_types = Product::HotelRoomType.create([
  {id: 1, hotel_id: 1, room_type_id: 1, price: 100, settlement_price: 80},
  {id: 2, hotel_id: 1, room_type_id: 2, price: 200, settlement_price: 180}
  ])

Product::DateRoom.create([
  {hotel_room_type_id: 1, date: "2021-01-02", rooms: 200},
  {hotel_room_type_id: 1, date: "2021-01-03", rooms: 100}
  ])

Account::Admin.create([
  {id: 1, email: ENV["TEST_ADMIN_EMAIL"], password: ENV["TEST_APP_PASSWORD"], password_confirmation: ENV["TEST_APP_PASSWORD"]}
  ])

Account::User.create([
  {id: 1, email: ENV["TEST_USER_EMAIL"], password: ENV["TEST_APP_PASSWORD"], password_confirmation: ENV["TEST_APP_PASSWORD"]}
  ])
