//= require admin/date_rooms

$(document).on("ready page:load turbolinks:load", function() {

  // #form
  if ( $('#user_order_form').length > 0 ) {
    var hotel_id = $('#order_hotel_id').val();
    var date_rooms = new DateRooms();
    var success_proc = date_rooms.resetDateRoomsTable;
    date_rooms.getHotelDataAndRun(hotel_id, success_proc);
  }

  // date_rooms.resetDateRoomsTable();

});
