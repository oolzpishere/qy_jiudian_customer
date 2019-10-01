
$(document).on("ready page:load turbolinks:load", function() {
  function addMore(groupId) {
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

  $('#has-many-addmore').on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    addMore("#rooms_ul")
    // change rooms_count
    $('#rooms_count').text( $("#rooms_ul li").length )
  });

  // init order form rooms count
  if ($('#rooms_count').length > 0) {
    $('#rooms_count').text( $("#rooms_ul li").length )
  }

});
