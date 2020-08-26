module Admin
  class DateRooms
    # @date_rooms
    # {"room_type1" => {"date" => rooms_num,
    #                   "date2" => rooms_num2...},
    # "room_type2" => {...}}
    attr_reader :hotel, :date_rooms
    def initialize(hotel)
      @hotel = hotel
      init_drs
    end

    # +check_available(date_range_arr, room_type, change_rooms)
    # @params:
    #   date_range_arr: Array, array of date string.
    #   room_type_name_eng: String, room_type string.
    #   rooms: Integer, number of change rooms.
    def check_available(date_range_arr, room_type_name_eng, change_rooms)
      date_range_arr.each do |date|
        room_type_hash = date_rooms[room_type_name_eng]
        return false unless room_type_hash

        date_room_num = room_type_hash[date]
        return false unless date_room_num

        result = date_room_num + change_rooms > 0
        result ? (return true) : (return false)
      end
    end

    # +apply_changes(date_range_arr, room_type, change_rooms)
    # @params:
    #   date_range_arr: Array, array of date string.
    #   room_type_name_eng: String, room_type string.
    #   rooms: Integer, number of change rooms.
    def apply_changes(date_range_arr, room_type_name_eng, change_rooms)
      return false unless check_available(date_range_arr, room_type, change_rooms)
      date_range_arr.each do |date|
        date_room_record = find_date_room_rec(room_type_name_eng, date)
        date_room_record.rooms = date_room_record.rooms + change_rooms
        date_room_record.save
      end
    end

    # output for views
    def order_room_type_drs(room_type)
      rt = date_rooms[room_type]
      raise "can't find this room_type" unless rt
      # order rt dates
      orderd_dates_arr = order_dates_arr(rt.keys)
      orderd_room_type_drs_hash = {}
      orderd_dates_arr.each do |date|
        orderd_room_type_drs_hash[date] = rt[date]
      end
      return orderd_room_type_drs_hash
    end

    private
    def init_drs
      @date_rooms = {}
      hotel.hotel_room_types.each do |hrt|
        date_rooms[hrt.room_type.name_eng] = {}
        set_drs(hrt)
      end
    end

    def set_drs(hotel_room_type)
      room_type_name = hotel_room_type.room_type.name_eng
      hotel_room_type.date_rooms.each do |dr|
        date = dr.date
        rooms_num = dr.rooms
        date_rooms[room_type_name][date] = rooms_num
      end
    end

    def order_dates_arr(dates_arr, order: :inc)
      inc_dates_arr = dates_arr.sort { |a, b| Date.parse(a) <=> Date.parse(b) }
      if order == :inc
        inc_dates_arr
      else
        inc_dates_arr.reverse
      end
    end

    def find_date_room_rec(room_type_name_eng, date)
      hrt = find_hotel_room_type_recs(room_type_name_eng)
      hrt.date_rooms.find {|dr| dr.date == date}
    end

    def find_hotel_room_type_recs(room_type_name_eng)
      Product::HotelRoomType.joins(:room_type).where(hotel: hotel, room_types: {name_eng: room_type_name_eng}).first
    end

  end
end
