module Admin
  class DateRooms
    # TODO: set date string format
    # DateFormat="xxx"
    attr_reader :hotel_room_type_rec, :date_rooms
    # @params:
    # date_room_rec: date_room record
    def initialize(hotel_room_type_rec)
      @hotel_room_type_rec = hotel_room_type_rec
      init_drs

    end

    def all
      @date_rooms
    end

    #
    def find_date_room(date)
      self.all.each do |date_room|
        return date_room if date_room.same_date?(date)
      end
    end

    #++output for views
    # @params:
    #   order: :inc || :desc, increse or descend order.
    def sort_dates(order: :inc )
      inc_dates_arr = self.all.sort { |a, b| a <=> b }
      if order == :inc
        inc_dates_arr
      elsif order == :desc
        inc_dates_arr.reverse
      end
    end

    private

    def init_drs
      @date_rooms ||= []
      hotel_room_type_rec.date_rooms.each do |dr|
        date_room = Admin::DateRoom.new(dr)
        @date_rooms << date_room
      end
    end


  end
end
