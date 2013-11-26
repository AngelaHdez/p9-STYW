$(document).ready(function(){
  $(".cell").click(function(event) {
    alert(event.target.id);
    var pathname = window.location.pathname;
    alert(pathname);
   // alert(event.srcElement.id);
    var ruta =pathname + event.target.id;
    //alert("La ruta " + ruta);

    $.get(ruta, function(data) {
        alert("Datos "+data);
    });
  });
});

