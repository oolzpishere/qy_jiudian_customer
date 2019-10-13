$(document).on("ready page:load turbolinks:load", function() {
  if ($('.hotel-images-slick').length > 0) {
    $('.hotel-images-slick').slick({
      dots: true,
      arrows: true,
      infinite: true,
      speed: 300,
      slidesToShow: 1,
      adaptiveHeight: true
    });
  }


})
