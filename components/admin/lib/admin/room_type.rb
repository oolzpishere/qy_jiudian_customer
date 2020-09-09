module Admin
  class RoomType
    # @date_rooms: [date_obj, ....]
    attr_reader :hotel_room_type_rec, :date_rooms, :allow_change
    # @params:
    #   hotel: instance, hotel record object.
    def initialize(hotel_room_type_rec)
      @hotel_room_type_rec = hotel_room_type_rec
      @date_rooms = Admin::DateRooms.new(hotel_room_type_rec)

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

        if date_room
          date_room_num = date_room.rooms
          result = date_room_num + change_rooms > 0
          break unless result
        else
          result = false
          break
        end
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

    # @params:
    #   room_type_name_eng: String, room_type string.
    #   date:
    # @return: date_room record.
    def find_date_room_rec(date)
      # both date is Date instance.
      hotel_room_type_rec.date_rooms.find {|dr| dr.date == date.date}
    end

  end
end
