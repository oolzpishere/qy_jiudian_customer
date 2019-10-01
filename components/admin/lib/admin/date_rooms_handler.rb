module DateRoomsHandler
  class Base
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

    # have check after assign attributes to @order, because order_rooms_change_to need assigned @order.
    def check_all_date_rooms
      return false unless hotel_room_type

      date_range_array_now.each do |date|

        # find by date
        return false unless date_room = get_date_room(available_date_rooms, date)
        # check rooms
        return false unless ( date_room.rooms - order_rooms_change(date_room) ) >= 0
      end
      return true
    end

    def add_date_rooms(date_range_array, add_rooms)
      date_range_array.each do |date|
        # find by date
        date_room = get_date_room(available_date_rooms, date)
        # ignore if date_room not exist
        next unless date_room
        date_room.rooms += add_rooms
        date_room.save
      end
    end

    # need before_date_range_array, hotel_room_type
    # change rooms to 0
    def delete_date_rooms(date_range_array, delete_rooms)
      date_range_array.each do |date|
        # find by date
        date_room = get_date_room(available_date_rooms, date)
        # ignore if date_room not exist
        next unless date_room
        date_room.rooms -= delete_rooms
        date_room.save
      end
    end

    # get current date_range_array, track the newest checkin and checkout.
    def date_range_array_now
      date_range_array = (@order.checkin..@order.checkout).to_a
      date_range_array.pop
      date_range_array
    end

    def get_date_room(available_date_rooms, date)
      available_date_rooms.find {|dr| dr.date == date}
    end

    def available_date_rooms
      hotel_room_type.date_rooms
    end

    def get_hotel_room_type(order)
      # hotel and room_types have to be compound keys.
      Product::HotelRoomType.joins(:room_type).where(hotel: order.hotel, room_types: {name_eng: order.room_type}).first
    end

    def order_rooms_change(date_room)
      order_rooms_change_to - order_rooms_before
    end

    # def order_rooms_before
    #   # count will check database, so it'll be before date.
    #   # length wiil not check database.
    #   order.rooms.count
    # end

    def order_rooms_change_to
      order.rooms.length
      # count = 0
      # # or use select {}
      # order_params["rooms_attributes"].each do |_, room_attribute|
      #    if room_attribute["_destroy"] && room_attribute["_destroy"].match(/0/)
      #      count += 1
      #      # if don't have _destroy
      #    elsif !room_attribute["_destroy"] && !room_attribute["names"].empty?
      #      count += 1
      #    end
      # end
      # count
    end

  end

  class Create < Base
    def handle_date_rooms
      # 消掉现在的库存
      delete_date_rooms(date_range_array_now, order_rooms_change_to)
    end

    def order_rooms_before
      0
    end

  end

  class Update < Base

    def handle_date_rooms
      # 加回最初的库存
      add_date_rooms(before_date_range_array, order_rooms_before)
      # 消掉现在的库存
      delete_date_rooms(date_range_array_now, order_rooms_change_to)
    end

  end

  class Destroy < Base
    def handle_date_rooms
      # 加回最初的库存
      add_date_rooms(before_date_range_array, order_rooms_before)
    end
  end

end
