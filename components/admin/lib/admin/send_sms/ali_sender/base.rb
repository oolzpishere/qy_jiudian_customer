module Admin
  module SendSms
    module AliSender
      class Base
        attr_reader :phone_numbers, :template_code, :template_param
        def initialize(phone_numbers:, template_code:, template_param:)
          @phone_numbers = phone_numbers
          @template_code = template_code
          @template_param = template_param
        end

        def send_sms
          Aliyun::Sms.send(phone_numbers, template_code, template_param)
        end
      end

      class Order < Base

      end

      class OrderCar < Base

      end

      class Cancel < Base

      end

    end
  end
end
