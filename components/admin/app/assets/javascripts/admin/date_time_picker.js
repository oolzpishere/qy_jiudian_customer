$(function () {
  $('[data-type="time"]').datetimepicker({
    debug: false,
    format: "HH:mm:ss",
  });
  $('#conference_start').datetimepicker({
    debug: false,
    format: "YYYY-MM-DD",
  });
  $('#conference_finish').datetimepicker({
    debug: false,
    format: "YYYY-MM-DD",
  });
  $('#conference_sale_from').datetimepicker({
    debug: false,
    format: "YYYY-MM-DD",
  });
  $('#conference_sale_to').datetimepicker({
    debug: false,
    format: "YYYY-MM-DD",
  });
  // hotel form date_rooms
  $('.date_for_rooms').datetimepicker({
    debug: false,
    format: "YYYY-MM-DD",
  });


  $('#order_checkin').datetimepicker({
    format: "YYYY-MM-DD"
  });
  $('#order_checkout').datetimepicker({
    format: "YYYY-MM-DD",
    useCurrent: false //Important! See issue #1075
  });

  $("#order_checkin").on("dp.change", function (e) {
    var startDate = $(this).data('date'),
        endDate = $('#order_checkout').data('date');
    $('#order_checkout').data("DateTimePicker").minDate(e.date);

    setNight(startDate, endDate);
  });
  $("#order_checkout").on("dp.change", function (e) {
    var startDate = $('#order_checkin').data('date'),
        endDate = $(this).data('date');
    $('#order_checkin').data("DateTimePicker").maxDate(e.date);

    setNight(startDate, endDate);
  });

  function setNight(startDate, endDate){
    if ( startDate && endDate ) {
      $('#order_nights').attr( 'value', daysBetween(startDate, endDate) );
    }
  }

  function treatAsUTC(date) {
    var result = new Date(date);
    result.setMinutes(result.getMinutes() - result.getTimezoneOffset());
    return result;
  }

  function daysBetween(startDate, endDate) {
    var millisecondsPerDay = 24 * 60 * 60 * 1000;
    return (treatAsUTC(endDate) - treatAsUTC(startDate)) / millisecondsPerDay;
  }

});
