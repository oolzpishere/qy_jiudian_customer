
module Admin
  module OrderTranslate
    class Base

      attr_reader :order, :processed_order

      def initialize(order)
        @order = order
        @processed_order = Admin::ProcessedOrder.new(order)
      end

      def send_command(request: nil)
        if self.try(request)
          self.send(request)
        else
          # raw data
          processed_order.get_data(request)
        end
      end

    end
  end
end
