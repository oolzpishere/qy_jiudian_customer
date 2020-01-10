module Admin
  class ProcessedOrder
    class Hotel
      attr_reader :order, :hotel

      def initialize(order)
        @order = order
        @hotel = order.hotel
      end

      def data(request)
        if instance_variable_get("@#{request}")
          instance_variable_get("@#{request}")
        else
          hotel.try(request) && hotel.send(request)
        end
      end


    end
  end
end
