module Admin
  class User::PayController < ActionController::Base
    layout "admin/user/sessions.html.erb"

    before_action :authenticate_user!, except: [:wx_notify]
    skip_before_action :verify_authenticity_token, only: [:wx_notify]

    def wx_pay
      current_identify = Account::Identify.find_by(user: current_user, provider: 'wechat')
      # byebug
      form_params = {
        total_fee: params['total_fee']
      }
      pay_params = {
        body: 'Test Wechat Pay',
        out_trade_no: "trade-#{Time.now.to_i}",
        # total_fee: 1,
        spbill_create_ip: request.remote_ip,
        notify_url: 'http://qyjiudian-customer.sflx.com.cn/wx_notify',
        trade_type: 'JSAPI',
        openid: current_identify.uid
      }.merge(form_params)

      # TODO: create payment and WxPayment
      wx_payment_params = pay_params.slice(:out_trade_no, :total_fee)
      payment = Pay::Payment.new
      if payment.save
        wx_payment_params.merge!(payment_id: payment.id)
        wx_payment = Pay::WxPayment.new(wx_payment_params)
      else
        raise "Payment.new save fail."
      end

      prepay_result = WxPay::Service.invoke_unifiedorder(pay_params)
      if prepay_result.success? && payment && payment.save
        js_pay_params = {
          prepayid: prepay_result['prepay_id'],
          noncestr: prepay_result['nonce_str']
        }
        pay_params = WxPay::Service.generate_js_pay_req js_pay_params
        # add payment_id to return.
        pay_params.merge!({payment_id: payment.id})

        logger.info pay_params
        render json: pay_params
      else
        logger.error prepay_result['return_msg']
        logger.error "wx_payment.save #{wx_payment.save}"
        render json: prepay_result
      end
    end

    def wx_notify
      result = Hash.from_xml(request.body.read)['xml']
      logger.info result.inspect
      if WxPay::Sign.verify?(result)
        render xml: { return_code: 'SUCCESS', return_msg: 'OK' }.to_xml(root: 'xml', dasherize: false)
      else
        render xml: { return_code: 'FAIL', return_msg: 'Signature Error' }.to_xml(root: 'xml', dasherize: false)
      end
    end
  end
end
