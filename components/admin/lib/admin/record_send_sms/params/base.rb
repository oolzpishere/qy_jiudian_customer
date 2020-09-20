
module Admin
  module RecordSendSms
    class Params
      class Base

        attr_reader :record
        def initialize( record )
          @record = record
        end

        def to_params(params_name)
          self.send(params_name)
        end

      end
    end
  end
end
