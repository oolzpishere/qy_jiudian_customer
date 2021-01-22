module Admin
  class UpdateRooms
    class RoomType
      # @date_rooms: [date_obj, ....]
      attr_reader :hotel_room_type_rec, :date_rooms, :allow_change, :room_type_name_eng
      # @params:
      #   hotel: instance, hotel record object.
      def initialize(hotel_room_type_rec)
        @hotel_room_type_rec = hotel_room_type_rec
        @room_type_name_eng = hotel_room_type_rec.room_type.name_eng
        init_drs

        @allow_change = false
      end

      def data(req)
        if self.try(req)
          self.send(req)
        else
          hotel_room_type_rec.send(req)
        end
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

          date_room = find_date_room(date)
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
          date_room = find_date_room(date)

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
        date_rooms.each do |date|
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
      #   order: :inc || :desc, increse or descend order.
      def sort_dates(order: :inc )
        inc_dates_arr = date_rooms.sort { |a, b| a <=> b }
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
          date_room = UpdateRooms::DateRoom.new(dr)
          @date_rooms << date_room
        end
      end

      # @params:
      #   room_type_name_eng: String, room_type string.
      #   date:
      # @return: date_room record.
      def find_date_room_rec(date)
        # both date is Date instance.
        hotel_room_type_rec.date_rooms.find {|dr| dr.date == date.date}
      end

      def find_date_room(date)
        result_date_room = nil
        date_rooms.each do |date_room|
          if date_room.same_date?(date)
            result_date_room = date_room
            break
          end
        end
        result_date_room || false
      end


    end
  end
end
