NB. J HTTP Server - jijx app
coclass'jijx'
coinsert'jhs'

HBS=: 0 : 0
jhmenu''

'menu0'  jhmenugroup ''
'jfile'  jhmenuitem  'file';'f'
'jijs'   jhmenuitem  'jijs';'n'
'jpacman'jhmenuitem 'jpacman'
'jdebug' jhmenuitem 'jdebug'
'jbreak' jhmenuitem 'break';'c'
         jhmenulink 'entry';'entry'
         jhmenulink 'view';'view'
         jhmenulink 'help';'help'
         jhhr
 NB.        jhmenuitem '' NB. </hr>
'close'  jhmenuitem 'quit';'q'
jhmenugroupz''

'entry'    jhmenugroup''
'recall'   jhmenuitem'recall'
'tool'         jhmenuitem'tool'
'demo'         jhmenuitem'demo'
'tour'         jhmenuitem'tour (JHS tutorial)'
'lab'          jhmenuitem'lab (tutorial)'
'app'          jhmenuitem'app (build gui app)'
'wiki'         jhmenuitem'wiki';'p'
jhmenugroupz''

'view'         jhmenugroup''
'cleartemps'   jhmenuitem 'remove red boxes';'s'
'wrap'         jhmenuitem 'wrap/unwrap'
'clearwindow'  jhmenuitem 'clear window'
'clearrefresh' jhmenuitem 'clear refresh'
'clearLS'      jhmenuitem 'clear LS'
jhmenugroupz''

'help' jhmenugroup''
'welcome'            jhmenuitem 'welcome'
'guest_rules'        jhmenuitem 'guest rules'
'guest_files'        jhmenuitem 'guest files'
 'mobile'            jhmenuitem 'mobile'
 'wiki'              jhmenuitem 'wiki';'p'
 'shortcuts'         jhmenuitem 'shortcuts' 
 'popups'            jhmenuitem 'pop-ups'
 'closing'           jhmenuitem 'close'
 'framework'         jhmenuitem 'framework'
 'about'             jhmenuitem 'about' 
jhmenugroupz''

NB. touch screen button on right side
'uarrow' jhb '';'jhtouch'
'darrow' jhb '';'jhtouch'
'advance'jhb '';'jhtouch'

'log' jhec'<LOG>'
'ijs' jhhidden'<IJS>'
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
'jterm' jhr 'LOG';LOG
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

NB. localhost    - QRULES 0 - close tabs, disable page, exit
NB. server user  - QRULES 1 - close tabs, disable page, no exit
NB. server guest - QRULES 2 - confirm - OK close tabs, start new guest session page, exit

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

CSS=: 0 : 0 
*{font-family:<PC_FONTFIXED>;font-weight:550;}
form{margin-top:0;margin-bottom:0;}
*.fm   {color:<PC_FM_COLOR>;}
*.er   {color:<PC_ER_COLOR>;}
*.log  {color:<PC_LOG_COLOR>;}
*.sys  {color:<PC_SYS_COLOR>;}
*.file {color:<PC_FILE_COLOR>;}

.jhb#overview{background-color:<PC_JICON>;font-weight:bold;font-size:2rem;padding:0.2rem;}
#prompt{background-color:blanchedalmond;border:2px solid black;padding:8px 0 8px 0;}

/* right side buttons */
.jhtouch{background-color:rgba(255,255,255,0);position:fixed;right:0;margin:0px;border-radius:0;
 width:4rem;height:3rem;border-width:0 0.5rem 0 0;}

.jhtouch#advance{border-color:darkseagreen;}
.jhtouch#uarrow {border-color:blue;}
.jhtouch#darrow {border-color:red;}

/* all except mobile - assume no kb movement */
.jhtouch#advance{bottom:13rem;}
.jhtouch#uarrow {bottom:10rem;}
.jhtouch#darrow {bottom:7rem;}


/* tablet */
@media screen and (max-device-width: 992px){
.jhtouch#advance{bottom:26rem;}
.jhtouch#uarrow {bottom:23rem;}
.jhtouch#darrow {bottom:20rem;}
}

/* phone */
@media screen and (max-device-width: 640px){
#prompt{padding:36px 0 36px 0;}
.jhtouch#advance{bottom:14rem;}
.jhtouch#uarrow {bottom:11rem;}
.jhtouch#darrow {bottom: 8rem;}
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
var wjdebug= null; // jdebug window object

function ev_body_focus(){setTimeout(ev_2_shortcut,TOT);}

function ev_body_load()
{
 // if(window.visualViewport) window.visualViewport.onresize = onvpresize;
 jijxwindow= window;
 window.name= "jijx";
 jseval(false,jbyid("log").innerHTML); // redraw canvas elements
 newpline("   ");
 jresize();

 if(!touch){
  jbyid('uarrow').style.display="none";
  jbyid('darrow').style.display="none";
  jbyid('advance').style.display="none";
 }

 //! var el = document.getElementById('log')
 //! swipedetect(el, function(swipedir){if (swipedir =='left')alert('You just swiped left!')})
}

/* iX devices only - no longer used!
function onvpresize(){
   VKB= (VKB==0)?window.innerHeight-window.visualViewport.height : 0;
   jresize();
   // scrollz/scrollintoview is required -scrollz without setcaret
   //setfocus(); // required by ff
   if(null==jbyid("prompt"))return;
   jbyid("prompt").scrollIntoView(false);
}
*/

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

//! iX - replaced by onvpresize - eventually kill off setting handlers for ecfocus/ecblur
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
 setTimeout(scrollz,TOT); // bigger value does not help iphone scrollintoview
}

