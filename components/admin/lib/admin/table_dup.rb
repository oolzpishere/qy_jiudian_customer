module Admin
  class TableDup
    attr_reader :order, :date_range_array, :hotel_room_type, :order_rooms_before, :before_date_range_array, :table
    def initialize( order: )
      @order = order
      @hotel_room_type = get_hotel_room_type(order)

      # before data
      @order_rooms_before = @order.rooms.length
      before_checkin = @order.checkin
      before_checkout = @order.checkout
      @before_date_range_array = (before_checkin..before_checkout).to_a
      @before_date_range_array.pop

      @table ||= []
    end



    def insert_data(row, col, data)

    end

    def before_data
      before_date_range_array.each do |date|
        row = date
        col = hotel_room_type
        data = order_rooms_before

        insert_data(row, col, data)
      end
    end

    private

    def find_row(row)

    end

    def find_col(col)

    end

  end
end
