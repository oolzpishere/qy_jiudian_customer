
$(document).on("ready page:load turbolinks:load", function() {
  // #hotel form
  // set tax_rate default value
  if ($('#hotel_tax_rate').length > 0 && $('#hotel_tax_rate').val().length == 0) {
    $('#hotel_tax_rate').val("0.15")
  }

  $('#hotel_room_types').on('cocoon:after-insert', function(e, insertedItem, originalEvent) {
    $('.date_rooms').on('cocoon:after-insert', function(e, insertedItem, originalEvent) {
      $('.date_for_rooms').datetimepicker({
        debug: false,
        format: "YYYY-MM-DD",
      });
    })
  })

  $('.date_rooms').on('cocoon:after-insert', function(e, insertedItem, originalEvent) {
    $('.date_for_rooms').datetimepicker({
      debug: false,
      format: "YYYY-MM-DD",
    });
  })

});
