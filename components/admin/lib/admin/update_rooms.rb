module Admin
  class UpdateRooms

    attr_reader :order, :org_order, :new_order, :new_params
    def initialize( order: nil, new_params: nil)
      if order
        @order = order
        @org_order = {
          hotel: order.hotel,
          room_type_str: order.room_type,
          change_rooms: order.rooms.length,
          date_range: get_date_range(order.checkin, order.checkout)
        }
      end

      if new_params
        @new_params = new_params
        @new_order = {
          date_range: get_date_range(new_params[:checkin], new_params[:checkout]),
          # decrease rooms for new order.
          change_rooms: -get_rooms_attributes_length(new_params[:rooms_attributes]),
          hotel: new_params[:hotel] || new_params[:hotel_id],
          room_type_str: new_params[:room_type]
        }
      end
    end

    def create
      new_room_type_rec = get_room_type_rec(new_order[:hotel], new_order[:room_type_str])
      new_room_type = UpdateRooms::RoomType.new(new_room_type_rec)

      raise "Don't have enough rooms for new order." unless new_room_type.check_available( new_order[:date_range], new_order[:change_rooms])

      # new_room_type change_rooms!(new_order[:date_range], new_order[:change_rooms])
      # change_rooms! is change_rooms and apply_changes
      new_room_type.change_rooms!(new_order[:date_range], new_order[:change_rooms])
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
      old_room_type_rec = get_room_type_rec(org_order[:hotel], org_order[:room_type_str])
      old_room_type = UpdateRooms::RoomType.new(old_room_type_rec)

      # old_room_type restore(old_date_range, org_order[:change_rooms]) rooms.
      # change_rooms! is change_rooms and apply_changes
      old_room_type.change_rooms!(org_order[:date_range], org_order[:change_rooms])
    end

    # TODO: need to know too much? have to remember to take order param when update.
    # TODO: use new_params order.id to find out need to restore or not.
    def check_available
      if order.nil?
        new_room_type_rec = get_room_type_rec(new_order[:hotel], new_order[:room_type_str])
        return false unless new_room_type_rec
        new_room_type = UpdateRooms::RoomType.new(new_room_type_rec)
        # new_room_type check_available for new new_params
        new_room_type.check_available( new_order[:date_range], new_order[:change_rooms])
      else
        room_types = UpdateRooms::RoomTypes.new(hotel: org_order[:hotel], room_type: org_order[:room_type_str])

        # restore original room_type
        room_types.change_rooms(org_order[:hotel], org_order[:room_type_str], org_order[:date_range], org_order[:change_rooms])

        # add_new_room_type then check new params available?
        room_types.add_room_type(new_order[:hotel], new_order[:room_type_str])
        room_types.check_available(new_order[:hotel], new_order[:room_type_str], new_order[:date_range], new_order[:change_rooms])
      end
    end

    def same_hotel_and_rt_proc
      room_type_rec = get_room_type_rec(org_order[:hotel], org_order[:room_type_str])
      room_type = UpdateRooms::RoomType.new(room_type_rec)

      # @room_type restore
      room_type.change_rooms(org_order[:date_range], org_order[:change_rooms])

      # @room_type check_available for new order_params
      # !!stop proccess if check not available.
      raise "Don't have enough rooms for new order." unless room_type.check_available( new_order[:date_range], new_order[:change_rooms])

      # @room_type.change_rooms(new_order[:date_range], new_order[:change_rooms])
      # change_rooms! == change_rooms and apply_changes
      room_type.change_rooms!(new_order[:date_range], new_order[:change_rooms])
    end

    def diff_hotel_and_rt_proc
      old_room_type_rec = get_room_type_rec(org_order[:hotel], org_order[:room_type_str])
      old_room_type = UpdateRooms::RoomType.new(old_room_type_rec)
      new_room_type_rec = get_room_type_rec(new_order[:hotel].id, new_order[:room_type_str])
      new_room_type = UpdateRooms::RoomType.new(new_room_type_rec)

      # new_room_type check_available for new new_params
      # !!stop proccess if check not available.
      raise "Don't have enough rooms for new order." unless new_room_type.check_available( new_order[:date_range], new_order[:change_rooms])

      # old_room_type restore(old_date_range, org_order[:change_rooms]) rooms.
      old_room_type.change_rooms!(org_order[:date_range], org_order[:change_rooms])

      # new_room_type change_rooms(new_order[:date_range], new_order[:change_rooms])
      # change_rooms! == change_rooms and apply_changes
      new_room_type.change_rooms!(new_order[:date_range], new_order[:change_rooms])
    end

    private
    # old hotel and room_type equal new hotel and room_type?
    def same_hotel_and_rt?
      new_hotel_id = get_hotel_id(new_params[:hotel_id]) || get_hotel_id(new_params[:hotel])
      same_hotel = (org_order[:hotel].name == Product::Hotel.find(new_hotel_id).name)
      same_room_type = (org_order[:room_type_str] == new_order[:room_type_str])
      same_hotel && same_room_type
    end

    # get date_range_array
    # @params:
    #   checkin: String or Date
    #   checkout: String or Date
    # @return: [date_inst, date_inst...], Date instance array.
    def get_date_range(checkin, checkout)
      checkin_date = (checkin.is_a?(String) ? Date.parse(checkin) : checkin)
      checkout_date = (checkout.is_a?(String) ? Date.parse(checkout) : checkout)
      date_range_array = (checkin_date..checkout_date).to_a
      date_range_array.pop
      date_range_array
    end

    def get_room_type_rec(hotel_id, room_type_name_eng)
      Product::HotelRoomType.joins(:room_type).where(hotel: hotel_id, room_types: {name_eng: room_type_name_eng}).first
    end

    def get_rooms_attributes_length(rooms_attributes)
      if rooms_attributes.is_a?(ActionController::Parameters)
        rooms_attributes.to_hash.length
      else
        rooms_attributes.length
      end
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
