
module Admin
  module OrderTranslate
    class Base

      attr_reader :order, :processed_order, :processed_data

      def initialize(order: nil)
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

        # raw data
        @processed_data = processed_order.get_data(request: req_str, type: type)

        if self.try(req_str)
          self.send(req_str)
        else
          processed_data
        end
      end

      def check_in_out
        checkin = order.checkin
        checkout = order.checkout
        "#{checkin.month}月#{checkin.day}日-#{checkout.month}月#{checkout.day}日"
      end

      def all_names
        names = []
        order.rooms.each do |room|
          names += room.names.split(/,|、|，/)
        end
        names
      end

      def all_names_string
        all_names.join('、')
      end

      def peoples_count
        "#{all_names.count}人"
      end

      def breakfast_boolean
        order.breakfast.to_i == 1 ? "含" : "不含"
      end

      def room_type_zh
        processed_order.bed_obj.hotel_room_type.room_type.name
      end

      def room_count_zh
        "#{order.rooms.count}间"
      end

      def conference_check_in_out
        checkin = order.conference.sale_from
        checkout = order.conference.sale_to
        "#{checkin.month}月#{checkin.day}日-#{checkout.month}月#{checkout.day}日"
      end

    end
  end
end
