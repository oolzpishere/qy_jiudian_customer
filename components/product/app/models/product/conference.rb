module Product
  class Conference < ApplicationRecord
    self.table_name = :conferences

    has_many :conference_hotels
    has_many :hotels, through: :conference_hotels
  end
end
