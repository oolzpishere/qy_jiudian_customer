require_relative "record_send_sms/ali_send_sms"
require_relative "record_send_sms/qcloud_send_sms"

require_relative "record_send_sms/params/base"
require_relative "record_send_sms/params/ali_params"
require_relative "record_send_sms/params_name"

module Admin
  module RecordSendSms
    # decompose record and send sms
    # @param
    #   record: Object, order record.
    #   params_name: String, location at params.
    #   type: String, ali or ten, default is global setting for Sms platform using now, don't need to specify if not necessary.
    def self.send_sms(record, params_name, type: 'ali')
      self.for(type, record, params_name).perform_send_sms
    end

    def self.for(type, record, params_name)
      if type == "ali"
        ::Admin::RecordSendSms::AliSendSms
      elsif type == "ten"
        ::Admin::RecordSendSms::QcloudSendSms
      end.new(record, params_name)
    end

  end
end
