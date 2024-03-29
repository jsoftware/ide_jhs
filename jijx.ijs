NB. J HTTP Server - jijx app
coclass'jijx'
coinsert'jhs'

HBS=: 0 : 0
jhclose''

'uarrow' jhb ''
'darrow' jhb ''
'return' jhb ''
'advance'jhb ''

jhma''
jhjmlink''
'tour'     jhmg'tour';1;9
 'overview'jhmab'overview'
 'charttour'jhmab'chart'
 'canvas'  jhmab'canvas'
 'plot'    jhmab'plot'
 'spx'     jhmab'spx'
 'labs'    jhmab'labs'
'help'               jhmg'?';1;16
 'welcome'           jhmab'welcome'
 (0=nc<'tool_guest')#'guest' jhmab'guest'
 'shortcuts'         jhmab'shortcuts' 
 'popups'            jhmab'pop-ups'
 'closing'           jhmab'close'
 'framework'         jhmab'framework'
 'helpwikijhs'       jhmab'JHS'
 'helpwikinuvoc'     jhmab'vocabulary'
 'helpwikiconstant'  jhmab'constant'
 'helpwikicontrol'   jhmab'control'
 'helpwikiforeign'   jhmab'foreign'
 'helpwikiancillary' jhmab'ancillary'
 'helpwikistdlib'    jhmab'standard library'
 'helpwikirelnotes'  jhmab'release notes'
 'helphelp'          jhmab'807 html legacy'
 'about'             jhmab'about'
'adv'   jhmg '>';0;10
'uarrow'jhmg '↑';0;10
'darrow'jhmg '↓';0;10
jhmz''
jhresize''
'log' jhec'<LOG>'
'ijs' jhhidden'<IJS>'
)

0 : 0
'tool'   jhmg'tool';1;16
 (0=nc<'tool_guest')#'guest' jhmab'guest'
 'app'     jhmab'app'
 'demo'    jhmab'demo'
 'chart'   jhmab'plot-chart'
 'jd3'     jhmab'plot-d3'
 'debug'   jhmab'debug'
 'debugjs' jhmab'debug javascript'
 'react'   jhmab'react'
 'node'    jhmab'https'
 'print'   jhmab'print'
 'sp'      jhmab'sp'
 'table'   jhmab'table'
 'watch'   jhmab'watch'
)

jev_get=: create

NB. move new transaction(s) to log
uplog=: 3 : 0
LOG_jhs_=: LOG,LOGN
LOGN_jhs_=: ''
)

NB. y is J prompt - '' '   ' or '      '
NB. called at start of input
NB. ff/safari/chrome collapse empty div (hence bull)
NB. empty prompt is &bull; which is removed if present from input
urlresponse=: 3 : 0
if. 0=#y do.
 t=. JZWSPU8
 PROMPT_jhs_=: JZWSPU8
else.
 t=. (6*#y)$'&nbsp;'
 PROMPT_jhs_=: y
end.
t=. '<div id="prompt" class="log"  onpaste="mypaste(event)">',t,'</div>'
d=. LOGN,t
uplog''
if. METHOD-:'post' do.
 if. CHUNKY do.
  CHUNKY_jhs_=: 0
  jhrajax_z d
 else.
  jhrajax d
 end. 
else.
 create''
end.
)

NB. refresh response - not jajax
create=: 3 : 0
uplog''
'jijx' jhr 'LOG';LOG
)

ev_advance_click=: 3 : 0
select. ADVANCE
case. 'spx' do. spx__''
case. 'lab' do. lab 0
case. 'wiki'do. wikistep_jsp_''
case.       do. echo 'no open lab/spx to advance'
end.
)

jloadnoun_z_=: 0!:100

