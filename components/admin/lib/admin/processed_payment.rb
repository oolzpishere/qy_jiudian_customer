
module Admin
  class ProcessedPayment

    # public data: {支付渠道: payment_method,  }
    attr_reader :payment, :payment_method, :payment_detail_obj

    def initialize(payment)
      @payment = payment
      set_payment_detail
    end

    def get_data(request)
      if self.try(request)
        self.send(request)
      elsif payment_detail_obj.try(request)
        payment_detail_obj.send(request)
      else
        nil
      end
    end

    def set_payment_detail
      # if payment.wx?
      if payment.wx_payment
        @payment_method = :wx
        # @payment_detail_obj = payment.wx_payment
        @payment_detail_obj = payment.wx_payment
      # elsif payment.ali?
        # @payment_detail_obj = payment.ali_payment
        # @payment_method = ali
      end
    end

    ########################################
    # data
    ########################################
    # 应付金额 wechat: total_fee
    def payment_total_price
      @payment_total_price ||= payment_detail_obj.total_fee * 0.01
    end

    # 交易号-trade_no: {wechat: transaction_id}
    def trade_no
      payment_detail_obj.transaction_id
    end

    # 交易状态
    def trade_status
      trade_no.empty? ? false : true
    end

  end
end
