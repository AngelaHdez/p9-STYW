$(document).ready(function(){
  $(".cell").click(function(e) {
  	//alert(e.target.id);
    $.get(e.srcElement.id, function(data) {

      //alert( "Load was performed." );
    });
  });
});

