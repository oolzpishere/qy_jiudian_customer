
module Admin
  module OrderTranslate
    class Base

      attr_reader :order, :processed_order

      def initialize(order: order)
        @order = order
        @processed_order = Admin::ProcessedOrder.new(order: order)
      end

      def send_command(request: nil)
        if request.is_a?(Hash)
          req_str = request[:request]
          type = request[:type]
        else
          req_str = request
        end

        if self.try(req_str)
          self.send(req_str)
        else
          # raw data
          processed_order.get_data(request: req_str, type: type)
        end
      end

    end
  end
end
