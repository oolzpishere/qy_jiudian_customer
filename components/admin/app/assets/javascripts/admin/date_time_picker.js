
$(document).on("turbolinks:load", function() {
  $('.datepicker').datepicker({
    language: 'zh-CN',
    format: 'yyyy-mm-dd'
  });

  // hotel form date_rooms
  // $('.date_for_rooms').datepicker({
  // });
  // $('#order_checkin').datepicker({
  //   format: 'yyyy-mm-dd'
  // });
  // $('#order_checkout').datepicker({
  //   format: "yyyy-mm-dd"
  // });

  $("#order_checkin").on("changeDate", function (e) {
    var startDate = $(this).datepicker('getFormattedDate'),
        endDate = $('#order_checkout').datepicker('getFormattedDate');
    setNight(startDate, endDate);
  });
  $("#order_checkout").on("changeDate", function (e) {
    var startDate = $('#order_checkin').datepicker('getFormattedDate'),
        endDate = $(this).datepicker('getFormattedDate');
    setNight(startDate, endDate);
  });

  function setNight(startDate, endDate){
    if ( startDate && endDate ) {
      $('#order_nights').attr( 'value', daysBetween(startDate, endDate) );
    }
    if ($('#order_nights_label').length > 0){
      $('#order_nights_label').text( daysBetween(startDate, endDate) )
    }
  }

  function daysBetween(startDate, endDate) {
    var millisecondsPerDay = 24 * 60 * 60 * 1000;
    return (treatAsUTC(endDate) - treatAsUTC(startDate)) / millisecondsPerDay;
  }

  function treatAsUTC(date) {
    var result = new Date(date);
    result.setMinutes(result.getMinutes() - result.getTimezoneOffset());
    return result;
  }

});
