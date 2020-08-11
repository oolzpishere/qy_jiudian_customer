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
          "period" => "#{order_data.get_data("check_in_out")}#{order_data.get_data("nights")}天",
          "names" => order_data.get_data("all_names_string"),
          "total_people" => order_data.get_data("peoples_count"),
          "rooms" => order_data.get_data("room_type_zh") + order_data.get_data("room_count_zh"),
          "price" => order_data.get_data("price"),
          "breakfast" => "#{order_data.get_data("breakfast_boolean")}"
         }.to_json
      end

      def order_car
        {"conference" => record.conference.name,
          "hotel" => record.hotel.name,
          "checkin" => order_data.get_data("checkin_zh"),
          "checkout" => order_data.get_data("checkout_zh"),
          "days" => order_data.get_data("nights"),
          "names" => order_data.get_data("all_names_string"),
          "total_people" => order_data.get_data("peoples_count"),
          "rooms" => order_data.get_data("room_type_zh") + order_data.get_data("room_count_zh"),
          "price" => order_data.get_data("price"),
          "breakfast" => "#{order_data.get_data("breakfast_boolean")}",
          "car_usage" => "#{order_data.get_data("conference_period_zh")}"
         }.to_json
      end

      def cancel
        {"conference" => record.conference.name,
          "hotel" => record.hotel.name,
          "checkin" => order_data.get_data("checkin_zh"),
          "checkout" => order_data.get_data("checkout_zh"),
          "days" => order_data.get_data("nights"),
          "names" => order_data.get_data("all_names_string"),
          "total_people" => order_data.get_data("peoples_count"),
          "rooms" => order_data.get_data("room_type_zh") + order_data.get_data("room_count_zh"),
          "price" => order_data.get_data("price"),
          "breakfast" => "#{order_data.get_data("breakfast_boolean")}"
         }.to_json
      end
    end
  end
end