ev_clearrefresh_click=: 3 : 'LOG_jhs_=: '''''

ev_about_click=: 3 : 0
jhtml'<hr/>'
echo JVERSION
echo' '
echo'Copyright 1994-2024 Jsoftware Inc.'
jhtml'<hr/>'
)

ev_close_click=: 3 : 0
a=. '<div id="prompt" class="log"  onpaste="mypaste(event)"><b><font style="color:red;"><br>'
b=. '</font></b></div>'
select. QRULES 
case. 0 do. NB. jhrajax and exit
 jhrajax a,'JHS server closed. Page disabled.',b
 exit''
case. 1 do. NB. jhrajax
 jhrajax a,'JHS server not closed. Page disabled.',b
case. 2 do. NB. exit
 exit''
end.
)

tour=: 4 : 0
jhtml'<hr>'
echo x
spx '~addons/ide/jhs/spx/',y
jhtml'<hr/>'
)

ev_plot_click=:  3 : 0
'plot tour'tour'plot.ijs'
)

ev_overview_click=: 3 : 0
'overview tour'tour'overview.ijs'
)

ev_charttour_click=: 3 : 0
'chart tour'tour'chart.ijs'
)

ev_canvas_click=: 3 : 0
'canvas tour'tour'canvas.ijs'
)

ev_tool_click=: 3 : 0
toollist''
)

ev_spx_click=:  3 : 0
'spx tour'tour'spx.ijs'
)

NB. default ctrl+,./ handlers
ADVANCE=: 'none'
ev_comma_ctrl =: 3 : 'sp__'''''
ev_dot_ctrl=: ev_advance_click
ev_slash_ctrl  =: 3 : 'i.0 0'
ev_less_ctrl   =: 3 : 'i.0 0'
ev_larger_ctrl =: 3 : 'i.0 0'
ev_query_ctrl =: 3 : 'i.0 0'
ev_semicolon_ctrl =:   3 : 'loadx__ 0'
ev_colon_ctrl =:       3 : 'echo''colon'''
ev_quote_ctrl_jijx_=: 3 : 'dbover dbxup'''''
ev_doublequote_ctrl =: 3 : 'dbinto dbxup'''''

load'~addons/ide/jhs/loadx.ijs'

jhjmlink=: 3 : 0
t=.   'jmlink' jhmg 'ide';1;13
t=. t,'jfile'  jhmab'jfile    f^'
t=. t,JIJSAPP  jhmab'jijs     J^'
t=. t,'jpacman'jhmab'jpacman'
t=. t,'jdebug' jhmab'jdebug'

if. 1=#gethv'node-jhs:' do.
 NB. t=. t,'jlogoff' jhmab'logoff'
 t=. t,'jbreak'  jhmab'break'
end.

t=. t,'tool'jhmab'tool'

t=. t,'clearwindow'jhmab'clear window'
t=. t,'clearrefresh'jhmab'clear refresh'
t=. t,'clearLS'jhmab'clear LS'
t=. t,'close'jhmab'quit q^'
t
)

CSS=: 0 : 0
*{font-family:<PC_FONTFIXED>;}
form{margin-top:0;margin-bottom:0;}
*.fm   {color:<PC_FM_COLOR>;}
*.er   {color:<PC_ER_COLOR>;}
*.log  {color:<PC_LOG_COLOR>;}
*.sys  {color:<PC_SYS_COLOR>;}
*.file {color:<PC_FILE_COLOR>;}

.jhb#uarrow{background-color:rgba(255,255,255,0);position:fixed;top:4em;right:0;margin:0px;
padding-left:8px;padding-right:8px;
border-width: 2px;border-color: blue;
}
.jhb#darrow{background-color:rgba(255,255,255,0);position:fixed;top:7em;right:0;margin:0px;
padding-left:8px;padding-right:8px;
border-width: 2px;border-color: red;
}
.jhb#return{background-color:rgba(255,255,255,0);position:fixed;top:10em;right:0;margin:0px;
padding-left:8px;padding-right:8px;
border-width: 2px;border-color: black;
}

.jhb#advance{background-color:rgba(255,255,255,0);position:fixed;top:13em;right:0;margin:0px;
padding-left:8px;padding-right:8px;
border-width: 2px;border-color: green;
}

)

NB. .jhb#esc{background-color:blue;position:relative;top: 60px;right:0;margin:0px;padding-left:8px;padding-right:8px;} /* quit esc-q button */
NB. .jhb#adv{background-color:green;position:relative;top: 120px;right:0;margin:0px;padding-left:8px;padding-right:8px;} /* quit esc-q button */

