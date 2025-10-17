var x= 0, y= 0, down= 0, rfi= 10000000, can, context;
buffer="<BUFFER>"; // refresh buffer

function ev_body_load(){init();}

function init(){
  can = document.getElementById('canvas');
  context = can.getContext('2d');

  // ajax calls are slow events when the server is busy are discarder
  // can.addEventListener('click', e =>     {down= 0;mevent("click",e);}); // down+up+click
  can.addEventListener('mousedown', e => {down= 1;mevent("down",e);});
  can.addEventListener('mouseup', e =>   {down= 0;mevent("up",e);});
  can.addEventListener('mousemove', e =>   {down= 0;mevent("move",e);});
  const resizeObserver = new ResizeObserver(myResizeHandler);
  resizeObserver.observe(can.parentElement.parentElement); // watch iframe to resize canvas
}

/*
qpixels and pixels data is not passed with browser-server http
 as this is too slow
instead a handle is passed to pixels that selects a previous qpixels

this is fast for moving stuff around
 which is all that dissect requires
*/

var pixelbase= 0;
var pixels= [];

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
function jscrestore(){context.restore();}
function jscpixels(a){context.putImageData(pixels[a[4]-pixelbase],a[0],a[1]);}

function jscqpixels(a){
  pixels.push(context.getImageData(a[0],a[1],a[2],a[3]));
  if(pixels.length>3){
    pixelbase+= 1;
    pixels= pixels.slice(1);
  }
}

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
    case 19: jscqpixels(d);break;
    case 20: jscpixels(d);break;
    break;
   default:
    alert('doit bad command: '+a[i]);
    break;
  }
 }
}

var lostevents= 0;
var upper;

// call J jev_canvas handler
function mevent(type,e)
{
  jform.jid.value= '';
  jform.jmid.value= 'canvas';
  jform.jsid.value= '';
  jform.jtype.value= 'canvas';
  setjinfo(e);
  var t= e.clientX+" "+e.clientY+" "+can.width+' '+can.height;
  t+= ' '+((e.buttons==1)?1:0)+' '+((e.buttons==4)?1:0)+' '+(e.ctrlKey?1:0)+' '+(e.shiftKey?1:0)+' '+((e.buttons==2)?1:0);
  t+= ' 0 0 0'; // isigrapgh 0 0 wheeldegrees
  var a= context.measureText("iiiiiwwwww");
  t+= ' '+(a.width/10)+' '+(a.fontBoundingBoxDescent+a.fontBoundingBoxAscent)+' '+type+' '+window.frameElement.id+' '+lostevents;

  if(0!=rqstate){ // J server is busy
    lostevents+= 1;
    if(type=='up'){
      // settimer to do a missed up event
      upper= t;
      setTimeout(fixit,10);
    }
   return;
  }
  jdoajax([],t,"jev_canvas_"+jform.jlocale.value+"_[0",true); // async
}

// kludge with problems - timer not cancelled and rqstate is not proper global server state
function fixit(){
  if(0==rqstate)
    jdoajax([],upper,"jev_canvas_"+jform.jlocale.value+"_[0",true); // async
  else
    setTimeout(fixit,10);
}

const myResizeHandler = (entries => {
      for (let entry of entries) {
          if (entry.target === can.parentElement.parentElement) {
              // Update the canvas size
              can.width = entry.contentRect.width-4;   //! 2*borderwidth
              can.height = entry.contentRect.height-8; // ?
              doit(buffer); // set default fixed pitch font
              mevent('resize',entry);
          }
      }
});

/* debounce event - also see throttle
// debounce mouse move
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
*/
