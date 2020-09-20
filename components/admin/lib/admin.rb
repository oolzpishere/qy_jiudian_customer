require "admin/engine"
require "sass-rails"
require 'devise'
require 'jquery-ui-rails'
require 'bootstrap'
require "momentjs-rails"
require "bootstrap-datepicker-rails"
require 'omniauth'
require "omniauth-wechat-oauth2"
require "selectize-rails"
require 'qcloud/sms'
require 'aliyun/sms'
# require 'axlsx'
# require 'rubyzip'
require 'axlsx_rails'
# require 'client_side_validations'
require 'jquery-validation-rails'
require 'cocoon'
require 'active_model_otp'
require 'wx_pay'

require 'admin/order_rooms_count'

require 'admin/order_translate'

require 'admin/update_rooms/room_type'
require 'admin/update_rooms/room_types'
require 'admin/update_rooms/date_room'
require 'admin/update_rooms'

# require 'send_sms'
# require_relative "admin/send_sms/params"
# require_relative "admin/send_sms/params/ali_params"
# require_relative "admin/send_sms/template_codes"
# require_relative "admin/send_sms/type"
# require_relative "admin/send_sms/combiner"
require_relative "admin/record_send_sms"


module Admin
  # Your code goes here...
end
