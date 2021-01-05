
var DateRooms = function() {
  // this.hotel_id = hotel_id;
  this.hotel_hash = {};
}

// because ajax is async, ajax will pending, if call getDateRoomsData then setDateRoomsTable on instance, hotel_hash wound not set.
DateRooms.prototype.getHotelDataAndRun = function(hotel_id, success_proc){
  var _self = this;
  $.ajax({
    url: '/product/hotels/' + hotel_id + '.json',
    success: function(results) {
      // set object hotel_hash.
      _self.hotel_hash = results;
      success_proc(_self.hotel_hash);
      return true;
    },
    error: function() {
    }
  });
};

DateRooms.prototype.resetDateRoomsTable = function(hotel_hash){
  if ($('#order_date_rooms_table').length > 0) {
    if (hotel_hash["hotel_room_types"].length > 0) {
      var hotel_room_types = hotel_hash["hotel_room_types"];
    } else {
      return
    }

    tbl = document.getElementById('order_date_rooms_tbody')
    // remove current tbody all tr rows.
    $('#order_date_rooms_tbody tr').remove()

    hotel_room_types.forEach(function(hotel_room_type) {
      var tr = tbl.insertRow();
      var td_type = tr.insertCell();

      td_type.appendChild(document.createTextNode(hotel_room_type["name"]));
      td_type.setAttribute('colspan', '2')
      td_type.style = 'text-align: center';

      hotel_room_type["date_rooms"].forEach(function(date_room) {
        var tr = tbl.insertRow();
        var td1 = tr.insertCell(), td2 = tr.insertCell();
        td1.appendChild(document.createTextNode(date_room["date"]));
        td2.appendChild(document.createTextNode(date_room["rooms"]));
      });

    });
  }
};
