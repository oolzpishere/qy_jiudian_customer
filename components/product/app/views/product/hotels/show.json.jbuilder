json.(@hotel, :name, :breakfast, :car, :tax_rate, :tax_point, :created_at, :updated_at)

# HasMany room_types
json.room_types @hotel.room_types do |room_type|
  json.(room_type, :id, :name, :name_eng)
end

# HasMany hotel_room_types
# .order(:position)
json.hotel_room_types @hotel.hotel_room_types do |hotel_room_type|
  json.(hotel_room_type, :id, :hotel_id, :room_type_id, :price, :settlement_price)
  json.name hotel_room_type.room_type.name
  json.name_eng hotel_room_type.room_type.name_eng
  # HasMany date_rooms
  json.date_rooms hotel_room_type.date_rooms.order(:date) do |date_room|
    json.(date_room, :id, :hotel_room_type_id, :date, :rooms)
  end
end
