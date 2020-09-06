module Admin
  class DateRoom

    attr_accessor :rooms, :date, :changed
    # @params:
    #   date_room_rec: date_room record
    # data:
    #   date: read from db is Date instance.
    def initialize(date_room_rec)
      @rooms ||= date_room_rec.rooms
      @date ||= date_room_rec.date
      @changed ||= false
    end

    # @params:
    #   date: Date instance or date string.
    def same_date?(compare_date)
      if compare_date.is_a?(String)
        compare_date = Date.parse(compare_date)
      end
      date == compare_date
    end


  end
end
