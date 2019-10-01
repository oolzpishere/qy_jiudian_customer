module Product
  class RoomType < ApplicationRecord
    self.table_name = :room_types

    has_many :hotel_room_types
    has_many :hotels, through: :hotel_room_types

    # Product::RoomType.create(name: "标准双人间", name_eng: "twin_beds", position: 10)
    # Product::RoomType.create(name: "标准单人间", name_eng: "queen_bed", position: 20)

    # Product::RoomType.create(name: "商务双人间", name_eng: "business_twin_beds", position: 30)
    # Product::RoomType.create(name: "豪华双人间", name_eng: "luxury_twin_beds", position: 40)

    # Product::RoomType.create(name: "商务单人间", name_eng: "business_queen_bed", position: 50)
    # Product::RoomType.create(name: "豪华单人间", name_eng: "luxury_queen_bed", position: 60)

    # Product::RoomType.create(name: "三人间", name_eng: "three_beds", position: 70)
    # Product::RoomType.create(name: "其它双人间", name_eng: "other_twin_beds", position: 80)
  end
end
