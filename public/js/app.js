$(document).ready(function(){
  $(".cell").click(function(e) {
  	alert("click");
    $.get(e.srcElement.id, function(data) {
      console.log(data);
      alert(data);
     
      //alert( "Load was performed." );
    });
  });
});

