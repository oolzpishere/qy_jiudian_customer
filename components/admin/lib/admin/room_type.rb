module Admin
  class RoomType
    # @date_rooms: [date_obj, ....]
    attr_reader :hotel_room_type_rec, :date_rooms, :allow_change
    # @params:
    #   hotel: instance, hotel record object.
    def initialize(hotel_room_type_rec)
      @hotel_room_type_rec = hotel_room_type_rec
      @date_rooms = Admin::DateRooms.new(hotel_room_type_rec)
      # init_drs
      @allow_change = false
    end

    #++
    # @params:
    #   date_range_arr: [date_inst, date_inst...], Date instance array.
    def change_rooms(date_range_arr, change_rooms)
      return false unless check_available(date_range_arr, change_rooms)
      # date_range_arr = date_obj_to_str_arr(date_range_arr)
      date_range_arr.each do |date|
        # return false unless date_rooms[room_type_name_eng] && date_rooms[room_type_name_eng][date]
        # new_room_num = date_rooms_getter(room_type_name_eng, date, k: :rooms) + change_rooms
        # date_rooms_setter(room_type_name_eng, date, k: :rooms, v: new_room_num)

        date_room = date_rooms.find_date_room(date)
        new_room_num = date_room.rooms + change_rooms
        date_room.rooms=(new_room_num)
        date_room.changed=(true)
      end
    end

    # change_rooms then apply_changes.
    def change_rooms!(date_range_arr, change_rooms)
      change_rooms(date_range_arr, change_rooms)
      self.apply_changes
    end

    #++
    # @params:
    #   room_type_name_eng: String, room_type string.
    #   date_range_arr: Array, array of date string.
    #   change_rooms: Integer, number of change rooms.
    def check_available(date_range_arr, change_rooms)
      result = nil
      date_range_arr.each do |date|
        # room_type_hash = date_rooms[room_type_name_eng]
        # return false unless room_type_hash

        # date_room_num = room_type_hash[date]
        date_room = date_rooms.find_date_room(date)
        date_room_num = date_room.rooms if date_room

        result = date_room_num + change_rooms > 0
        break unless result
      end
      result ? (allow_change = true) : (allow_change = false)
      result
    end

    #++ apply all changed date rooms.
    def apply_changes
      date_rooms.all.each do |date|
        if date.changed == true
          new_rooms_num = date.rooms
          date_room_record = find_date_room_rec(date)
          date_room_record.rooms = new_rooms_num
          date_room_record.save
        end
      end
    end

    #++output for views
    # @params:
    #   room_type_name_eng: String, room_type string.
    def sort_room_type_drs(room_type_name_eng, order = :inc )
      rt = date_rooms[room_type]
      raise "can't find this room_type" unless rt
      # sort room_type dates
      sorted_dates_arr = sort_dates_arr(rt.keys, order: order)
      sorted_room_type_drs_hash = {}
      sorted_dates_arr.each do |date|
        ordered_room_type_drs_hash[date] = rt[date]
      end
      return sorted_room_type_drs_hash
    end

    private

    # def init_drs
    #   @date_rooms = []
    #   hotel_room_type_rec.date_rooms.each do |dr|
    #     date_room = Admin::DateRoom.new(dr)
    #     @date_rooms << date_room
    #     # TODO delete commented
    #     # date = dr.date
    #     # rooms_num = dr.rooms
    #     # date_rooms[room_type_name][date] = rooms_num
    #   end
    #   # date_rooms[hotel_room_type.room_type.name_eng] = {}
    #   # set_drs(hrt)
    # end
    # TODO delete commented
    # def set_drs(hotel_room_type)
    #   room_type_name = hotel_room_type.room_type.name_eng
    #   hotel_room_type.date_rooms.each do |dr|
    #     date = dr.date
    #     rooms_num = dr.rooms
    #     date_rooms[room_type_name][date] = rooms_num
    #   end
    # end



    # @params:
    #   room_type_name_eng: String, room_type string.
    #   date:
    # @return: date_room record.
    def find_date_room_rec(date)
      # both date is Date instance.
      hotel_room_type_rec.date_rooms.find {|dr| dr.date == date.date}
    end

    # def find_hotel_room_type_recs(room_type_name_eng)
    #   Product::HotelRoomType.joins(:room_type).where(hotel: hotel, room_types: {name_eng: room_type_name_eng}).first
    # end

    # def date_obj_to_str_arr(date_array)
    #   if date_inst_array.first.is_a?(Date)
    #     date_inst_array.map { |date| date.to_s }
    #   else
    #     date_array
    #   end
    # end

    # def date_rooms_getter(room_type, date = nil, k: nil)
    #   if room_type && (date == nil) && (k == nil)
    #     date_rooms.dig(room_type)
    #   elsif room_type && date && (k == nil)
    #     date_rooms.dig(room_type, date)
    #   elsif room_type && date && k
    #     date_rooms.dig(room_type, date, k)
    #   end
    # end
    #
    # def date_rooms_setter(room_type, date = nil, k: nil, v: nil)
    #   return false unless rt = date_rooms.dig(room_type)
    #   if date && k && rt[date]
    #     rt[date][k] = v
    #   end
    # end

  end
end
