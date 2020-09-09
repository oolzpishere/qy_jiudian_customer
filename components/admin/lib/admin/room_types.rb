module Admin
  class RoomTypes
    # @room_types: [room_type_obj, ....]
    attr_reader :room_types
    # add only one room_type, when initialize.
    # @params:
    #   hotel: instance, hotel record object.
    def initialize(order: nil, params: nil, hotel: nil, room_type: nil)
      @room_types = []
      add_room_type(order, params, hotel, room_type)

    end

    # @params:
    def add_new_room_type(order: nil, params: nil, hotel: nil, room_type: nil)
      add_room_type(order, params, hotel, room_type)
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

    def add_room_type(order, params, hotel, room_type)
      hotel_id, room_type_name_eng = get_hotel_id_and_rt(order: order, params: params, hotel: hotel, room_type: room_type)
      if room_type_exist?(hotel_id, room_type_name_eng)
        return
      else
        room_type_rec = get_room_type_rec(hotel_id, room_type_name_eng)
        room_type = Admin::RoomType.new(room_type_rec)
        room_types << room_type
      end
    end

    def room_type_exist?(hotel_id, room_type_name_eng)
      exist = false
      room_types.each do |rt|
        if rt.hotel_id == hotel_id && rt.room_type_name_eng == room_type_name_eng
          exist = true
          break
        end
      end
      return exist
    end

    def get_room_type_rec(hotel_id, room_type_name_eng)
      Product::HotelRoomType.joins(:room_type).where(hotel: hotel_id, room_types: {name_eng: room_type_name_eng}).first
    end

    def find_room_type(hotel_id, room_type_name_eng)
      room_types.each do |rt|
        if rt.hotel_id == hotel_id && rt.room_type_name_eng == room_type_name_eng
          return rt
        end
      end
    end

    def get_hotel_id_and_rt(order: nil, params: nil, hotel: nil, room_type: nil)
      hotel_id = nil
      room_type_name_eng = nil
      if hotel
        hotel_id = get_hotel_id(hotel)
      end

      if room_type
        room_type_name_eng = room_type
      end
      # if setted before, not override.
      if order
        hotel_id ||= order.hotel.id
        room_type_name_eng ||= order.room_type
      end
      # if setted before, not override.
      if params
        hotel_id ||= params[:hotel_id]
        room_type_name_eng ||= params[:room_type]
      end
      return hotel_id, room_type_name_eng
    end

    def get_hotel_id(hotel)
      if hotel.is_a?(Integer)
        hotel
      elsif hotel.is_a?(Product::Hotel)
        hotel.id
      end
    end

  end
end
