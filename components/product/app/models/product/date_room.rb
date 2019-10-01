module Product
  class DateRoom < ApplicationRecord
    self.table_name = :date_rooms

    belongs_to :hotel_room_type
  end
end
