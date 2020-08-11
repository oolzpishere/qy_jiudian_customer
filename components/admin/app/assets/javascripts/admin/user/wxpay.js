
$(document).on("ready page:load turbolinks:load", function() {

  $('.wx_pay_form').submit( function(event) {
    event.preventDefault(); //this will prevent the default submit

    alert('submit123')
    wx.config({
      appId: "wx37860e03b3e55945"
    });
    // console.log("under testing")
    params = {
      total_fee: $('#total_fee').val()
    }
    wxpay(params);

    $(this).unbind('submit').submit(); // continue the submit unbind preventDefault
  });

  function wxpay(params = {}) {
    $.post('/wx_pay', params,
    function(data) {
      alert('package' + data.package);

      addPaymentId(data.payment_id);

      if (typeof data.package !== 'undefined') {
        invokeWXPay(data)
      } else {
        // TODO: error handling.
      }

    });
  }

  function addPaymentId(id) {
    $('#order_patment_id').val(id)
  }

  function invokeWXPay(data) {
    wx.chooseWXPay({
      timestamp: data.timeStamp,
      nonceStr: data.nonceStr,
      package: data.package,
      signType: data.signType,
      paySign: data.paySign,
      success: function (res) {
        alert(JSON.stringify(res));
      },
      error: function(e) {
        alert(JSON.stringify(e));
      }
    });
  }


});
