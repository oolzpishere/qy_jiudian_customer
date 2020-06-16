
$(document).on("ready page:load turbolinks:load", function() {

  $('.wx_pay_form').submit( function(event) {
    event.preventDefault(); //this will prevent the default submit

    // alert('submit')
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

      addPaymentId(data.payment_id);

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
    });
  }

  function addPaymentId(id) {
    $('#order_patment_id').val(id)
  }


});
