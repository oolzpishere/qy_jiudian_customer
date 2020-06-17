module Pay
  class PaymentController < Pay::ApplicationController
    skip_before_action :verify_authenticity_token, only: [:wx_notify]

    def wx_notify
      result = Hash.from_xml(request.body.read)["xml"]
      logger.info "!!! result: #{result}"
      logger.info "!!! WxPay::Sign.verify?(result): #{WxPay::Sign.verify?(result)}"

      if WxPay::Sign.verify?(result)

        if result["result_code"].upcase == "SUCCESS"
          out_trade_no = result["out_trade_no"]
          wx_payment = Pay::WxPayment.find_by(out_trade_no: out_trade_no)
          wx_payment.update(result)
        else
          # TODO: when result_code == "FAIL"
        end



        render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
      else
        render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
      end
    end

    private
    # TODO: result.permit()

  end
end
