console.log("rooms_controller")
export { RoomsController };

var RoomsController = function() {
  this.rooms_num = 0;
  this.initRoomsCount();
  this.clickToAddRoom();
}

RoomsController.prototype.initRoomsCount = function(){
  var _self = this;
  if ($('#rooms_count').length > 0) {
    _self.rooms_num = $("#rooms_ul li").length
    $('#rooms_count').text( _self.rooms_num )
  }
};

RoomsController.prototype.clickToAddRoom = function(){
  var _self = this;
  if ($('#has-many-addmore').length > 0) {
    $('#has-many-addmore:not(._bound_click_to_add_room)')
    .addClass('_bound_click_to_add_room')
    .on('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      _self.addMore("#rooms_ul");
      // change rooms_count
      _self.rooms_num = $("#rooms_ul li").length
      $('#rooms_count').text( _self.rooms_num );
    });
  }
}

RoomsController.prototype.addMore = function(groupId) {
  var newfield = $(groupId).children("li").last().clone();
  var newid = Number(newfield.children("input").attr('id').match(/attributes_(\d+)_/)[1]) + 1;
  // var newname = Number(newfield.attr('id').replace(/_(\d+)_/, "$1")) + 1;

  // newdiv.attr('id', "post_relics_attributes_" + newid)

  $.each(newfield.find("input[type='text']"), function() {
     var thisid = $(this).attr('id'),
     thisname = $(this).attr('name');

     thisid = thisid.replace(/\d+/, newid);
     thisname = thisname.replace(/\d+/, newid);

     $(this).attr('name', thisname);
     $(this).attr('id', thisid);
     $(this).attr('required', false);
     // 清空内容
     var val = $(this).val();
     if (val == "0" || val == "1" ) {
       $(this).val('0');
     } else {
       $(this).val('');
     }
  });

  $.each(newfield.find("label"), function() {
     var thisname = $(this).attr('for');
     thisname = thisname.replace(/\d/, newid);

     $(this).attr('for', thisname);
   });

  $(groupId).append(newfield);
}
