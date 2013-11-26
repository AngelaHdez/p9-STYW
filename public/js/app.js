$(document).ready(function(){
  $(".cell").click(function(e) {
   alert(e.target.id);
    $.get(e.target.id, function(data) {
     alert(data);
      //alert( "Load was performed." );
    });
  });
});

