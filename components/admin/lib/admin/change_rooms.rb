module Admin
  class ChangeRooms
    attr_reader :order, :date_range_array, :hotel_room_type, :order_rooms_before, :order_room_type_before, :before_date_range_array, :table
    def initialize( order: )
      @order = order

      # before data
      @order_rooms_before = @order.rooms.length
      @order_room_type_before = @order.room_type
      before_checkin = @order.checkin
      before_checkout = @order.checkout
      @before_date_range_array = (before_checkin..before_checkout).to_a
      @before_date_range_array.pop

      # init change table
      @table ||= Admin::Table.new()
    end

    def create_to_table
      add_now_rooms_to_table
    end

    def update_to_table
      add_before_rooms_to_table
      add_now_rooms_to_table
    end

    def delete_to_table
      delete_now_rooms_to_table
    end

    def insert_to_db
      records = order_date_room_records

      table.row_primary_keys.each do |row_pk|
        table.col_primary_keys.each do |col_pk|
          data = table.get_data(row_pk, col_pk)
          if data
            date_room_record = get_date_room(records, row_pk)
            date_room_record.rooms += data
            date_room_record.save
          end
        end
      end
    end

    # have to check after assign attributes to @order, because order_rooms_change_to need assigned @order.
    def check_all_date_rooms
      order_date_room_records.each do |dr|
        row = dr.date
        col = order.room_type
        rooms = dr.rooms

        # >=0 则余房足够
        if rooms + table.get_data(row, col) >= 0
          return true
        else
          return false
        end
      end
    end

    def add_before_rooms_to_table
      col = order.room_type
      date_room_num = order_rooms_before
      date_room_insert_to_table(before_date_range_array, col, date_room_num)
    end

    def add_now_rooms_to_table
      col = order.room_type
      date_room_num = -@order.rooms.length
      date_room_insert_to_table(date_range_array_now, col, date_room_num)
    end

    def delete_now_rooms_to_table
      col = order_room_type_before
      date_room_num = order_rooms_before
      date_room_insert_to_table(date_range_array_now, col, date_room_num)
    end

    def date_room_insert_to_table(date_range_array, col, date_room_num)
      date_range_array.each do |date|
        raise "It's not a string room_type" unless col.is_a?(String)

        table.insert_calc(date, col, date_room_num)
      end
      table
    end

    private
    # get current date_range_array, track the newest checkin and checkout.
    def date_range_array_now
      date_range_array = (@order.checkin..@order.checkout).to_a
      date_range_array.pop
      date_range_array
    end

    def get_hotel_room_type(order)
      # hotel and room_types have to be compound keys.
      Product::HotelRoomType.joins(:room_type).where(hotel: order.hotel, room_types: {name_eng: order.room_type}).first
    end

    def get_date_room(order_date_room_records, date)
      order_date_room_records.find {|dr| dr.date == date}
    end

    def order_date_room_records
      get_hotel_room_type(order).date_rooms
    end

  end
end
