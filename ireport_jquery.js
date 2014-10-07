$(function() {
   $("#tabs" ).tabs();
   });
   $(function() {
    $(".resizable" ).resizable();
   });
   $(document).ready(function(){
    $('.zoomme').zoom();
    $('#ex2').zoom({ on:'grab' });
    $('#ex3').zoom({ on:'click' });
    $('#ex4').zoom({ on:'toggle' });
    $('.fancyiframe').iFrameResize({
     heightCalculationMethod: 'max',
     minHeight: 250,
     scrolling: true,
     checkOrigin: false,
     bodyMargin: 15
    });
    $('.unfancyiframe').iFrameResize({
     heightCalculationMethod: 'max',
     scrolling: false,
     checkOrigin: false
    });
   });