$(document).ready(function(){
  $(".cell").click(function(event) {
    alert(event.target.id);
    var pathname = window.location.pathname;
    //alert(pathname);
   // alert(event.srcElement.id);
    var ruta =pathname + event.target.id;
    //alert("La ruta " + ruta);

    $.get(ruta, function(data) {
      if (data != 'illegal') {
        alert("Datos "+data);
        alert("Celda "+event.target.id);

        $("#"+event.target.id).addClass("circle");
        $("#"+data).addClass( "cross" );
      }
      else {
        alert("Illegal move!")
      }
    });
  });
});

