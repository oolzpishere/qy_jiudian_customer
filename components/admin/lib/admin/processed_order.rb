require_relative 'processed_payment'

module Admin
  class ProcessedOrder

    attr_reader :order, :nothing_obj, :room_type_eng_name, :hotel, :room_type, :hotel_room_type, :processed_payment
    def initialize(order)
      @order = order

      @room_type_eng_name = order.room_type
      @hotel = order.hotel
      @room_type = Product::RoomType.find_by(name_eng: order.room_type)
      @hotel_room_type = Product::HotelRoomType.find_by(hotel_id: hotel.id, room_type_id: room_type.id)

      set_room_type_details

    end

    def get_data(request, type: nil)
      if type
        # get_type_data(request, type)
      else
        base_getter(request)
      end
    end

    def base_getter(request)
      if self.try(request)
        self.send(request)
      elsif order.try(request)
        order.send(request)
      else
        nil
      end
    end

    # def get_type_data(request, type)
    #   type_obj = get_type_obj(type)
    #   if type_obj
    #     type_obj.send(request)
    #   else
    #     return nil
    #   end
    # end
    #
    # def get_type_obj(type)
    #   case type
    #   when /payment/
    #     if order.payment
    #       @processed_payment = Admin::ProcessedPayment.new(order.payment)
    #       return @processed_payment
    #     end
    #   else
    #     return nil
    #   end
    # end

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
      @nights ||= (order.checkout-order.checkin).to_i
    end

    def total_price
      # 单价 * 天数
      @total_price ||= order.price * nights
    end

    def profit
      @profit ||= total_price - actual_settlement
    end

    def tax_rate
      @tax_rate ||= hotel.tax_rate
    end

    def tax_point
      @tax_point ||= hotel.tax_point
    end

    def actual_profit
      @actual_profit ||= profit - (profit * tax_rate)
    end

  end
end
