module Pay
  class PaymentController < Pay::ApplicationController
    skip_before_action :verify_authenticity_token, only: [:wx_notify]

    def wx_notify
      # eg. result: {"appid"=>"wx37860e03b3e55945", "bank_type"=>"OTHERS", "cash_fee"=>"1", "fee_type"=>"CNY", "is_subscribe"=>"Y", "mch_id"=>"1400074302", "nonce_str"=>"758db373ad8648c980491bbc850e36fa", "openid"=>"o3jBmt91YRMtZDvZZk-96C20jhSg", "out_trade_no"=>"trade-1592406779", "result_code"=>"SUCCESS", "return_code"=>"SUCCESS", "sign"=>"666B4FDBA5B7D22B548258CC2A69F556", "time_end"=>"20200617231304", "total_fee"=>"1", "trade_type"=>"JSAPI", "transaction_id"=>"4200000538202006176109982880"}
      result = Hash.from_xml(request.body.read)["xml"]

      if WxPay::Sign.verify?(result)
        update_wx_payment(result)
        render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
      else
        render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
      end
    end

    private
    # TODO: result.permit()
    def result_slice(result)
      result.symbolize_keys.slice( :payment, :appid, :mch_id, :device_info, :openid, :is_subscribe, :trade_type, :bank_type, :total_fee, :settlement_total_fee, :fee_type, :cash_fee, :cash_fee_type, :transaction_id, :out_trade_no, :attach,:time_end )
    end

    def update_wx_payment(result)
      if result["result_code"].upcase == "SUCCESS"
        out_trade_no = result["out_trade_no"]
        wx_payment = Pay::WxPayment.find_by(out_trade_no: out_trade_no)
        wx_payment.update( result_slice(result) )
      else
        # TODO: when result_code == "FAIL"
      end
    end

  end
end
