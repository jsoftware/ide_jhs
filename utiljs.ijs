NB. core javascript utilities for all pages
coclass'jhs'
NB.! core.js file should be read by src=
NB. this would use cache and make page loads faster
NB. doing it this way is easier for debugging (not cached)
JSCORE=: 0 : 0
// global constants
var JASEP= '\1'; // delimit substrings in ajax response

// globals onload
var jform,jevsentence;

// event globals
var JEV; // handler to call
var jevev;

// utils
function jisChrome() {return -1!=navigator.userAgent.search(/Chrome/);}
function jisFirefox(){return -1!=navigator.userAgent.search(/Firefox/);}
function jisIE()     {return -1!=navigator.userAgent.search(/MSIE/);}
function jisSafari() {return -1!=navigator.userAgent.search(/Safari/)&&-1==navigator.userAgent.search(/Chrome/);}
function jisIE8()    {return -1!=navigator.userAgent.search(/MSIE 8/);}

function jbyid(id){return document.getElementById(id);}
function jkeycode(ev){return(window.event||ev).keyCode;}

// body onload handler - calls page evload
function jevload()
{
 jform= document.j;
 jevsentence= "jev_"+jform.jlocale.value+"_ 0"; 
 try{eval("evload")}catch(ex){return false;}
 evload();
 return false
}

// event handler for id type - id is mid[*sid]
function jev(id,type,event){
 menuhide(); // hide menu dropdown
 jevev= window.event||event;
 var i= id.indexOf('*');
 jform.jid.value  = id;
 jform.jtype.value= type;
 jform.jmid.value = (-1==i)?id:id.substring(0,i);
 jform.jsid.value = (-1==i)?"":id.substring(++i,id.length);
 if(type=='enter'&&13!=jevev.keyCode) return true;
 if(type=='menuclick') return menuclick();
 return jevdo(id);
}

function jevdo()
{
 JEV= "ev_"+jform.jmid.value+"_"+jform.jtype.value;
 // if js handler not defined, call j handler with jsubmit
 try{eval(JEV)}catch(ex){jsubmit();return false;}
 try{var r= eval(JEV+"();")}
 catch(ex){alert(JEV+" failed: "+ex);return false;}
 if('undefined'!=typeof r) return r;
 //! var t= jbyid(id).type;
 //! if(t=='submit') return false;
 return false;
}

// handle keyboard shortcut
function jscdo(n)
{
 jform.jtype.value= "click";
 jform.jid.value= n;
 jform.jmid.value= n;
 jform.jsid.value= "";
 jevdo();
}

// ajax
var rq,rqstate=0;

// xmlhttprequest not supported in kongueror 3.2.1 (c) 2003
function newrq()
{
 try{return new XMLHttpRequest();} catch(e){}
 try{return new ActiveXObject("Msxml2.XMLHTTP.6.0");} catch(e){}
 try{return new ActiveXObject("Msxml2.XMLHTTP.3.0");} catch(e){}
 try{return new ActiveXObject("Msxml2.XMLHTTP");} catch(e){}
 alert("XMLHttpRequest not supported.");
}

/*
ajax is called with ajax response split on JASEP
jmid can be used to distinguish between ajax callers
convention has first split string as text for report
*/
function jdoresult()
{
 rqstate= rq.readyState;
 if(rqstate==4)
 {
  if(200!=rq.status)
   alert("ajax request failed - see jijx");
  else
   if('function'==typeof ajax)
    ajax(rq.responseText.split(JASEP));
  else
    alert("ajax function not defined");
  rqstate= 0;
  busy= 0;
 }
}

// ajax request - ids is array of extra form elements (names) for post
function jdo(sentence,log,ids)
{
 if(0!=rqstate){alert("busy - wait for previous request to finish");return;}
 rq= newrq();
 rq.onreadystatechange= jdoresult;
 rq.open("POST",jform.jlocale.value,true); // asynch
 jform.jdo.value= sentence;
 jform.jajax.value= true;
 rq.send(getpostargs(ids));
}

// ajax request - ids is array of form elements (names) for post
function jdoh(ids){jdo(jevsentence,false,ids);}

// submit form with jevsentence
function jsubmit(s){jform.jdo.value=jevsentence;jform.submit();}

// return post arguments from stanard form ids and extra form ids (names)
function getpostargs(ids)
{
 var d,t="",s="",a=["jdo","jajax","jtype","jmid","jsid"].concat(ids);
 for(var i=0;i<a.length;++i)
 {
  d= eval("jform."+a[i]+".value");
  t+= s+a[i]+"="+(encodeURIComponent(d)).replace("/%20/g","+");
  s= "&";
 }
 return t;
}

// app keyboard shortcuts

document.onkeyup= kup;
document.onkeypress= kpress;

var jsc= 0, jsctoid= 0;

// set shortcut state/timeout
function jscset(){jscreset();jsctoid= setTimeout(jscreset,1000);jsc= 1;}

// reset shortcut state/timeout
function jscreset(){if(0!=jsctoid)clearTimeout(jsctoid);jsctoid=0;jsc=0;}

// page redefines to avoid std shortcuts
// '2' shortcut implemented as ev_2_shortcut for each page
function jdostdsc(c)
{
 switch(c)
 {
  case '1': jactivatemenu('1'); break;
  case 'j': location="jijx";  break;
  case 'l': location="jfile"; break;
  case 'h': location="jhelp"; break;
  case 'n': location="jijs"; break;
 }
}

