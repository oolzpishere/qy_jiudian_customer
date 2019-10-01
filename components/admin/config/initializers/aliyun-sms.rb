Aliyun::Sms.configure do |config|
  config.access_key_id = ENV["QY_ALI_ACCESS_KEY_ID"]
  config.access_key_secret = ENV["QY_ALI_ACCESS_KEY_SECRET"]
  config.action = 'SendSms'                       # default value
  config.format = 'JSON'                           # http return format, value is 'JSON' or 'XML'
  config.region_id = 'cn-shenzhen'                # default value
  config.sign_name = '前沿课堂组委会'
  config.signature_method = 'HMAC-SHA1'           # default value
  config.signature_version = '1.0'                # default value
  config.version = '2017-05-25'                   # default value
end
