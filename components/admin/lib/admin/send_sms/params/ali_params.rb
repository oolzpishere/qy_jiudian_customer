# require_relative "../order_data"

module Admin
  module SendSms
    class AliParams < Params
      attr_reader :order_data
      def initialize( record, type )
        super
        @order_data = Admin::OrderTranslate::Sms.new(order: record)
      end

      def order
        {"conference" => record.conference.name,
          "hotel" => record.hotel.name,
          "period" => "#{order_data.send_command(request: "check_in_out")}#{order_data.send_command(request: "nights")}天",
          "names" => order_data.send_command(request: "all_names_string"),
          "total_people" => order_data.send_command(request: "peoples_count"),
          "rooms" => order_data.send_command(request: "room_type_zh") + order_data.send_command(request: "room_count_zh"),
          "price" => order_data.send_command(request: "price"),
          "breakfast" => "#{order_data.send_command(request: "breakfast_boolean")}"
         }.to_json
      end

      def order_car
        {"conference" => record.conference.name,
          "hotel" => record.hotel.name,
          "checkin" => order_data.send_command(request: "checkin_zh"),
          "checkout" => order_data.send_command(request: "checkout_zh"),
          "days" => order_data.send_command(request: "nights"),
          "names" => order_data.send_command(request: "all_names_string"),
          "total_people" => order_data.send_command(request: "peoples_count"),
          "rooms" => order_data.send_command(request: "room_type_zh") + order_data.send_command(request: "room_count_zh"),
          "price" => order_data.send_command(request: "price"),
          "breakfast" => "#{order_data.send_command(request: "breakfast_boolean")}",
          "car_usage" => "#{order_data.send_command(request: "conference_period_zh")}"
         }.to_json
      end

      def cancel
        {"conference" => record.conference.name,
          "hotel" => record.hotel.name,
          "checkin" => order_data.send_command(request: "checkin_zh"),
          "checkout" => order_data.send_command(request: "checkout_zh"),
          "days" => order_data.send_command(request: "nights"),
          "names" => order_data.send_command(request: "all_names_string"),
          "total_people" => order_data.send_command(request: "peoples_count"),
          "rooms" => order_data.send_command(request: "room_type_zh") + order_data.send_command(request: "room_count_zh"),
          "price" => order_data.send_command(request: "price"),
          "breakfast" => "#{order_data.send_command(request: "breakfast_boolean")}"
         }.to_json
      end
    end
  end
end
