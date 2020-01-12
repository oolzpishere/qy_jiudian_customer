module Admin
  class ProcessedOrder
    class Bed < Nothing
      attr_reader  :room_type_eng_name, :hotel, :room_type, :hotel_room_type

      def initialize(order)
        @order = order

        @room_type_eng_name = order.room_type
        @hotel = order.hotel
        @room_type = Product::RoomType.find_by(name_eng: order.room_type)
        @hotel_room_type = Product::HotelRoomType.find_by(hotel_id: hotel.id, room_type_id: room_type.id)

        set_room_type
        set_price
        set_settlement_price
      end

      def data(request)
        if self.try(request)
          self.send(request)
        else
          instance_variable_get("@#{request}")
        end
      end

      def set_room_type
        instance_variable_set("@#{room_type_eng_name}", 1)
      end

      def set_price
        instance_variable_set("@#{room_type_eng_name}_price", order.price.to_f)
      end

      def set_settlement_price
        instance_variable_set("@#{room_type_eng_name}_settlement_price", hotel_room_type.settlement_price.to_f)
      end


    end
  end
end
