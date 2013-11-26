$(document).ready(function(){
  $(".cell").click(function(e) {
  	alert("click");
    $.get(e.srcElement.id, function(data) {
      console.log(data);
      alert(data);
      if (data != 'illegal') {
        $(e.target).addClass("circle");
        $("#"+data).addClass( "cross" );
      }
      else {
        alert("Illegal move!")
      }
      //alert( "Load was performed." );
    });
  });
});

