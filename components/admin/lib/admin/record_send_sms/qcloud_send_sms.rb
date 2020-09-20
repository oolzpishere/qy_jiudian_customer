module Admin
  module RecordSendSms
    class QcloudSendSms
      attr_reader :record, :params_name
      def initialize(record, params_name)
        @record = record
        @params_name = params_name
      end

      def perform_send_sms
        # set params
        phone_numbers = get_phone_numbers
        phone_number = phone_numbers
        template_code = get_template_codes
        params_name = get_params_name
        template_params = get_params(params_name)

        # phone_number: 接收短信的手机号，必须为字符型，例如 '1234567890'；
        # template_code: 短信模版代码，必须为数字型，申请开通短信服务后，由腾讯云提供，例如 '12345678'；
        # params: 请求字符串，向短信模版提供参数，必须为数组型，例如 '["params1", "params2"]'。
        Qcloud::Sms.single_sender(phone_number, template_code, template_params)
      end
      def get_phone_numbers
        # TODO:
        # phone_number: 接收短信的手机号，必须为字符型，例如 '1234567890'；
        record.phone
      end

      def get_params_name
        ::Admin::RecordSendSms::ParamsName.get_name(record, params_name)
      end

      def get_params(params_name)
        # TODO:
        # Admin::RecordSendSms::Params::TencentParams.new(record).to_params(params_name)
      end

      def get_template_codes
        codes[params_name]["template_code"]
      end

      def codes
        # TODO:
        # @codes ||=
        #   { "order" => {"template_code" => "xxx"},
        #   }
      end

    end
  end
end
