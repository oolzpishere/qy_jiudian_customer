
document.addEventListener('turbolinks:load', ()=>{
  var text = $('h1').text()
  $('h1').text(text + " turbolinks:load")
  // console.log( text )
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  
})
