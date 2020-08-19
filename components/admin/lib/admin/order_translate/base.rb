
module Admin
  module OrderTranslate
    class Base

      attr_reader :order, :processed_order, :processed_data, :processed_payment

      def initialize(order)
        @order = order
        @processed_order = Admin::ProcessedOrder.new(order)
        @processed_payment = processed_order.processed_payment
      end

      # @params: req_string or { request(string), type: type_name(string) }
      def get_data(request, type: nil)

        # raw data
        @processed_data = processed_order.get_data(request, type: type)

        if self.try(request)
          self.send(request)
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
        processed_order.hotel_room_type.room_type.name
      end

      def room_count_zh
        "#{order.rooms.count}间"
      end

      def conference_check_in_out
        checkin = order.conference.sale_from
        checkout = order.conference.sale_to
        "#{checkin.month}月#{checkin.day}日-#{checkout.month}月#{checkout.day}日"
      end

      def trade_status
        return nil unless processed_payment
        @trade_status ||= processed_payment.trade_status ? "已付款" : "未付款"
      end

      def payment_method
        return nil unless processed_payment
        @payment_method ||= if processed_payment.payment_method == :wx
          "微信支付"
        # elsif :ali
        end
      end

      # 应付金额 wechat: total_fee
      def payment_total_price
        return nil unless processed_payment
        @payment_total_price ||= processed_payment.total_fee * 0.01
      end

      # 交易号-trade_no: {wechat: transaction_id}
      def trade_no
        return nil unless processed_payment
        @trade_no ||= processed_payment.transaction_id
      end

    end
  end
end
