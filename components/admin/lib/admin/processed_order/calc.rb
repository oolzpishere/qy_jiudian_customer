module Admin
  class ProcessedOrder
    class Calc
      attr_reader :order, :bed_obj

      def initialize(order, bed_obj: nil)
        @order = order
        @bed_obj = bed_obj
      end

      def data(request)
        if self.try(request)
          self.send(request)
        end
      end

      def actual_settlement
        price_str = bed_obj.room_type_eng_name + "_settlement_price"
        bed_obj.data(price_str) * nights
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
        order.hotel.tax_rate
      end
      def tax_point
        order.hotel.tax_point
      end

      def actual_profit
        profit - (profit * tax_rate)
      end

    end
  end
end
