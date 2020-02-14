require "admin/engine"
require "sass-rails"
require 'devise'
require 'jquery-ui-rails'
require 'bootstrap'
require "momentjs-rails"
require "datetime_picker_rails"
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

require 'admin/order_data'
require 'admin/date_rooms_handler'
require 'admin/order_rooms_count'

require 'admin/order_translate'

require 'admin/table'

# require 'send_sms'
require_relative "admin/send_sms/params"
require_relative "admin/send_sms/params/ali_params"
require_relative "admin/send_sms/template_codes"
require_relative "admin/send_sms/type"
require_relative "admin/send_sms/combiner"

module Admin
  # Your code goes here...
end
