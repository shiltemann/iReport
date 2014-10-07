   function resizeIframe(obj) {
    oldheight=obj.style.height
    oldwidth=obj.style.width
    obj.style.height = obj.contentWindow.document.body.scrollHeight + 4 + 'px';
    obj.style.width = obj.contentWindow.document.body.scrollWidth + 4 + 'px';
    if(obj.style.height < 50){
     obj.style.height=oldheight
    }
   }