function scrollz()
{
 setfocus(); // required by ff


 if(iphone())
 {
  // iphone small scrollintoview does not work
  // it does work if we scroll all the way up and then down
  // but that looks terrible
  //jbyid("log").scrollTo(100000,0);
  //scdn();
  
  //updatelog("<div id='fubar'>how now</div>");
  //var n= document.createElement("div");
  //n.setAttribute("id", "fubar");
  //n.innerHTML= "how now";
  //jbyid("log").appendChild(n);

  //jbyid("fubar").scrollIntoView({behavior:"instant",block:"end"});
  scdn();
 }
 else
  scdn();

 if(null==jbyid("prompt"))return;
 jsetcaret("prompt",1);
}

function scup(){jbyid("log").scrollIntoView(true);}
//function scdn(){jbyid("log").scrollIntoView(false);}
function scdn(){jbyid("log").scrollIntoView({behavior:"instant",block:"end"});}

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

function newpline(t){updatelog(phead+jhfroma(t)+ptail);}

function newinput(t){e= jbyid("prompt");if(e==null) return; e.innerHTML= jhfroma(t); jsetcaret("prompt",1);}

function runinput(t){
 e= jbyid("prompt");
 if(e==null) return;
 globalajax= t;
 setTimeout(TOajax,TOT);
}

function colorinput(t){
 e= jbyid("prompt");
 if(e==null) return;
 e.style.color=t;
}

/*
function newpline(t){
 if(jbyid("prompt")==null)
  updatelog(phead+jhfroma(t)+ptail);
 else 
  jbyid("prompt").innerHTML= phead+jhfroma(t)+ptail;
}
*/

// function keyp(){jbyid("kbsp").style.display= "block";scrollz();return true;} // space for screen kb

function ev_advance_click(){jdoajax([]);}
function ev_return_click(){ev_log_enter();}
function ev_uarrow_click(){uarrow();}
function ev_darrow_click(){darrow();}

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
 
  // removeElementsByClass('transient');

 }
}

// firefox can't do ajax call withint event handler (default action runs)
function TOajax(){jdoajax([],"",globalajax,true);}

/* function document_recall(v){newpline(v);} */

function document_recall(v){jbyid("prompt").innerHTML= jhfroma(v); jsetcaret("prompt",1);}

function ev_demo_click(){jdoajax([]);}
function ev_lab_click(){jdoajax([]);}
function ev_tour_click(){jdoajax([]);}
function ev_j1_click(){jdoajax([]);}
function ev_j2_click(){jdoajax([]);}
function ev_j3_click(){jdoajax([]);}
function ev_plot_click(){jdoajax([]);}
function ev_overview_click(){jdoajax([]);}
function ev_canvas_click(){jdoajax([]);}
function ev_guest_rules_click(){jdoajax([]);}
function ev_guest_files_click(){jdoajax([]);}
function ev_charttour_click(){jdoj('');}
function ev_spx_click(){jdoajax([]);}
function ev_tool_click(){jdoajax([]);}
function ev_app_click(){jdoajax([]);}
function ev_sp_click(){jdoajax([]);}
function ev_spx_click(){jdoajax([]);}
function ev_labs_click(){jdoajax([]);}
function ev_about_click(){jdoajax([]);}
function ev_wiki_click(){jdoajax([]);}
function ev_recall_click(){recent(10);jdoajax([]);}

function ev_welcome_click(){jdoajax([]);}
function ev_mobile_click(){jdoajax([]);}
function ev_shortcuts_click(){jdoajax([]);}
function ev_popups_click(){jdoajax([]);}
function ev_closing_click(){jdoajax([]);}

function ev_wrap_click(){
 t= jbyid('log');
 b= 'normal'==getComputedStyle(t)['overflowWrap'];
 t.style.overflowWrap= b?'break-word':'normal';
 t.style.whiteSpace=   b?'normal'    :'nowrap';
};

function ev_cleartemps_click(){removeElementsByClass('transient');}
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

function ev_c_shortcut(){jscdo('jbreak');}
function ev_f_shortcut(){ev_jfile_click();}
function ev_p_shortcut(){jscdo('wiki');}
function ev_n_shortcut(){ev_jijs_click();}

function ev_s_shortcut(){ev_cleartemps_click();}

function ev_2_shortcut(){scrollz();}

function ev_8_shortcut(){
 jlog('\nesc-8 '+allwins.length);
 allwins.forEach(function (el){
  try{t= el.name;}catch(e){t= 'error'};
  jlog(el.closed?'closed':t)
});
}

function ev_9_shortcut(){jlogwindow= pageopen('jijs?jwid=~temp/jlog.ijs','jijs?'+encodeURIComponent('jwid=~temp/jlog.ijs'));}

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

function ev_close_click(){
 // if(qrules==2 && !confirm("Press OK to close.")){return;};
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

// put n recent enters in log
function recent(n){
 d= getls("document");
 d= d.split('\n');
 r= '';
 c= Math.min(n,d.length)-1;
 for(let i=c; i>=0; i--){
  r= r+jhfroma(d[i])+"<br>";
 }

 //'<div class="transient">',(jhtmlfroma  y),'</div>'
 updatelog('<div class="transient">'+r+'</div>');
 newpline("");
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
