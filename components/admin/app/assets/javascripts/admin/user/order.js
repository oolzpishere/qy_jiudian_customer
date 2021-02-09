//= require admin/date_rooms
import {DateRooms} from "javascripts/admin/date_rooms"
import {RoomsController} from "javascripts/admin/rooms_controller"

$(document).on("turbolinks:load", function() {

  // #form
  if ( $('#user_order_form').length > 0 ) {
    var hotel_id = $('#order_hotel_id').val();
    var date_rooms = new DateRooms();
    var success_proc = date_rooms.resetDateRoomsTable;
    date_rooms.getHotelDataAndRun(hotel_id, success_proc);
    // add room logic:
    var rooms_controller = new RoomsController();

    // update earnest price detail
    var earnest_each = $('.earnest_each').attr("data-earnest-each");
    earnest_each = parseInt(earnest_each)
    if ( ($('#has-many-addmore').length > 0) && ($('#earnest_total_fee').length > 0) ) {
      var earnest_total_fee = earnest_each * rooms_controller.rooms_num
      $('#earnest_total_fee').text(earnest_total_fee);

      $('#has-many-addmore').on('click', function(e) {
        // room_list on change, update room_num
        $('.rooms_num').text(rooms_controller.rooms_num);
        $('#rooms_num').val(rooms_controller.rooms_num);
        // update total earnest
        earnest_total_fee = earnest_each * rooms_controller.rooms_num
        $('#earnest_total_fee').text(earnest_total_fee);
      })
    }



  }


  // date_rooms.resetDateRoomsTable();

});
