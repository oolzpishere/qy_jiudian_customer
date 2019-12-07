# require_relative "../order_data"
# require_relative "params/ali_params"


module Admin
  module SendSms
    class Params
      attr_reader :record, :type
      def initialize( record, type )
        @record = record
        @type = type
      end

      def to_params
        self.send(type)
      end

    end
  end
end
