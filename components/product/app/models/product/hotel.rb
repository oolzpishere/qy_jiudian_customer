module Product
  class Hotel < ApplicationRecord
    self.table_name = :hotels

    has_many :conference_hotels
    has_many :conferences, through: :conference_hotels
    # accepts_nested_attributes_for :conferences, reject_if: :all_blank
    has_many :hotel_room_types
    has_many :room_types, through: :hotel_room_types
    accepts_nested_attributes_for :hotel_room_types, reject_if: :all_blank, allow_destroy: true

  end
end
