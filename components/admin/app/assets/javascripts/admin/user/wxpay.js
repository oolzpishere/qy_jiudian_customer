
$(document).on("ready page:load turbolinks:load", function() {

  function wxpay() {
    $.post('/wx_pay', function(data) {
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
  

});
