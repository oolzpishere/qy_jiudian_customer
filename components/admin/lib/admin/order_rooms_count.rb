module Admin
  class OrderRoomsCount
    attr_accessor :date_rooms_count_hash
    attr_reader :orders
    # params:
    # orders: orders array
    def initialize(orders)
      @orders = orders
      @date_rooms_count_hash = {}
    end

    def set_date_rooms_count_hash
      orders.each do |order|
        date_range_array_buf = date_range_array(order)
        rooms_num = order.rooms.length
        room_type = order.room_type
        accumulate_date_rooms(date_range_array_buf,room_type, rooms_num )
      end
      date_rooms_count_hash
    end

    # get date_range_array
    def date_range_array(order)
      date_range_array = (order.checkin..order.checkout).to_a
      date_range_array.pop
      date_range_array
    end

    def accumulate_date_rooms(date_range_array, room_type, rooms_num)
      date_range_array.each do |date|
        date_string = date.to_s
        date_rooms_count_hash[room_type] ||= {}
        date_rooms_count_hash[room_type][date_string] ||= 0
        date_rooms_count_hash[room_type][date_string] += rooms_num
      end
    end

  end
end
