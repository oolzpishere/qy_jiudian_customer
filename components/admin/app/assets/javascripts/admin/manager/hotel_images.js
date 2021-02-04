import BlueimpTmpl from "blueimp-tmpl/js/tmpl"

$(document).on("turbolinks:load", function() {
  if ( $('#fileupload').length > 0 ) {
    _initFileupload();
    _renderExistedImages();
  }

  function _initFileupload(){
    $('#fileupload').fileupload({
      // dataType: 'json',
      // options: {
        autoUpload: false,
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
      // },
      uploadTemplateId: "template-upload",
      downloadTemplateId: "template-download",

    });
  }

  function _renderExistedImages(){
    $.getJSON($('#fileupload').prop('action'), function (files) {
      var fu = $('#fileupload').data('blueimpFileupload'),
      template;
      console.log(files);
      template = fu._renderDownload(files)
      .appendTo($('#fileupload .files'));
      // Force reflow:
      // fu._reflow = fu._transition && template.length &&
      // template[0].offsetWidth;
      // template.addClass('in');
      // $('#loading').remove();
    });
  }

});
