# require_relative "../order_data"

module Admin
  module RecordSendSms
    class ParamsName

      def self.get_name(record, params_name)
        case params_name
        when /order/
          if record.hotel.car == 0
            params_name = 'order'
          else
            params_name = 'order_car'
          end
        else
          params_name
        end
      end

    end
  end
end
