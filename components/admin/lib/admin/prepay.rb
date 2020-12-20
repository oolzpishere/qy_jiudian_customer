module Admin
  class Prepay
    # @param
    #   pay_params: 
    # @return
    #   invoke_unifiedorder result: bool.
    #   prepay_result: hash.
    def invoke_unifiedorder(pay_params)
      prepay_result = WxPay::Service.invoke_unifiedorder(pay_params)
      if prepay_result.success?
        js_pay_params = {
          prepayid: prepay_result['prepay_id'],
          noncestr: prepay_result['nonce_str']
        }
        pay_params = WxPay::Service.generate_js_pay_req js_pay_params
        # add payment_id to return.
        # pay_params.merge!({payment_id: payment.id})

        logger.info pay_params
        return true, pay_params
      else
        logger.error prepay_result['return_msg']
        return false, prepay_result
      end

    end

  end
end
