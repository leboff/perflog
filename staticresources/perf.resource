var body = document.childNodes[1].childNodes[1];
for(var i = body.childNodes.length; i >0; i--)
 { 
     var node = body.childNodes[i-1]; 
     if(node.nodeType===8 && node.textContent.indexOf('page generation time')!==-1){
         if(logPerformance){
         	logPerformance(node.textContent);
         }
         break;
     }
 }; 