# require_relative "../order_data"

module Admin
  module SendSms
    class TemplateCodes
      ALI = { "ali" =>
        {
          "order" => {"template_code" => "SMS_173472652"},
          "order_car" => {"template_code" => "SMS_173945715"},
          "cancel" => {"template_code" => "SMS_173950836"}
        }
      }
      # todo not set, maybe not use.
      TEN = { "ten" =>
        {

        }
      }
    end
  end
end
