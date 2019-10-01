FactoryBot.define do
  factory :order, class: "Product::Order" do
    id {1}
    group {1}
    count {1}
    association :conference, factory: :conf
    association :hotel, factory: :hotel_with_hotel_room_types

    room_type {"twin_beds"}
    names {"one,two"}
    contact {"three"}
    phone {"15977793123"}
    price {220}
    breakfast {1}
    checkin {"2019-10-30"}
    checkout {"2019-11-1"}
    nights {2}
    total_price {660}
    factory :order_with_rooms do
      transient do
        rooms_count { 2 }
      end
      after(:create) do |order, evaluator|
        create_list(:room, evaluator.rooms_count, order_id: order.id)
      end
    end
  end

  factory :room, class: "Product::Room" do
    names {"one,two"}
    room_number {112}
  end

  factory :order_new, class: "Product::Order" do
    id {1}
    group {2}
    count {1}
    association :conference, factory: :conf
    # conf
    # conference_id {""}
    hotel
    # hotel_id {""}
    room_type {"twin_beds"}
    names {"one,two"}
    contact {"three"}
    phone {"15977793123"}
    price {220}
    breakfast {1}
    checkin {"2019-10-28"}
    checkout {"2019-11-3"}
    nights {"5"}
    total_price {1100}
    # rooms_attributes:
  end

end
