var SPA= true;
var allpages= []; // windows for all spa pages (jijx and all frame windows)
var allwins= [];   // all windows created by jijx (some may have been closed)
var phead= '<div id="prompt" class="log" onpaste="mypaste(event)">';
var ptail= '</div>';
var globalajax; // sentence for enter setTimeout ajax
var TOT= 1;     // timeout time to let DOM settle before change
var wjdebug= null; // jdebug window object

function ev_body_focus(){setTimeout(scrollz,TOT);}

function ev_body_load()
{
 // if(window.visualViewport) window.visualViewport.onresize = onvpresize;
 allpages[0]= window; // jijx is first spa page
 jijxwindow= window;
 window.name= "jijx";
 jseval(false,jbyid("log").innerHTML); // redraw canvas elements
 newpline("   ");
 
 if(!touch){
  jbyid('uarrow').style.display="none";
  jbyid('darrow').style.display="none";
  jbyid('advance').style.display="none";
 }

// var el = jbyid('log');
//swipedetect(el, function(d){if (d=='left')alert('swiped left!')})
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

// warn user about unload if term has dependent pages
function isdirty(){
  return (0!=allwins.length) || (1!=allpages.length);
}

function setfocus(){jbyid("log").focus();}

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

// update log with new prompt
function updatelogp(t){updatelog(t+phead+jhfroma("   ")+ptail);}

//! var lastupdate; //! jijs capture error

function updatelog(t)
{
 //! lastupdate= t; 
 var n= document.createElement("div");
 n.innerHTML= jjsremove(t);
 removeid("prompt");
 jbyid("log").appendChild(n);
 setTimeout(scrollz,TOT); // bigger value does not help iphone scrollintoview
}

function addlog(t){
  var n= document.createElement("div");
  n.innerHTML= t;
  jbyid("log").appendChild(n);
} 

function scrollz()
{
 setfocus(); // required by ff
 var e= jbyid("log");
 e.scrollTop= e.scrollHeight - e.clientHeight;
 if(null==jbyid("prompt"))return;
 jsetcaret("prompt",1);
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
  if(null!=jbyid('inputs')) jbyid('inputs').remove();
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
 jbyid('wrap').innerHTML= b?'NOWRAP ➜ wrap':'WRAP ➜ nowrap';
};

function removeelement(id){var e= jbyid(id); if(e==null) return; e.remove();}

function ev_cleartemps_click(){removeElementsByClass('transient');}
function ev_clearwindow_click(){jbyid("log").innerHTML= "";newpline("   ");}
function ev_clearrefresh_click(){jdoajax([]);}
function ev_clearLS_click(){localStorage.clear();};

function linkclick(a){pageopen(a,a);return false;} // open new tab or old - cache

function ev_jlocale_click(){linkclick("jlocale");}
function ev_jfile_click()  {linkclick("jfile");}
function ev_jpacman_click(){linkclick("jpacman");}
function ev_jfif_click()   {linkclick("jfif");}
function ev_jcopy_click()  {linkclick("jcopy");}

var jijsnum=0;
function ev_jijs_click(){linkclick("jijs?"+jijsnum);jijsnum+=1;} 
function ev_framework_click(){linkclick("jdoc");}

function ev_c_shortcut(){jscdo('jbreak');}
function ev_e_shortcut(){ev_jfile_click();}
function ev_f_shortcut(){ev_jfif_click();}
function ev_l_shortcut(){ev_jlocale_click();}

function ev_p_shortcut(){jscdo('helplinks');}
function ev_n_shortcut(){ev_jijs_click();}

function ev_s_shortcut(){ev_cleartemps_click();}

function ev_z_shortcut(){ev_exit_click();};

//function ev_2_shortcut(){scrollz();}

function ev_8_shortcut(){
 jlog('\nesc-8 '+allwins.length);
 allwins.forEach(function (el){
   try{t= el.name;}catch(e){t= 'error'};
   jlog(el.closed?'closed':t)
 });
 allpages.forEach(function (w){
  jlog(w.id+' '+w.class);
 });
}

function ev_d_shortcut(){recent();}
function ev_jinputs_click(){ev_d_shortcut();}

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

// esc-z - close all pages, exit server, close term
function ev_exit_click(){
 closepages();
 jform.jmid.value= 'exit';
 jform.jtype.value= 'click';
 jdoajax([]);
}

// window.close fails in guest/server - perhaps because it starts differently
function ev_exit_click_ajax(t){
  if(0!=t.length) window.location= "juser";
  window.close();
}

// close all pages opened by this term window
// this includes pages in jijx frames
function closepages(){
  for(let i = 1; i < allpages.length; i++) { // do not call for jijx page
    allpages[i].jscdo('close'); 
  };
  allpages= []; allpages[0]= window;

  allwins_clean();
  for(let i = 0; i < allwins.length; i++) {
    // jdemo09 iframes does not have jscdo
    try{allwins[i].jscdo("close");}catch(e){allwins[i].close();};
  }
  allwins_clean();
}

// esc-q - does nothing - refer to quit menu
function ev_close_click(){alert('see menu item quit for options');}

function ev_closepages_click(){closepages();}

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

// put recent enters in log
function recent(){
 d= getls("document");
 d= d.split('\n');
 r= '';
 c= d.length-1;
 for(let i=c; i>=0; i--){
  r= r+jhfroma(d[i])+"<br>";
 }
 if(null!=jbyid('inputs')) jbyid('inputs').remove();
 var p= phead+jhfroma("   ")+ptail;
 updatelogp('<div id="inputs" class="transient">'+r+'</div>'); // include prompt
}

// unfortunately the preventdefault changes a click into a swipe - making swipes useless on live page
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

 // used by plot etc to show files
 // uqs used to get new file values
 // sets new location in existing window or opens new window
 function pageshow(url,wid,specs){
  wid= decodeURIComponent(wid);
  w= jijxwindow.getwindow(wid);
  if(null!=w) w.location= url; else pageopen(url,wid,specs);
 }
 
// spa functions

function ev_jmtoggle_click(){
  SPA= !SPA;
  jbyid('jmtoggle').innerHTML= SPA?'TERM ➜ tab':'TAB ➜ term';
}

// new frame for new url - or show existing frame with same url
function newpage(myid,myclass,url){
  var i;
  for (i= 1; i<allpages.length; i++) { // find page with same url - skip term 
    if(myid==allpages[i].frameElement.id){ // open existing frame
      hideallpages();
      showpage(allpages[i]);
      return;
    }
  }

  var ifr= document.createElement("iframe");
  ifr.id= myid;
  ifr.class= myclass;
  jbyid("log").parentNode.appendChild(ifr);
  hideallpages(); // brute force to hide current
  jbyid(myid).contentWindow.location= url;
  allpages.push(ifr.contentWindow);
  jtermwcurrent= ifr.contentWindow;

  ifr.focus();
  // ifr.contentWindow.document.title not available until load is done
  // url could be cleaned up for title so it is the same as eventual frame title
  document.title= 'term '+url.split('?')[0]; //! TIPX
}
1
// ->term
function termpage(){
    jbyid("log").style.display= "block";
    jbyid("menuburger").style.display= "";
    jbyid("log").focus();
} 

var jtermwprevious= null;
var jtermwcurrent= null;

function hidepage(w){
  var w= (null==jtermwcurrent)?allpages[0]:jtermwcurrent;
  jtermwprevious= w;
  if(!isFrame(w)){
    jbyid("log").style.display= "none";
    jbyid("menuburger").style.display="none";
  }else{
    ifr= w.frameElement;
    ifr.style.display="none";
    w.jbyid("menuburger").style.display="none";
  }
}

function hideallpages(){
  for (i= 0; i<allpages.length; i++) {hidepage(allpages[i]);} 
}

function showpage(w){
  jtermwcurrent= w;
  if(!isFrame(w)){
    jbyid("log").style.display= "block";
    jbyid("menuburger").style.display="";
    jbyid("log").focus();
    document.title= 'term';
  }else{
    ifr= w.frameElement;
    ifr.style.display="block";
    w.jbyid("menuburger").style.display="";
    ifr.focus();
    w.parent.document.title= 'term '+w.document.title; //! TIPX
  }
}

function termtab(w){
  if(jtermwcurrent==allpages[0]) return; 
  jtermwprevious= jtermwcurrent;
  hidepage(jtermwcurrent);
  showpage(allpages[0]);
}
  
// page alternate - w is window for current page
// switch between last 2 pages
function pagealt(w){
  var x= jtermwprevious; //! might not be valid
  x= (x==null)?allpages[0]:x;
  jtermwprevious= jtermwcurrent;
  hidepage(jtermwcurrent);
  showpage(x);
} 

// page titles to populate live menu
function pagenames(){
  var i,r= [];
  for (i= 0; i<allpages.length; i++) { // find next page
    r.push(decodeURIComponent(allpages[i].document.title));
  }
  return r;
}

// current-window,new-index
function pageswitch(w,n){
  hidepage(jtermwcurrent);
  showpage(allpages[n]);
}
 
// spa run in jijxwindow
function spaclose(w){
      var i= allpages.indexOf(w);
      if(i!=-1){
        var id= w.frameElement.id;
        jbyid(id).parentNode.removeChild(jbyid(id)); // remove page
        allpages.splice(i, 1);
        jtermwprevious= allpages[0];
        showpage(allpages[0]);
      }
      else w.close();
}
  
