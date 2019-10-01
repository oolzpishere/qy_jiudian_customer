module Product
  class HotelRoomType < ApplicationRecord
    self.table_name = :hotel_room_types

    belongs_to :hotel
    belongs_to :room_type

    has_many :date_rooms
    accepts_nested_attributes_for :date_rooms, reject_if: :all_blank, allow_destroy: true
  end
end
