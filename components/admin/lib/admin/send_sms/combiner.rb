# require_relative "../order_data"

module Admin
  module SendSms
    class Combiner

      def self.send_sms(record, type, template_codes = nil)
        type = ::Admin::SendSms::Type.get_type(record, type)
        phone_numbers = record.phone
        template_codes = ::Admin::SendSms::TemplateCodes::ALI
        template_param = ::Admin::SendSms::AliParams.new( record, type )
        ::Admin::SendSms::Sender.platform(type, phone_numbers, template_codes, template_param).send_sms
      end

    end
  end
end
