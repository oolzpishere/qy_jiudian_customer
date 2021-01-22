module Admin
  class UpdateRooms
    class RoomTypes
      # @room_types: [room_type_obj, ....]
      attr_reader :room_types
      # add only one room_type, when initialize.
      # @params:
      #   hotel: instance, hotel record object.
      def initialize(hotel: nil, room_type: nil)
        @room_types = []
        add_room_type(hotel, room_type)

      end

      def add_room_type(hotel, room_type)
        hotel_id = get_hotel_id(hotel)
        room_type_name_eng = room_type

        # check hotel_id and room_type_name_eng and find_room_type success.
        return false if find_room_type(hotel_id, room_type_name_eng)

        if hotel_id && room_type_name_eng
          room_type_rec = get_room_type_rec(hotel_id, room_type_name_eng)
          return false unless room_type_rec
          room_type = UpdateRooms::RoomType.new(room_type_rec)
          room_types << room_type
        else
          return false
        end
      end

      # @params:
      #   hotel: hotel object or hotel_id
      #   room_type: room_type_name_eng
      def check_available(hotel, room_type, date_range_arr, change_rooms)
        hotel_id = get_hotel_id(hotel)
        room_type = find_room_type(hotel_id, room_type)
        if room_type
          room_type.check_available(date_range_arr, change_rooms)
        else
          return false
        end
      end

      # @params:
      #   hotel: hotel object or hotel_id
      #   room_type: room_type_name_eng
      def change_rooms(hotel, room_type, date_range_arr, change_rooms)
        hotel_id = get_hotel_id(hotel)
        room_type = find_room_type(hotel_id, room_type)
        if room_type
          room_type.change_rooms(date_range_arr, change_rooms)
        end
      end

      def apply_changes
        date_rooms.each do |dr|
          dr.apply_changes
        end
      end

      private

      def get_room_type_rec(hotel_id, room_type_name_eng)
        Product::HotelRoomType.joins(:room_type).where(hotel: hotel_id, room_types: {name_eng: room_type_name_eng}).first
      end

      def find_room_type(hotel_id, room_type_name_eng)
        return false unless hotel_id || room_type_name_eng
        result_room_type = nil
        room_types.each do |rt|
          same_hotel = ( rt.data("hotel_id").to_s == hotel_id.to_s )
          same_room_type = ( rt.data("room_type_name_eng") == room_type_name_eng.to_s )
          result_room_type = rt if same_hotel && same_room_type
        end
        return result_room_type
      end

      def get_hotel_id(hotel)
        if hotel.is_a?(Product::Hotel)
          hotel.id
        else
          hotel
        end
      end

    end
  end
end
