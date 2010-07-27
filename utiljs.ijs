NB. core javascript utilities for all pages
coclass'jhs'
NB.! core.js file should be read by src=
NB. this would use cache and make page loads faster
NB. doing it this way is easier for debugging (not cached)
JSCORE=: hjs 0 : 0
// global constants
var ASEP= '\1'; // delimit substrings in ajax response

// globals onload
var jform,jevsentence;

// event globals
var JEV; // handler to call
var jevev;

// utils
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
 if('enter'==type&&13!=jevev.keyCode) return true;
 JEV= "ev_"+jform.jmid.value+"_"+jform.jtype.value;
 // if js handler not defined, call j handler with jsubmit
 try{eval(JEV)}catch(ex){jsubmit();return false;}
 try{var r= eval(JEV+"();")}
 catch(ex){alert(JEV+" failed: "+ex);return false;}
 if('undefined'!=typeof r) return r;
 var t= jbyid(id).type;
 if(t=='submit') return false;
 return false;
}

// ajax
var rq,rqupdate,rqstate=0;

// xmlhttprequest not supported in kongueror 3.2.1 (c) 2003
function newrq()
{
 try{return new XMLHttpRequest();} catch(e){}
 try{return new ActiveXObject("Msxml2.XMLHTTP.6.0");} catch(e){}
 try{return new ActiveXObject("Msxml2.XMLHTTP.3.0");} catch(e){}
 try{return new ActiveXObject("Msxml2.XMLHTTP");} catch(e){}
 alert("XMLHttpRequest not supported.");
}

function jdoresult()
{
 rqstate= rq.readyState;
 if(rqstate==4)
 {
  if(200!=rq.status)
   alert("ajax request failed - see jijx");
  else
   rqupdate();
  rqstate= 0;
  busy= 0;
 }
}

// redefined by app
function rqupdate(){alert("app rqupdate function not defined.");}

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
var shortcut= 0;

function kpress(ev)
{
 if(!shortcut) return true;
 shortcut= 0;
 var e=window.event||ev;
 var c=e.charCode||e.keyCode; // ff vs ie
 try{doshortcut(String.fromCharCode(c));}catch(ex){;};
 return false;
}

// ^/ traps next keypress
// up/dn arrow call uarrow/darrow
function kup(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 if(e.ctrlKey)
 {
  if(c==190&&'function'==typeof ev_advance_click)
  {
   jform.jid.value  = "advance";
   jform.jtype.value= "click";
   jform.jmid.value = "advance";
   jform.jsid.value = "";
   ev_advance_click();
   return false;
  }
  if(c==191){shortcut= 1;return false;}
 }
 else
 {
  if(('undefined'==typeof noarrows)||0==noarrows)
  {
   if(c==38&&'function'==typeof uarrow){uarrow();return false;}
   if(c==40&&'function'==typeof darrow){darrow();return false;}
  }
 }
 return true;
}

// set values for shortcut call
function setshortcut(n)
{
 jform.jtype.value= "click";
 jform.jid.value= n;
 jform.jmid.value= n;
 jform.jsid.value= "";
}
 
function dostdshortcut(c)
{
 switch(c)
 {
  case '.': document.getElementById("link").focus(); break;
  case '/': location="jijx";  break;
  case 'o': location="jfile"; break;
  case '?': location="jhelp"; break;
  case 'n': location="jijs"; break;
 }
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

function menufocus()
{
 if(tmenuid!=0) clearTimeout(tmenuid);
 tmenuid= 0;
 return true;
}

// menu end

// get pixel... - sizing/resizing

// window.onresize= resize; // required for resize
// and resize should be called in evload

// the ...h functions need simple changes to
// become the corresponding set of w functions

// body{background:aqua} can be useful in
// out why calculations turn out wrong

// IF and FF both have bugs with <h1>...</h1>
// vs these calculations and <hx> should not
// be used where resizing will be used

// get pixel window height
function gpwindowh()
{
 if(window.innerHeight)
  return window.innerHeight; // not IE
 else
  return document.documentElement.clientHeight;
}

// get pixel body margin height (top+bottom)
function gpbodymh()
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
function gpdivh(id){return document.getElementById(id).offsetHeight;}

// get pixel end
)
