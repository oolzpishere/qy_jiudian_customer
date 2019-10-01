
$(document).on("ready page:load turbolinks:load", function() {

  $('#hotel_conference_selection').selectize();

  var xhr;
  var order_conference_selection, $order_conference_selection;
  var order_hotel_selection, $order_hotel_selection;
  var room_type_selection, $room_type_selection
  var hotel_hash, room_type_selected;
  var existingRoomTypeOptions;

  $order_conference_selection = $('#order_conference_selection').selectize({
    onChange: function(value) {
      if (!value.length) return;
      order_hotel_selection.disable();
      order_hotel_selection.clear();
      order_hotel_selection.clearOptions();
      order_hotel_selection.load(function(callback) {
        xhr && xhr.abort();
        xhr = $.ajax({
            url: '/manager/conferences/' + value + '/hotels.json',
            success: function(results) {
                order_hotel_selection.enable();
                callback(results);
            },
            error: function() {
                callback();
            }
        })
      });
    }
  });

  $order_hotel_selection = $('#order_hotel_selection').selectize({
    valueField: 'id',
    labelField: 'name',
    searchField: ['name'],
    // get hotel_hash
    onInitialize: function(){
      if (this.items.length) {
        var init_hotel_id = this.items[0];
        $.ajax({
          url: '/manager/hotels/' + init_hotel_id + '.json',
          success: function(results) {
            hotel_hash = results;
            setDateRoomsTable()
          },
          error: function() {
          }
        });
      }
    },
    // get hotel_hash; resetRoomTypeOptions and resetAllHotelField;
    onChange: function(value) {
      if (!value.length) return;
      $.ajax({
        url: '/manager/hotels/' + value + '.json',
        success: function(results) {
          hotel_hash = results;
          // refresh hotel_hash first!
          resetRoomTypeOptions();
          resetAllHotelField();
          setDateRoomsTable()
        },
        error: function() {
        }
      })

    }
  });

  // set room_type_selected; onChange resetAllHotelField;
  $room_type_selection = $('#room_type_selection').selectize({
    valueField: 'db_name',
    labelField: 'name',
    searchField: ['name'],
    onInitialize: function(){
      if (this.items.length) {
        room_type_selected = this.items[0];
      }
    },
    onChange: function(value) {
      if (!value.length) return;
      room_type_selected = value;
      resetAllHotelField();
    }
  });

  if ($order_conference_selection.length) {
    order_conference_selection  = $order_conference_selection[0].selectize;
  }
  if ($order_hotel_selection.length) {
    order_hotel_selection = $order_hotel_selection[0].selectize;
  }
  if ($room_type_selection.length) {
    room_type_selection = $room_type_selection[0].selectize;
  }


  function resetAllHotelField(){
    // var price_db_name = room_type_selected + '_price';
    if (hotel_hash["hotel_room_types"].length > 0) {
      var hotel_room_type = hotel_hash["hotel_room_types"].find(function(element) {
        return element["name_eng"] == room_type_selected;
      });
    }
    if (hotel_room_type) {
      var hotel_price = hotel_room_type['price']
      $('#order_price').val(hotel_price)
    }

    $('#breakfast_selection').val(hotel_hash["breakfast"])
  }

  var room_types_array = ["twin_beds", "queen_bed", "three_beds","other_twin_beds"];
  var roomTypeTranslate = {"twin_beds": "双人房","queen_bed": "大床房", "three_beds": "三人房","other_twin_beds": "其它双人房" };
  function resetRoomTypeOptions(){
    room_type_selection.clear();
    room_type_selection.clearOptions();

    // var existingRoomTypeArray = [];
    var existingRoomTypeOptions = [];

    if (hotel_hash["room_types"].length > 0) {
      hotel_hash["room_types"].forEach(function(element) {
        var hash = {"db_name": element["name_eng"], "name": element["name"]};
          existingRoomTypeOptions.push(hash);
      });
    }

    // room_types_array.forEach(function(element) {
    //   if (hotel_hash && hotel_hash[element] > 0 ) {
    //     existingRoomTypeArray.push(element);
    //   }
    // });

    // existingRoomTypeArray.forEach(function(element){
    //   var hash = {"db_name": element, "name": roomTypeTranslate[element]};
    //     existingRoomTypeOptions.push(hash);
    // });

    room_type_selection.load(function(callback) {
      callback(existingRoomTypeOptions)
    });
  }

  // get date_rooms table
  function setDateRoomsTable(){
    if ($('#order_date_rooms_table').length > 0) {
      if (hotel_hash["hotel_room_types"].length > 0) {
        var hotel_room_types = hotel_hash["hotel_room_types"];
      } else {
        return
      }

      tbl = document.getElementById('order_date_rooms_tbody')
      // remove current tbody rows
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
        // var date = hotel_room_type['date'],
        //     rooms = hotel_room_type['rooms'];
        // td.appendChild(document.createTextNode(date));
        // td2.appendChild(document.createTextNode(rooms));
      });
    }
  }

});
