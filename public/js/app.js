$(document).ready(function(){
  $(".cell").click(function(event) {
    //alert(event.target.id);
    var pathname = window.location.pathname;
    //alert(pathname);
   // alert(event.srcElement.id);
    var ruta =pathname + event.target.id;
    //alert("La ruta " + ruta);

    $.get(ruta, function(data) {
      if (data == 'illegal'){
        alert("Illegal move!")
      } else if (data.length < 3){
        //alert("Datos "+data);
        //alert("Celda "+event.target.id);
    
        $("#"+event.target.id).addClass("circle");
        $("#"+data).addClass( "cross" );
      }else{
        //Redirigir a la pagina de ganador o perdedor o empate
        //alert(data);
        setTimeout(function(){
          url = data;
          $(location).attr('href',url);
          },200); //redirijo a la página que me pase app.rb
      }
    });
  });
});


