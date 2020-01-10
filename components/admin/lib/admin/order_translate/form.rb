module Admin
  module OrderTranslate
    class Form < Base

      def breakfast
        order.breakfast.to_i == 1 ? "含早" : "不含早"
      end

      def check_in_out
        checkin = order.checkin
        checkout = order.checkout
        "#{checkin.month}月#{checkin.day}日-#{checkout.month}月#{checkout.day}日"
      end

    end
  end
end
