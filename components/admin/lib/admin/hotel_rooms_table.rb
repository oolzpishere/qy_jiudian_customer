module Admin
  class HotelRoomsTable
    attr_reader  :room_type_eng_name, :hotel, :room_types_ordered, :room_types, :room_type, :hotel_room_type

    def initialize(order: nil)
      @order = order

      @room_type_eng_name = order.room_type
      @hotel = order.hotel
      @room_types = hotel.room_types

      # @room_type = Product::RoomType.find_by(name_eng: order.room_type)
      # @hotel_room_type = Product::HotelRoomType.find_by(hotel_id: hotel.id, room_type_id: room_type.id)
    end

    def table
      @table ||= build_table
    end

    def search_table(date, room_type)
      row, col = get_row_col(date, room_type)
      table[row][col] if row && col
    end

    # date_rooms table:
    # [
    # row   [col,col],
    # row  [col,col]
    # ]
    def build_table
      table_buf = Array.new(date_rows.length) {Array.new(room_types_column.length)}
      all_date_rooms.each do |dr|
        row, col = get_row_col(dr.date, dr.hotel_room_type.room_type)

        table_buf[row][col] = dr.rooms
      end
      table_buf
    end



    def room_types_column
      # room_type object array
      @room_types_column ||= room_types.order(:id)
    end

    def date_rows
      @date_rows ||= all_date_rooms.uniq{|item| item.date}
    end

    def all_date_rooms
      @all_date_rooms ||= Product::DateRoom.where(hotel_room_type_id: hotel_room_type_id_array)
    end

    def hotel_room_type_id_array
      hotel.hotel_room_types.map{|hrt| hrt.id}
    end


    private

    def get_row_col(date, room_type)
      row = date_rows.index(date)
      col = room_types_column.index(room_type)
      return row, col
    end
    
  end
end
