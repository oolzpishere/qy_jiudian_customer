module Admin
  module OrderTranslate
    class Sms < Base

      def checkin_zh
        checkin = order.checkin
        "#{checkin.month}月#{checkin.day}日"
      end

      def checkout_zh
        checkout = order.checkout
        "#{checkout.month}月#{checkout.day}日"
      end

      def conference_period_zh
        start = order.conference.start
        finish = order.conference.finish
        "#{start.month}月#{start.day}日-#{finish.month}月#{finish.day}日"
      end

    end
  end
end
