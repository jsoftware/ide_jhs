var x= 0, y= 0, down= 0, rfi= 10000000, can, context;
buffer="<BUFFER>"; // refresh buffer

function ev_body_load(){init();}

function init(){
  can = document.getElementById('can');
  context = can.getContext('2d');

  // ajax calls are slow and mouse events are lost - especially mousmove
  can.addEventListener('click', e =>     {down= 0;mevent("click",e);});
  can.addEventListener('mousedown', e => {down= 1;mevent("down",e);});
  can.addEventListener('mouseup', e =>   {down= 0;mevent("up",e);});

  const handleMouseMove = debounce((e) => {mevent("move",e);}, 100); // delay
  can.addEventListener('mousemove', handleMouseMove);
  
  const debouncedResizeHandler = debounce(myResizeHandler, 100); // delay
  const resizeObserver = new ResizeObserver(debouncedResizeHandler);
  resizeObserver.observe(can.parentElement.parentElement); // watch iframe to resize canvas
}

// jsc... cmds map directly to canvas commands
function jscclearRect(a){context.clearRect(a[0],a[1],a[2],a[3]);}
function jscrect(a){context.rect(a[0],a[1],a[2],a[3]);}
function jscfillStyle(a){context.fillStyle= stringfints(a);}
function jscstrokeStyle(a){context.strokeStyle= stringfints(a);}
function jscbeginPath(){context.beginPath();}
function jscclosePath(){context.closePath();}
function jscfill(){context.fill();}
function jscstroke(){context.stroke();}
function jsclineWidth(a){context.lineWidth= a[0];}
function jscfont(a){context.font= stringfints(a);}
function jscfillText(a){context.fillText(stringfints(a.slice(2,a.length)),a[0],a[1]);}
function jscstrokeText(a){context.strokeText(stringfints(a.slice(2,a.length)),a[0],a[1]);}
function jscmoveTo(a){context.moveTo(a[0],a[1]);}
function jsclineTo(a){context.lineTo(a[0],a[1]);}
function jscellipse(a){context.ellipse(a[0],a[1],a[2],a[3],a[4]/rfi,a[5]/rfi,a[6]/rfi,a[7]);}
function jscarc(a){context.arc(a[0],a[1],a[2],a[3]/rfi,a[4]/rfi,a[5]);}
function jscclip(){context.clip();}
function jscsave(){context.save();}
function jscrestore(){;context.restore();}

// convert UTF-16 array to string
function stringfints(a)
{
 var str = "";
 for (var i=0;i<a.length;i++ ) 
  str += String.fromCharCode(a[i]);
 return str;
}

// a is string of , separated numbers - command,#,args ...
function doit(a)
{
 if(0==a.length)return; // avoid empty string -> 0
 a= a.split(",").map(Number) // convert string to int array
 for(var i=0;i<a.length;i=i+2+a[i+1])
 {
  var d= a.slice(i+2,i+2+a[i+1]);
  switch(a[i])
  {
    case 0: jscfillStyle(d);break;
    case 1: jscstrokeStyle(d);break;
    case 2: jscrect(d);break;
    case 3: jscfillText(d);break;
    case 4: jscfont(d);break;
    case 5: jsclineWidth(d);break;
    case 6: jscbeginPath(d);break;
    case 7: jscfill(d);break;
    case 8: jscstroke(d);break;
    case 9: jscclearRect(d);break;
    case 10: jscmoveTo(d);break;
    case 11: jsclineTo(d);break;
    case 12: jscclosePath(d);break;
    case 13: jscellipse(d);break;
    case 14: jscstrokeText(d);break;
    case 15: jscarc(d);break;
    case 16: jscclip(d);break;
    case 17: jscsave(d);break;
    case 18: jscrestore(d);break;
    break;
   default:
    alert('doit bad command: '+a[i]);
    break;
  }
 }
}

// call J mouse event handler
function mevent(type,e)
{
  jform.jid.value= "mouse";
  jform.jmid.value="mouse";
  jform.jtype.value=type;
  jform.jsid.value="";
  jdoajax([],e.clientX+" "+e.clientY+" "+can.width+' '+can.height+' '+down);
}


const myResizeHandler = (entries => {
        for (let entry of entries) {
            if (entry.target === can.parentElement.parentElement) {
                // Update the canvas size
                can.width = entry.contentRect.width-4;   //! 2*borderwidth
                can.height = entry.contentRect.height-8; // ?

                jform.jid.value= "mouse";
                jform.jmid.value="mouse";
                jform.jtype.value="resize";
                jform.jsid.value="";
                
                // resize has reset canvas - need to reinit
                doit(buffer);
                var t= context.measureText("iiiiiwwwww");
                jdoajax([],can.width+' '+can.height+' '+(t.width/10)+" "+(t.fontBoundingBoxDescent+t.fontBoundingBoxAscent));
            }
        }
    });

// debounce and throttle 
function debounce(func, delay) {
      let timeout;
      return function(...args) {
        const context = this;
        clearTimeout(timeout); // Clear the previous timer
        timeout = setTimeout(() => {
          func.apply(context, args); // Execute the function after the delay
        }, delay);
      };
}
