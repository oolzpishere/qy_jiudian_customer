module Product
  class ConferenceHotel < ApplicationRecord
    self.table_name = :conferences_hotels

    belongs_to :conference
    belongs_to :hotel
  end
end
