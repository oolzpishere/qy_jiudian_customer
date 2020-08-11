require_relative 'processed_order/base'
require_relative 'processed_order/hotel'
# require_relative 'processed_order/bed'
# require_relative 'processed_order/calc'


module Admin
  class ProcessedOrder

    attr_reader :order, :bed_obj, :nothing_obj, :hotel_obj, :calc_obj, :room_type_eng_name, :hotel, :room_type, :hotel_room_type

    def initialize(order: nil)
      @order = order

      set_all_data

      @room_type_eng_name = order.room_type
      @hotel = order.hotel
      @room_type = Product::RoomType.find_by(name_eng: order.room_type)
      @hotel_room_type = Product::HotelRoomType.find_by(hotel_id: hotel.id, room_type_id: room_type.id)

      set_room_type_details

    end

    def set_all_data
      # @bed_obj = Bed.new(order)
      # @nothing_obj = Nothing.new(order)
      # @base_obj = Base.new(order)
      # @hotel_obj = Hotel.new(order)
      # @calc_obj = Calc.new(order, bed_obj: bed_obj)
    end

    def get_data(request, type: nil)
      if type
        factory(order, request, type: type).data(request)
      else
        base_action(request)
      end
    end

    def base_action(request)
      if self.try(request)
        self.send(request)
      elsif order.try(request)
        order.send(request)
      else
        nil
      end
    end

    def factory(order, request, type: nil)
      # could give type, otherwise use request to factory.
      case type
      # when /calc/
      #   return calc_obj
      when /hotel/
        return hotel_obj
      # when /bed/
      #   return bed_obj
      end

      # case request.to_s
      # when /bed/
      #   bed_obj
      # else
      #   nothing_obj
      # end
    end

    def set_room_type_details
      # TODO: delete bed file.
      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        def #{room_type_eng_name}
          1
        end

        def #{room_type_eng_name}_price
          order.price.to_f
        end

        def #{room_type_eng_name}_settlement_price
          hotel_room_type.settlement_price.to_f
        end
      METHODS
    end

    def actual_settlement
      price_str = room_type_eng_name + "_settlement_price"
      self.send(price_str) * nights
    end

    def nights
      (order.checkout-order.checkin).to_i
    end

    def total_price
      # 单价 * 天数
      order.price * nights
    end

    def profit
      total_price - actual_settlement
    end

    def tax_rate
      hotel.tax_rate
    end

    def tax_point
      hotel.tax_point
    end

    def actual_profit
      profit - (profit * tax_rate)
    end

  end
end
