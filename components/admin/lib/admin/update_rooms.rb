module Admin
  class UpdateRooms

    attr_reader :order, :hotel, :new_params, :new_date_range, :new_change_rooms, :new_hotel, :new_room_type_str
    def initialize( order: nil, new_params: nil)
      if order
        @order = order
        @hotel = order.hotel
      end


      @new_params = new_params
      @new_date_range = get_date_range(new_params[:checkin], new_params[:checkout])
      # decrease rooms for new order.
      @new_change_rooms = -new_params[:rooms_attributes].compact.length
      @new_hotel = new_params[:hotel]
      @new_room_type_str = new_params[:room_type]
      # new_params['checkin']
      # new_params['checkout']
      # new_params['rooms_attributes'] length

    end

    def create
      new_room_type_rec = get_room_type_rec(new_hotel, new_room_type_str)
      new_room_type = Admin::RoomType.new(new_room_type_rec)

      raise "Don't have enough rooms for new order." unless new_room_type.check_available( new_date_range, new_change_rooms)

      # new_room_type change_rooms(new_date_range, new_change_rooms)
      # change_rooms! == change_rooms and apply_changes
      new_room_type.change_rooms!(new_date_range, new_change_rooms)
    end

    # same_hotel_and_rt only need one room_type obj, restore and apply new change to it.
    def update
      if same_hotel_and_rt?
        same_hotel_and_rt_proc
      else
        diff_hotel_and_rt_proc
      end
    end

    def delete
      old_room_type_rec = get_room_type_rec(order.hotel, order.room_type)
      old_room_type = Admin::RoomType.new(old_room_type_rec)

      # old_room_type restore(old_date_range, order.rooms.length) rooms.
      old_date_range = get_date_range(order.checkin, order.checkout)
      old_room_type.change_rooms!(old_date_range, order.rooms.length)
    end

    def check_available
      if order.nil?
        new_room_type_rec = get_room_type_rec(new_params.hotel, new_params.room_type)
        new_room_type = Admin::RoomType.new(new_room_type_rec)

        # new_room_type check_available for new new_params
        # return false if check not available.
        new_room_type.check_available( new_date_range, new_change_rooms)
      else
        room_type_rec = get_room_type_rec(order.hotel, order.room_type)
        room_type = RoomType.new(room_type_rec)

        # @room_type restore
        date_range = get_date_range(order.checkin, order.checkout)
        room_type.change_rooms(date_range, order.rooms.length)

        room_type.check_available(new_date_range, new_change_rooms)
      end
    end

    def same_hotel_and_rt_proc
      room_type_rec = get_room_type_rec(order.hotel, order.room_type)
      room_type = RoomType.new(room_type_rec)

      # @room_type restore
      date_range = get_date_range(order.checkin, order.checkout)
      room_type.change_rooms(date_range, order.rooms.length)

      # @room_type check_available for new order_params
      # !!stop proccess if check not available.
      new_date_range = get_date_range(new_params.checkin, new_params.checkout)
      new_change_rooms = -new_params.rooms_attributes.compact.length
      raise "Don't have enough rooms for new order." unless room_type.check_available( new_date_range, new_change_rooms)

      # @room_type.change_rooms(new_date_range, new_change_rooms)
      # change_rooms! == change_rooms and apply_changes
      room_type.change_rooms!(new_date_range, new_change_rooms)
    end

    def diff_hotel_and_rt_proc
      old_room_type_rec = get_room_type_rec(order.hotel, order.room_type)
      old_room_type = RoomType.new(old_room_type_rec)
      new_room_type_rec = get_room_type_rec(new_params.hotel, new_params.room_type)
      new_room_type = RoomType.new(new_room_type_rec)

      # new_room_type check_available for new new_params
      # !!stop proccess if check not available.
      new_date_range = get_date_range(new_params.checkin, new_params.checkout)
      new_change_rooms = -new_params.rooms_attributes.compact.length
      raise "Don't have enough rooms for new order." unless new_room_type.check_available( new_date_range, new_change_rooms)

      # old_room_type restore(old_date_range, order.rooms.length) rooms.
      old_date_range = get_date_range(order.checkin, order.checkout)
      old_room_type.change_rooms!(old_date_range, order.rooms.length)

      # new_room_type change_rooms(new_date_range, new_change_rooms)
      # change_rooms! == change_rooms and apply_changes
      new_room_type.change_rooms!(new_date_range, new_change_rooms)
    end

    def decrease_rooms

    end

    private
    # old hotel and room_type equal new hotel and room_type?
    def same_hotel_and_rt?
      same_hotel = (order.hotel.name == Hotel.find(new_params['hotel']).name)
      same_room_type = (order.room_type == new_params['room_type'])
      same_hotel && same_room_type
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
