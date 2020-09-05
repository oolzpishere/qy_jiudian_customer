module Admin
  class UpdateRooms

    attr_reader :order, :hotel, :new_params
    def initialize( order: nil, new_params: nil)
      @order = order
      @hotel = order.hotel

      @new_params = new_params
      # new_params['hotel']
      # new_params['room_type']
      # new_params['checkin']
      # new_params['checkout']
      # new_params['rooms_attributes'] length

    end

    # same_hotel_and_rt only need one room_type obj, restore and apply new change to it.
    def update
      if same_hotel_and_rt?
        same_hotel_and_rt_proc
      else
        diff_hotel_and_rt_proc
      end
    end

    def same_hotel_and_rt_proc
      # room_type = RoomType.new(room_type_rec)
      room_type = RoomType.new(order.hotel)

      # @room_type restore
      date_range = get_date_range(order.checkin, order.checkout)
      room_type.change_rooms(order.room_type, date_range, order.rooms.length)
      # TODO: if difference hotel_room_type, before change_rooms will not save.

      # @room_type check_available for new order_params
      # !!stop proccess if check not available.
      new_date_range = get_date_range(order_params.checkin, order_params.checkout)
      raise "Don't have enough rooms for new order." unless room_type.check_available(order_params[:room_type], new_date_range, order_params.rooms_attributes.compact.length)

      # @room_type change_rooms(room_type, order_params.checkin, order_params.checkout, order_params.rooms_attributes.length)
      room_type.change_rooms(room_type, order_params.checkin, order_params.checkout, order_params.rooms_attributes.length)

      # save all changes.
      room_type.apply_changes
    end

    def diff_hotel_and_rt_proc
      # old_room_type = RoomType.new(room_type_rec)
      @old_room_type = RoomType.new(order.hotel)
      # new_room_type = RoomType.new(room_type_rec)
      @new_room_type = RoomType.new(order_params.hotel)

      # @new_room_type check_available(room_type, order_params.checkin, order_params.checkout, order_params.rooms_attributes.length)
      # @old_room_type restore(order.checkin, order.checkout, order.rooms.length) rooms.
      # @new_room_type change_rooms(room_type, order_params.checkin, order_params.checkout, order_params.rooms_attributes.length)
      # save @old_room_type and @new_date_rooms(room_type, order_params.checkin, order_params.checkout).
    end

    def decrease_rooms

    end

    def restore_rooms
      room_type_name_eng = order.room_type
      date_range_arr = get_date_range_arr(order.checkin, order.checkout)
      change_rooms = order.rooms.length
      if room_type_name_eng && date_range_arr && change_rooms
        date_rooms.change_rooms(room_type_name_eng, date_range_arr, change_rooms)
      end
    end

    def get_date_range_arr(start_date, end_date)
      date_range_array = (start_date..end_date).to_a
      date_range_array.pop
      date_range_array
    end

    private
    # old hotel and room_type equal new hotel and room_type?
    def same_hotel_and_rt?
      same_hotel? = order.hotel.name == Hotel.find(new_params['hotel']).name
      same_room_type? = order.room_type == new_params['room_type']
    end

    # get date_range_array
    # @params:
    #   checkin: String or Date
    #   checkout: String or Date
    # @return: [date_inst, date_inst...], Date instance array.
    def get_date_range(checkin, checkout)
      checkin_date = Date.parse(checkin)
      checkout_date = Date.parse(checkout)
      date_range_array = (checkin_date..checkout_date).to_a
      date_range_array.pop
      date_range_array
    end

    def get_room_type_rec(hotel_id, room_type_name_eng)
      Product::HotelRoomType.joins(:room_type).where(hotel: hotel_id, room_types: {name_eng: room_type_name_eng}).first
    end


  end
end
