

$(document).on("turbolinks:load", function() {
  if ($('.hotel-images-slick').length > 0) {
    $('.hotel-images-slick').not('.slick-initialized').slick({
      dots: true,
      arrows: true,
      infinite: true,
      speed: 300,
      slidesToShow: 1,
      adaptiveHeight: true
    });
  }


})
