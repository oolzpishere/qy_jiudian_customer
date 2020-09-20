module Admin
  module RecordSendSms
    class AliSendSms
      attr_reader :record, :params_name
      def initialize(record, params_name)
        @record = record
        @params_name = params_name
      end

      def perform_send_sms
        # set params
        phone_numbers = get_phone_numbers
        template_code = get_template_codes
        params_name = get_params_name
        template_params = get_params

        Aliyun::Sms.send(phone_numbers, template_code, template_params)
      end

      def get_phone_numbers
        # phones is string separate by comma: '1234567890,12388888888'
        record.phone
      end

      def get_params_name
        ::Admin::RecordSendSms::ParamsName.get_name(record, params_name)
      end

      def get_params
        Admin::RecordSendSms::Params::AliParams.new(record).to_params(params_name)
      end

      def get_template_codes
        codes[params_name]["template_code"]
      end

      def codes
        @codes ||=
          { "order" => {"template_code" => "SMS_173472652"},
            "order_car" => {"template_code" => "SMS_173945715"},
            "cancel" => {"template_code" => "SMS_173950836"}
          }
      end

    end
  end
end