NB. *#log:focus{border:1px solid red;}
NB. *#log:focus{outline: none;} /* no focus mark in chrome */

JS=: 0 : 0 rplc '<QRULES>';":QRULES
var qrules= <QRULES>;
var allwins= []; // all windows created by jijx
var phead= '<div id="prompt" class="log" onpaste="mypaste(event)">';
var ptail= '</div>';
var globalajax; // sentence for enter setTimeout ajax
var TOT= 1;     // timeout time to let DOM settle before change
//var TOT= 100; // might need more time on slow devices???
var wjdebug= null; // jdebug window object
var touch;

function ev_body_focus(){setTimeout(ev_2_shortcut,TOT);}

function ev_body_load()
{
 if(window.visualViewport) window.visualViewport.onresize = onvpresize;
 jijxwindow= window;
 window.name= "jijx";
 jseval(false,jbyid("log").innerHTML); // redraw canvas elements
 newpline("   ");
 jresize();

 touch= ('ontouchstart' in window)||(navigator.maxTouchPoints>0)||(navigator.msMaxTouchPoints>0);
 if(!touch){
  jbyid('uarrow').style.display="none";
  jbyid('darrow').style.display="none";
  jbyid('return').style.display="none";
  jbyid('advance').style.display="none";
 }

 //! var el = document.getElementById('log')
 //!swipedetect(el, function(swipedir){if (swipedir =='left')alert('You just swiped left!')})
}

// iX devices only
function onvpresize(){
   VKB= (VKB==0)?window.innerHeight-window.visualViewport.height : 0;
   jresize();
   // scrollz/scrollintoview is required -scrollz without setcaret
   //setfocus(); // required by ff
   if(null==jbyid("prompt"))return;
   jbyid("prompt").scrollIntoView(false);
}

