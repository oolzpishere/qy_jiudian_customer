FactoryBot.define do
  factory :hotel, class: "Product::Hotel" do
    id {1}
    name {"hotel"}
    conference_ids {["1"]}
    breakfast {"0"}
    car {"0"}
    tax_rate {"0.15"}
    tax_point {"10"}

    factory :hotel_with_hotel_room_types do

      after(:create) do |hotel, evaluator|
        room_type_first = create(:room_type)
        room_type_second = create(:room_type, name: "标准单人间", name_eng: "queen_bed", position: "20")

        hotel_room_type_first = create(:hotel_room_type, hotel: hotel, room_type: room_type_first)
        hotel_room_type_second = create(:hotel_room_type, hotel: hotel, room_type: room_type_second, price: 200, settlement_price: 300)

        create(:date_room_first, hotel_room_type: hotel_room_type_first)
        create(:date_room_second, hotel_room_type: hotel_room_type_first)

        # create_list(:hotel_room_type, evaluator.hotel_room_types_count, hotel: hotel)
      end
    end
  end

  factory :hotel_room_type, class: "Product::HotelRoomType" do
    # hotel
    # room_type_first
    price { "100" }
    settlement_price {"200"}
  end

  factory :room_type, class: "Product::RoomType" do
    name {"标准双人间"}
    name_eng {"twin_beds"}
    position {"10"}
  end

  factory :date_room_first, class: "Product::DateRoom" do
    date {"2019-10-30"}
    rooms {25}
  end

  factory :date_room_second, class: "Product::DateRoom" do
    date {"2019-10-31"}
    rooms {25}
  end

  factory :hotel_new, class: "Product::Hotel" do
    id {1}
    name {"hotel-name-new"}
    conference_ids {["1"]}

    breakfast {"0"}
  end
end
