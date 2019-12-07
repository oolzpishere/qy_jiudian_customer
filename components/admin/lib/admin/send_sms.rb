require_relative "send_sms/params"
require_relative "send_sms/params/ali_params"
require_relative "send_sms/template_codes"
require_relative "send_sms/type"
require_relative "send_sms/combiner"


module Admin
  module SendSms
    class Sender

      def self.platform(type, phone_numbers, template_codes, template_param)
        self.for(type, phone_numbers, template_codes, template_param)
      end

      def self.for(type, phone_numbers, template_codes, template_param)

        case template_codes.keys.first
        when "ali"
          Ali
        when "ten"
          Tencent
        end.new(type, phone_numbers, template_codes, template_param)
      end

    end

    class Ali < Sender
      # @type(string) final type.
      # @phone_numbers(string) final state.
      # @template_codes(Hash) TemplateCodes::ALI["ali"][type]
      # @template_param(String) template_param.to_params
      attr_reader :type, :phone_numbers, :template_code, :template_param
      def initialize(type, phone_numbers, template_codes, template_param)
        @type = type
        @phone_numbers = phone_numbers
        @template_code = get_tmp_code(template_codes, type)
        @template_param = get_params(template_param)
      end

      def send_sms
        Aliyun::Sms.send(phone_numbers, template_code, template_param)
      end

      def get_tmp_code(template_codes, type)
        template_codes["ali"][type]["template_code"]
      end

      def get_params(param)
        param.to_params
      end

    end

    class Tencent < Sender
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