function mypaste(event){
 var t= event.clipboardData.getData('text/plain');
 t= t.replace(/\r/g,""); // remove CR
 var i= t.indexOf('\n');
 if(i!=-1 && i!=(t.length-1)) // multiple lines
 {
  t= t.replace(/\\/g,"\\\\");
  t= t.replace(/\'/g,"''");
  t= t.replace(/\n/g,"\\n");
  newpline("   cb_jhs_=:cbfix_jhs_'"+t+"'");
  event.preventDefault(); // prevent default undoing above change
 }
} 
 
function isdirty(){return 0!=allwins.length;}

function setfocus(){jbyid("log").focus();}

// iX - replaced by onvpresize - eventually kill off setting handlers for ecfocus/ecblur
function jecfocus(){}
function jecblur(){;}

// remove id - normally 1 but could be none or multiples
// remove id parent if removal of id makes it empty
function removeid(id)
{
 var parnt;
 while(1)
 {
  p= jbyid(id);
  if(null==p) break;
  parnt= p.parentNode;
  parnt.removeChild(p);
  if(0==parnt.childNodes.length) parnt.parentNode.removeChild(parnt);
 }
}

function updatelog(t)
{
 var n= document.createElement("div");
 n.innerHTML= jjsremove(t);
 removeid("prompt");
 jbyid("log").appendChild(n);
 setTimeout(scrollz,TOT); // allow doc to update
}

function scrollz()
{
 setfocus(); // required by ff
 if(null==jbyid("prompt"))return;
 jsetcaret("prompt",1);
 jbyid("prompt").scrollIntoView(false);
}

function scrollchunk(){jbyid("chunk").scrollIntoView(false);}

// ajax update window with new output
function ajax(ts)
{
 var a= ts[0];
 updatelog(a);
 jseval(true,a);
}

// ajax update window with new output
function ev_log_enter_ajax()
{
 a= rq.responseText.substr(rqoffset);
 updatelog(a);
 jseval(true,a);
}


function ev_log_enter_ajax_chunk()
{
 // jijx echo marks end of chunk with <!-- chunk --> 
 jbyid("log").blur();
 var i=rq.responseText.lastIndexOf("<!-- chunk -->");
 if(i>rqoffset) // have a chunk
 {
  if(rqoffset==0) removeid("prompt"); // 1st chunk contains input line so must remove original
  rqchunk= rq.responseText.substr(rqoffset,i-rqoffset);
  
  //var a= jssplit(rqchunk);
  //alert("chunk");
  //alert(a[0]);
  //alert(a[1]);
  
  
  rqoffset= i+14; // skip <!-- chunk -->
  var n= document.createElement("div");
  removeid("chunk");
  n.innerHTML= jjsremove(rqchunk)+'<div id="chunk"></div>';
  jbyid("log").appendChild(n);
  jseval(true,rqchunk);
  setTimeout(scrollchunk,1);
 } 
}

function ev_2_shortcut(){scrollz();}

function newpline(t)
{
 t= t.replace(/&/g,"&amp;");
 t= t.replace(/</g,"&lt;");
 t= t.replace(/>/g,"&gt;");
 t= t.replace(/ /g,"&nbsp;");
 t= t.replace(/-/g,"&#45;");
 t= t.replace(/\"/g,"&quot;");
 updatelog(phead+t+ptail);
}

// function keyp(){jbyid("kbsp").style.display= "block";scrollz();return true;} // space for screen kb

function ev_up_click(){uarrow();}
function ev_dn_click(){darrow();}

// log enter - contenteditable
// run or recall line with caret
// ignore multiple-line selection for now
function ev_log_enter()
{
 var t,sel,rng,tst,n,i,j,k,p,q,recall=0,name;
 if(window.getSelection)
 {
  sel= window.getSelection();
  rng= sel.getRangeAt(0);
  if(0!=rng.toString().length)return;
  jdominit(jbyid("log"));
  q=rng.commonAncestorContainer;

  for(i=0;i<jdwn.length;++i) // find selection in dom
   if(q==jdwn[i])break;

  for(j=i;j>=0;--j)   // backup find start DIV/P/BR
  {name=jdwn[j].nodeName;if(name=="DIV"||name=="BR"||name=="P")break;}

  for(k=i+1;k<jdwn.length;++k) // forward to find end DIV/P/BR or end
  {name=jdwn[k].nodeName;if(name=="DIV"||name=="BR"||name=="P")break;}

  rng.setStart(jdwn[j],0);
  recall=!(k==jdwn.length||k==jdwn.length-1);
  if(!k==jdwn.length)
    rng.setEnd(jdwn[k],0);
  else
    rng.setEndAfter(jdwn[k-1],0)
  t= rng.toString();
  t= t.replace(/\u00A0/g," "); // &nbsp;
  t= t.replace(/\u200B/g,"");  // &ZeroWidthSpace;
 }
 else
 {
  p= jbyid("prompt");
  rng= document.selection.createRange();
  t= rng.text;
  if(0!=t.length) return; // IE selection has LF, but ignore for now
  // IE -  move left until CR or NaN - move right til no change
  while(1)
  {
    rng.moveStart('character',-1);
    t= rng.text;
    if(t.charAt(0)=='\r'||isNaN(t.charCodeAt(0))){rng.moveStart('character',1); break;}
  }
  while(1)
  {
    n= rng.text.length; // no size change for CRLF
    rng.moveEnd('character',1);
    if(n==rng.text.length){rng.moveEnd('character',-1); break;}
  }
  t= rng.text;
  if(null!=p)// last line exec vs old line recall
  {
   tst= document.selection.createRange();
   tst.moveToElementText(jbyid("prompt"));
   tst.collapse(true);
   recall= -1!=tst.compareEndPoints("EndToEnd",rng);
  }
 }
 if(recall)
 {
  t= t.replace(/ /g,"\u00A0"); // space -> &nbsp;
  newpline(t);
 }
 else
 {
  adrecall("document",t,"-1");
  globalajax= t;
  setTimeout(TOajax,TOT);
 }
}

// firefox can't do ajax call withint event handler (default action runs)
function TOajax(){jdoajax([],"",globalajax,true);}

function document_recall(v){newpline(v);}

function ev_advance_click(){jdoajax([]);}

function ev_uarrow_click(){uarrow();}
function ev_darrow_click(){darrow();}

function ev_demo_click(){jdoajax([]);}
function ev_j1_click(){jdoajax([]);}
function ev_j2_click(){jdoajax([]);}
function ev_j3_click(){jdoajax([]);}
function ev_plot_click(){jdoajax([]);}
function ev_overview_click(){jdoajax([]);}
function ev_canvas_click(){jdoajax([]);}
function ev_guest_click(){jdoajax([]);}
function ev_charttour_click(){jdoj('');}
function ev_spx_click(){jdoajax([]);}
function ev_tool_click(){jdoajax([]);}
function ev_sp_click(){jdoajax([]);}
function ev_spx_click(){jdoajax([]);}
function ev_labs_click(){jdoajax([]);}
function ev_about_click(){jdoajax([]);}
function ev_wiki_click(){jdoajax([]);}

function ev_welcome_click(){jdoajax([]);}
function ev_shortcuts_click(){jdoajax([]);}
function ev_popups_click(){jdoajax([]);}
function ev_closing_click(){jdoajax([]);}

function ev_clearwindow_click(){jbyid("log").innerHTML= "";newpline("   ");}
function ev_clearrefresh_click(){jdoajax([]);}
function ev_clearLS_click(){localStorage.clear();};

function linkclick(a){pageopen(a,a);return false;} // open new tab or old - cache

function ev_jfile_click(){linkclick("jfile");}
function ev_jfiles_click(){linkclick("jfiles");}
function ev_jfif_click(){linkclick("jfif");}
function ev_jpacman_click(){linkclick("jpacman");}
function ev_jijx_click(){linkclick("jijx");}
var jijsnum=0;
function ev_jijs_click(){linkclick("jijs?"+jijsnum);jijsnum+=1;} 
function ev_framework_click(){linkclick("jdoc");}

function ev_f_shortcut(){ev_jfile_click();}
function ev_k_shortcut(){ev_jfiles_click();}
function ev_F_shortcut(){ev_jfif_click();}
function ev_J_shortcut(){ev_jijs_click();}

function ev_9_shortcut(){jlogwindow= pageopen('jijs?jwid=~temp/jlog.ijs','jijs?'+encodeURIComponent('jwid=~temp/jlog.ijs'));}

function ev_8_shortcut(){
 jlog('\nesc-8 '+allwins.length);
 allwins.forEach(function (el){
  try{t= el.name;}catch(e){t= 'error'};
  jlog(el.closed?'closed':t)
});
}

function ev_jdebug_click(){wjdebug= pageopen('jdebug','jdebug');return false;;}

function ev_jbreak_click()
{
 if(0==rqstate) return; // do not break if not busy
 if("http:"==window.location.protocol)
 {
  updatelog("<b>jbreak not supported - use ctrl+c in server terminal window</b>")
  newpline("");
  return;
 }
 let rq= newrq();
 rq.open("POST",jform.jlocale.value,0); // synch call
 rq.send("jbreak?");
}

function ev_jlogoff_click()
{
 let rq= newrq();
 rq.open("POST",jform.jlocale.value,0); // synch call
 rq.send("jlogoff?");
 window.location= "jlogoff";
}

function ev_helphelp_click(){urlopen("https://www.jsoftware.com/help/index.htm")};
function ev_helpwikinuvoc_click(){urlopen("https://code.jsoftware.com/wiki/NuVoc")};
function ev_helpwikiancillary_click(){urlopen("https://code.jsoftware.com/wiki/NuVoc#bottomrefs")};
function ev_helpwikirelnotes_click(){urlopen("https://code.jsoftware.com/wiki/System/ReleaseNotes")};
function ev_helpwikiconstant_click(){urlopen("https://code.jsoftware.com/wiki/Vocabulary/Constants")};
function ev_helpwikicontrol_click(){urlopen("https://code.jsoftware.com/wiki/Vocabulary/ControlStructures")};
function ev_helpwikiforeign_click(){urlopen("https://code.jsoftware.com/wiki/Vocabulary/Foreigns")};
function ev_helpwikijhs_click(){urlopen("https://code.jsoftware.com/wiki/Guides/JHS")};
function ev_helpwikistdlib_click(){urlopen("https://code.jsoftware.com/wiki/Standard_Library/Overview")};

function ev_comma_ctrl(){jdoajax([]);}
function ev_dot_ctrl(){jdoajax([]);}
function ev_slash_ctrl(){jdoajax([]);}
function ev_less_ctrl(){jdoajax([]);}
function ev_larger_ctrl(){jdoajax([]);}
function ev_query_ctrl(){jdoajax([]);}
function ev_semicolon_ctrl(){jdoajax([]);}
function ev_quote_ctrl(){jdoajax([]);}
function ev_colon_ctrl(){jdoajax([]);}
function ev_doublequote_ctrl(){jdoajax([]);}

function ev_return_click(){ev_log_enter();}

function ev_close_click(){
 if(qrules==2 && !confirm("Press OK to close.")){return;};
 allwins_clean();
 for(let i = 0; i < allwins.length; i++) {allwins[i].jscdo("close");}
 allwins_clean();
 jdoajax([]);
}

function ev_close_click_ajax(ts){ 
 updatelog(ts);
 // kill all page events
 document.addEventListener("click", deadhandler, true);
 document.addEventListener("keyup", deadhandler, true);
 document.addEventListener("keypress", deadhandler, true);
 document.addEventListener("keydown", deadhandler, true);
} 

function deadhandler(e) {
  e.stopPropagation();
  e.preventDefault();
  scrollz();
}

// allwins stuff

function allwins_clean(){allwins= allwins.filter(el => !el.closed)} // remove closed

// return allwins window object for wid or null
function getwindow(wid){
 allwins_clean()
 for(let i = 0; i < allwins.length; i++) {
  w= allwins[i]
  if(wid==w.name) return w;
 }
 return null; 
}

// jijx swipe detect
function swipedetect(el, callback){
  
    var touchsurface = el,
    swipedir,
    startX,
    startY,
    distX,
    distY,
    threshold = 150, //required min distance traveled to be considered swipe
    restraint = 100, // maximum distance allowed at the same time in perpendicular direction
    allowedTime = 300, // maximum time allowed to travel that distance
    elapsedTime,
    startTime,
    handleswipe = callback || function(swipedir){}
  
    touchsurface.addEventListener('touchstart', function(e){
        var touchobj = e.changedTouches[0]
        swipedir = 'none'
        dist = 0
        startX = touchobj.pageX
        startY = touchobj.pageY
        startTime = new Date().getTime() // record time when finger first makes contact with surface
        e.preventDefault()
    }, false)
  
    touchsurface.addEventListener('touchmove', function(e){
        e.preventDefault() // prevent scrolling when inside DIV
    }, false)
  
    touchsurface.addEventListener('touchend', function(e){
        var touchobj = e.changedTouches[0]
        distX = touchobj.pageX - startX // get horizontal dist traveled by finger while in contact with surface
        distY = touchobj.pageY - startY // get vertical dist traveled by finger while in contact with surface
        elapsedTime = new Date().getTime() - startTime // get time elapsed
        if (elapsedTime <= allowedTime){ // first condition for awipe met
            if (Math.abs(distX) >= threshold && Math.abs(distY) <= restraint){ // 2nd condition for horizontal swipe met
                swipedir = (distX < 0)? 'left' : 'right' // if dist traveled is negative, it indicates left swipe
            }
            else if (Math.abs(distY) >= threshold && Math.abs(distX) <= restraint){ // 2nd condition for vertical swipe met
                swipedir = (distY < 0)? 'up' : 'down' // if dist traveled is negative, it indicates up swipe
            }
        }
        handleswipe(swipedir)
        e.preventDefault()
    }, false)
}
  
//USAGE:
/*
var el = document.getElementById('someel')
swipedetect(el, function(swipedir){
    swipedir contains either "none", "left", "right", "top", or "down"
    if (swipedir =='left')
        alert('You just swiped left!')
})
*/

)
