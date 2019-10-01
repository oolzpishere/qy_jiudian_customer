# require_relative "../order_data"

module Admin
  module SendSms
    class AliParams
      attr_reader :record, :type, :order_data
      def initialize( record, type )
        @record = record
        @type = type
        @order_data = ::Admin::OrderData.new(order: record)
      end

      def to_params
        self.send(type)
      end

      def order
        {"conference" => record.conference.name,
          "hotel" => record.hotel.name,
          "period" => "#{order_data.check_in_out}#{order_data.nights}天",
          "names" => order_data.all_names_string,
          "total_people" => order_data.peoples_count,
          "rooms" => order_data.room_type_zh + order_data.room_count_zh,
          "price" => order_data.send_command("price"),
          "breakfast" => "#{order_data.breakfast_boolean}"
         }.to_json
      end

      def order_car
        {"conference" => record.conference.name,
          "hotel" => record.hotel.name,
          "checkin" => order_data.send_command("checkin_zh"),
          "checkout" => order_data.send_command("checkout_zh"),
          "days" => order_data.nights,
          "names" => order_data.all_names_string,
          "total_people" => order_data.peoples_count,
          "rooms" => order_data.room_type_zh + order_data.room_count_zh,
          "price" => order_data.send_command("price"),
          "breakfast" => "#{order_data.breakfast_boolean}",
          "car_usage" => "#{order_data.conference_period_zh}"
         }.to_json
      end

      def cancel
        {"conference" => record.conference.name,
          "hotel" => record.hotel.name,
          "checkin" => order_data.send_command("checkin_zh"),
          "checkout" => order_data.send_command("checkout_zh"),
          "days" => order_data.nights,
          "names" => order_data.all_names_string,
          "total_people" => order_data.peoples_count,
          "rooms" => order_data.room_type_zh + order_data.room_count_zh,
          "price" => order_data.send_command("price"),
          "breakfast" => "#{order_data.breakfast_boolean}"
         }.to_json
      end
    end
  end
end
