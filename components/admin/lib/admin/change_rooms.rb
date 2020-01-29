module Admin
  class ChangeRooms
    attr_reader :order, :date_range_array, :hotel_room_type, :order_rooms_before, :before_date_range_array
    def initialize( order: )
      @order = order
      @hotel_room_type = get_hotel_room_type(order)

      # before data
      @order_rooms_before = @order.rooms.length
      before_checkin = @order.checkin
      before_checkout = @order.checkout
      @before_date_range_array = (before_checkin..before_checkout).to_a
      @before_date_range_array.pop
    end

    def before_data
      before_date_range_array
    end

  end
end
