NB. jhcanvas creates jpage and uses as src in iframe

0 : 0
usage:
can=: 'jhjcanvas;_'jpage ''
setrefresh__can jsxnew jscfont '12pt ',PC_FONTFIXED
)

0 : 0
query to browser
when the canvas page is created by ev_body_load
 creates the canvas context, and based on either a default font
 or font set in the initial command buffer
 gets text metrics and calls the server ev_query_event handler
 to set fontwidth,fonthweight

following do not work - would be nice if it did
jjs_jhs_'qdata= "mumble";callj(qdata);'
jjs_jhs_'qdata= "mumble";setTimeout(function(){callj(qdata);},200);
)

require'~addons/ide/jhs/gl2.ijs'

coclass'jhjcanvas'
coinsert'jhs'
coinsert'jgl2'

jsxbuf=: ''

ev_create=: 3 : 0
PARENT=: COCREATOR
refresh=: ''
JS=: JS hrplc'BUFFER CMDS';(jsxarg refresh);CMDS
)

NB. JWID run doit_cmds
run=: 4 : 0
jjs_jhs_ 'findwindowbyJWID("',x,'").jbyid("jcanvas").contentWindow.doit("',(jsxarg y),'");'
)

NB. pass mouse click to parent
ev_mouse_click=: 3 : 0
ev_mouse_click__PARENT''
)

ev_mouse_down=: 3 : 0
ev_mouse_down__PARENT''
)

ev_mouse_up=: 3 : 0
ev_mouse_up__PARENT''
)

NB. ev_mouse_move too slow

HBS=: 0 : 0
'<canvas id="can" width="2000px" height="2000px"></canvas>'
)

NB.! #can{width:500px;height:500px;}
CSS=: 0 : 0
)

NB. ev_body_load creates context, sets font, gets width,height, calls this handler
ev_query_click=: 3 : 0
'fontwidth fontheight'=: 0".getv'jdata'
jhrcmds''
)

fixcmds=: 3 : 0
a=. (<': '),~each (<'case '),each   ":each<"0 i.#y
;LF,~each a,each (<'(d);break;'),~each   (<'jsc'),each y
)

setrefresh=: 3 : 0
JS=: JS,LF,'buffer="',(jsxarg y),'"',LF
)

CMDS=: fixcmds ncmds

JS=: 0 : 0

var x= 0, y= 0, down= 0, rfi= 10000000, can, context;
buffer="<BUFFER>"; // refresh buffer

function ev_body_load(){init();}

function init(){
 can = document.getElementById('can');
 context = can.getContext('2d');

 // ajax calls are slow and mouse events are lost - especially mousmove
 // handle only mousedown and mouseup
 can.addEventListener('click', e =>     {down= 0;mevent("click",e);});
 //can.addEventListener('mousedown', e => {down= 1;mevent("down",e);});
 //can.addEventListener('mouseup', e =>   {down= 0;mevent("up",e);});
 // can.addEventListener('mousemove', e => {mevent("move",e);});

doit(buffer);

var t= context.measureText("iiiiiwwwww");
qdata= (t.width/10)+" "+(t.fontBoundingBoxDescent+t.fontBoundingBoxAscent);
callj(qdata);
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
<CMDS>
    break;
   default:
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
  jdoajax([],e.offsetX+" "+e.offsetY+" "+down);
}

// process J mouse event handler result
function ev_mouse_down_ajax(){doit(rq.responseText.substr(rqoffset));}
function ev_mouse_up_ajax(){ev_mouse_down_ajax();}
function ev_mouse_move_ajax(){ev_mouse_down_ajax();}

)
