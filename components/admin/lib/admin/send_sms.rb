require_relative "send_sms/ali_params"
require_relative "send_sms/ali_sender/base"

module Admin
  module SendSms
    class Base
      attr_reader :record, :type

      def initialize(record, type)
        @record = record
        @type = type
      end

      def send_sms
      end
    end

    class Ali < Base
      attr_reader :phone_numbers
      def initialize(record, type)
        super
        @phone_numbers = record.phone
      end

      def send_sms
        self.for.send_sms
         # to_params(record)
      end

      def for
        case type
        when /order/
          if record.hotel.car == 0
            # Don't have car usage
            template_code = "SMS_173472652"
            template_param = AliParams.new(record, 'order').to_params
            AliSender::Order
            # send_order_sms
          else
            template_code = "SMS_173945715"
            template_param = AliParams.new(record, 'order_car').to_params
            AliSender::OrderCar
            # send_order_car_sms
          end
          # order_sms
        when /cancel/
          template_code = "SMS_173950836"
          template_param = AliParams.new(record, type).to_params
          AliSender::Cancel
        end.new( phone_numbers: phone_numbers, template_code: template_code, template_param: template_param )
      end

      # def order_sms
      # end
      #
      # def send_order_sms
      #   template_code = "SMS_173472652"
      # end
      #
      # def send_order_car_sms
      #   template_code = "SMS_173477675"
      # end

    end

    class Tencent < Base
      def send_sms(records, template_code)
        records.each do |record|
          template_param = to_params(record)
          phone_number = record.phone
          Qcloud::Sms.single_sender(phone_number, template_code, params)
        end
      end

      def to_params(record)
        order_data = ::Admin::OrderData.new(order: record)
        [
          record.conference.name,
          record.hotel.name,
          "#{order_data.check_in_out}#{order_data.nights}天",
          order_data.all_names_string,
          order_data.peoples_count,
          order_data.room_type_zh + order_data.room_count_zh,
          order_data.price_zh,
          "#{order_data.breakfast}"
        ]
      end

    end

  end
end
