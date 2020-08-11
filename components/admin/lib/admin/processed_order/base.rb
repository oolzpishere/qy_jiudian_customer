module Admin
  class ProcessedOrder
    class Base
      attr_reader :order

      def initialize(order)
        @order = order
      end

      # def data(request)
      #   if instance_variable_get("@#{request}")
      #     instance_variable_get("@#{request}")
      #   else
      #     order.try(request) && order.send(request)
      #   end
      # end




    end
  end
end
