$(document).ready(function(){
  $(".cell").click(function(e) {
  	alert(e.target.id);
  	var pathname = window.location.pathname;
  	//alert(pathname);
  	//alert(e.srcElement.id);
  	var ruta =pathname + e.srcElement.id;
  	//alert(ruta);
    $.get(ruta, function(data) {

    	alert("entro");
    });
  });
});
