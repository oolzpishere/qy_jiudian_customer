# require_relative "../order_data"

module Admin
  module SendSms
    class Type

      def self.get_type(record, type)
        case type
        when /order/
          if record.hotel.car == 0
            type = 'order'
          else
            type = 'order_car'
          end
        else
          type
        end
      end

    end
  end
end