function kpress(ev)
{
 var e=window.event||ev;
 var c=e.charCode||e.keyCode;
 var s= String.fromCharCode(c);
 if(!jsc) return true;
 jscreset();
 try{eval("ev_"+s+"_shortcut()");}
 catch(e){jdostdsc(s);}
 return false;
}

function kup(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 if(c==17)jscset();
 if(e.ctrlKey)
 {
  if(c==190&&!e.shiftKey){jshortcut= 1; return false;}
  if(c==38&&e.shiftKey&&'function'==typeof uarrow){uarrow();return false;} // noarrows
  if(c==40&&e.shiftKey&&'function'==typeof darrow){darrow();return false;}
 }
 return true;
}

// return menu group node n
function jfindmenu(n)
{
 var nodes= document.getElementsByTagName("a");
 var i,node,cnt=0,last,len= nodes.length;
 for(i=0;i<len;++i)
 {
  node= nodes[i];
  if("hmg"!=node.getAttribute("class")) continue;
  if(n==++cnt) return node;
  last= node;
 }
 return last;
}

// activate menu group n
function jactivatemenu(n)
{
 menuhide();
 window.scrollTo(0,0);
 var node= jfindmenu(n);
 if('undefined'==typeof node) return;
 node.focus(); 
 jform.jmid.value= node.id;
}

// menu
var menublock= null; // menu ul element with display:block
var menulast= null;  // menu ul element just hidden 

function menuclick()
{
 var id= jform.jmid.value;
 var idul= id+"_ul";
 jbyid(id).focus(); // required on mac
 if(jbyid(idul).style.display=="block")
 {
  menublock= null;
  jbyid(idul).style.display= "none";
 }
 else
 {
  if(menulast!=jbyid(idul))
  {
   menublock= jbyid(idul);
   menublock.style.display= "block";
  }
 }
}

function menuhide()
{
 if(tmenuid!=0) clearTimeout(tmenuid);
 tmenuid= 0;
 menulast= menublock;
 if(menublock!=null) menublock.style.display= "none";
 menublock= null;
 return true;
}

// browser differences
//  safari/chrome onblur on mousedown and onfocus on mouseup
//  onblur will hide the menu 250 after mousedown (no clear)
//  so menu item click needs to be quick

var tmenuid= 0;

function menublur()
{
 if(tmenuid!=0) clearTimeout(tmenuid);
 tmenuid= setTimeout(menuhide,250)
 return true;
}

function menufocus(ev)
{
 if(tmenuid!=0) clearTimeout(tmenuid);
 tmenuid= 0;
 return true;
}

/*
function jmenukey(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 if(c==38){jbyid("tool").focus(); return false;}
 if(c==40){jbyid("studio").focus(); return false;}
 return true;
}
*/

// menu end

// set caret in element id - collapse 0 start, 1 end
function jsetcaret(id,collapse)
{
 var p= jbyid(id);
 if (window.getSelection)
 {
  try{window.getSelection().collapse(p,collapse);}
  catch(e){window.getSelection().collapse(p,false);} // try for ff - delete all
 }
 else
 {
  var tst= document.selection.createRange();
  tst.moveToElementText(p);
  tst.collapse(!collapse);
  tst.select();
 }
}

// text from html
// &lt; etc. to char
// <div> <br> <br/> (case insensitive) to LF
// all other tags removed
// assumes valid html with matching tags
//! not correct or complete - <p> and unmatched tags
function jtfromh(d)
{
 d= d.replace(/<div>/gi,"\n");
 d= d.replace(/<br>/gi,"\n");
 d= d.replace(/<br\/>/gi,"\n");
 d= d.replace(/<\/?[^>]+(>|$)/g, ""); // remove all remaining tags
 d= d.replace(/&lt;/g,"<");
 d= d.replace(/&gt;/g,">");
 d= d.replace(/&amp;/g,"&");
 d= d.replace(/&nbsp;/g," ");
 return d
}

// inverse jtfromh
function jhfromt(d)
{
 d= d.replace(/</g,"&lt;");
 d= d.replace(/>/g,"&gt;");
 d= d.replace(/&/g,"&amp;");
 d= d.replace(/ /g,"&nbsp;");
 d= d.replace(/\n/g,"<br/>");
 return d
}

function jshow(id){jbyid(id).style.display="block";}
function jhide(id){jbyid(id).style.display="none";}

// get pixel... - sizing/resizing

// window.onresize= resize; // required for resize
// and resize should be called in evload

// the ...h functions need simple changes to
// become the corresponding set of w functions

// body{background:aqua} can be useful in
// finding out why calculations turn out wrong

// IF and FF both have bugs with <h1>...</h1>
// vs these calculations and <hx> should not
// be used where resizing will be used

// get pixel window height
function jgpwindowh()
{
 if(window.innerHeight)
  return window.innerHeight; // not IE
 else
  return document.documentElement.clientHeight;
}

// get pixel body margin height (top+bottom)
function jgpbodymh()
{
 var h;
 if(window.getComputedStyle)
 {
  h=  parseInt(window.getComputedStyle(document.body,null).marginTop);
  h+= parseInt(window.getComputedStyle(document.body,null).marginBottom);
 }
 else
 {
  h=  parseInt(document.body.currentStyle.marginTop);
  h+= parseInt(document.body.currentStyle.marginBottom);
 }
 return h;
}

// get pixel div height - IE/FF bugs vs <h1>
function jgpdivh(id){return document.getElementById(id).offsetHeight;}

// get pixel end
)
