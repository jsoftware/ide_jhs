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
 jmenuhide(event); // hide menu dropdown
 jevev= window.event||event;
 var i= id.indexOf('*');
 jform.jid.value  = id;
 jform.jtype.value= type;
 jform.jmid.value = (-1==i)?id:id.substring(0,i);
 jform.jsid.value = (-1==i)?"":id.substring(++i,id.length);
 if(jevev.type=='keydown'&&27==jevev.keyCode)return false; //! IE ignore esc
 if(type=='enter'&&13!=jevev.keyCode) return true;
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

//! kill off jdoh when everyone converted to jdoa

// ajax standard handler as provided by framework (j and js)
//  ev_mid_type() -> jdoa(data)
//   -> ev_mid_type (getv'jdata') -> jhrajax (JASEP delimited responses)
//      -> jdor -> ev_mid_type_ajax(ts)
//       ts is array of JASEP delimited responses

// send ajax request to J
// data is JASEP delimited data to send 
function jdoa(data)
{
 if(0!=rqstate){alert("busy - wait for previous request to finish");return;}
 rq= newrq();
 rq.onreadystatechange= jdor;
 rq.open("POST",jform.jlocale.value,true); // asynch
 jform.jdo.value= jevsentence;
 jform.jajax.value= true;
 var t="";
 t+="jdo="+jform.jdo.value;
 t+="&jmid="+jform.jmid.value;
 t+="&jsid="+jform.jsid.value;
 t+="&jtype="+jform.jtype.value;
 t+="&jdata="+encode(data);
 rq.send(t);
}

// recv ajax response from J -> ev_mid_type_ajax(ts)
function jdor()
{
 rqstate= rq.readyState;
 if(rqstate==4)
 {
  if(200!=rq.status)
   alert("ajax request failed - see jijx");
  else
  {
   var d=rq.responseText.split(JASEP);
   var f="ev_"+jform.jmid.value+"_"+jform.jtype.value+"_ajax(d)";
   try{eval(f)}catch(e){alert(f+" failed");}
  }
  rqstate= 0;
  busy= 0;
 }
}

function encode(d)
{
  return(encodeURIComponent(d)).replace("/%20/g","+");
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
document.onkeypress= keypress;

var jsc= 0;

function jscset(){jsc=1;}

// page redefines to avoid std shortcuts
// '2' shortcut implemented as ev_2_shortcut for each page
function jdostdsc(c)
{
 switch(c)
 {
  case '1': jactivatemenu('1'); break;
  case 'j': location="jijx";  break;
  case 'f': location="jfile"; break;
  case 'h': location="jhelp"; break;
  case 'J': location="jijs"; break;
  case 'F': location="jfif"; break;
 }
}

// IE/FF see esc etc but Chrome/Safari do not
function keypress(ev)
{
 var e=window.event||ev;
 var c=e.charCode||e.keyCode;
 var s= String.fromCharCode(c);
 if(!jsc)return true;
 jsc=0;
 try{eval("ev_"+s+"_shortcut()");}
 catch(e){jdostdsc(s);}
 return false;
}

function kup(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 if(e.ctrlKey)
 {
  if(c==190){jscset();return false;}
  if(c==38&&e.shiftKey&&'function'==typeof uarrow){uarrow();return false;}
  if(c==40&&e.shiftKey&&'function'==typeof darrow){darrow();return false;}
 }
 if(c==27&&!e.shiftKey&&!e.altKey)
 {
  jsc=!jsc;return !jsc;
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

// tar is current node
// c is 37 38 39 40 - left up right down
// navigate to node based on c and focus
function jmenunav(tar,c)
{
 var i,n,nn,nc,node,cnt=0,last,len,cl,m=[];
 //! alert(tar.id+" "+" "+tar.getAttribute("class")+" "+c);
 var nodes=document.getElementsByTagName("a");
 len=nodes.length
 for(i=0;i<len;++i)
 {
  node=nodes[i];
  cl=node.getAttribute("class");
  if("hmg"==cl||"hml"==cl||"hmab"==cl)
  {
   m[m.length]=node;
   if(tar==node)n=i;
  }
 }
 len=m.length;
 nn=m[n];                        // nn node
 nc= m[n].getAttribute("class"); // nc class
 if(c==39) // right
 {
  for(i=n+1;i<len;++i)
   if(jmenunavfocushmg(m,i))return;
  jmenunavfocushmg(m,0); 
 }
 else if(c==37) // left
 {
  for(n;n>=0;--n) // back n up to current group
   if(1==jmenunavinfo(m,n))break;
  for(i=n-1;i>=0;--i)
   if(jmenunavfocushmg(m,i))return;
  for(i=len-1;i>=0;--i) // focus last hmg
   if(jmenunavfocushmg(m,i))return;
 }
 else if(c==38) // up
 {
  if("hmg"==nc) return;
  if(jmenunavfocus(m,n-1))return;
  else
  {
   for(i=n;i<len;++i) // forward to hmg then back one
    if(2!=jmenunavinfo(m,i))break;
   jmenunavfocus(m,i-1);
   return;
  }
 }
 else if(c==40) // dn
 {
  if("hmg"==nc)
  {
   jmenuhide();
   nn.focus();
   jmenushow(nn);
  }
  if(jmenunavfocus(m,n+1))return;
  else
  {
   for(i=n;i>=0;--i) // back up to hmg then forward 1
    if(1==jmenunavinfo(m,i))break;
   jmenunavfocus(m,i+1);
   return;
  }
 }
}

// focus,show if hmg - return 1 if focus is done
function jmenunavfocushmg(m,n)
{
 if(1!=jmenunavinfo(m,n))return 0;
 m[n].focus();jmenushow(m[n]);
 return 1;
}

// focus if hml/jmab - return 1 if focus is done
function jmenunavfocus(m,n)
{
  if(2!=jmenunavinfo(m,n))return 0;
  m[n].focus();
  return 1;
}

// return m[n] info - 0 none, 1 hmg, 2 hml or hmab
function jmenunavinfo(m,n)
{
 if(n==m.length)return 0;
 return ("hmg"==m[n].getAttribute("class"))?1:2
}

// activate menu group n
function jactivatemenu(n)
{
 jmenuhide();
 //! window.scrollTo(0,0);
 var node= jfindmenu(n);
 if('undefined'==typeof node) return;
 node.focus(); 
}

// menu
var menublock= null; // menu ul element with display:block
var menulast= null;  // menu ul element just hidden 

function jmenuclick(ev)
{
 jmenuhide(ev);
 var e=window.event||ev;
 var tar=(typeof e.target=='undefined')?e.srcElement:e.target;
 var id=tar.id;
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

function jmenushow(node)
{
 jmenuhide();
 var id=node.id;
 var idul= id+"_ul";
 menublock= jbyid(idul);
 menublock.style.display= "block";
}

function jmenuhide()
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

function jmenublur(ev)
{
 if(tmenuid!=0) clearTimeout(tmenuid);
 tmenuid= setTimeout(jmenuhide,250)
 return true;
}

function jmenufocus(ev)
{
 if(tmenuid!=0) clearTimeout(tmenuid);
 tmenuid= 0;
 return true;
}

function jmenukeydown(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 return(c>36&&c<41)?false:true;
}

function jmenukeypress(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 return(c>36&&c<41)?false:true;
}

function jmenukeyup(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 if(c<37||c>40)return false;
 var tar=(typeof e.target=='undefined')?e.srcElement:e.target;
 jmenunav(tar,c);
 return true;
}

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

// set caret in element e - collapse 0 start, 1 end
function jsetcaretx(p,collapse)
{
 p.scrollIntoView(false);
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

// select node
function jsetcaretn(n)
{
 if (window.getSelection)
 {
  var sel,rng;
  n.scrollIntoView(false);
  sel=window.getSelection();
  sel.removeAllRanges();
  rng=document.createRange();
  rng.selectNode(n);
  sel.addRange(rng);
 }
 else
 {
  var tst= document.selection.createRange();
  tst.moveToElementText(n);
  //! tst.collapse(!collapse);
  tst.select();
 }
}

/* contenteditable to/from text
IE:
 <BR>             <-> N (\n)
 </P>              -> N
 <P>&nbsp;</P      -> N (can not tell emtpy from 1 blank)
 can have \r\n !

Chrome:
 <br>            <-> N
 <div>            -> N
 <div><br></div>  -> N
 saw nested divs, but do not know how to get them
 starting div so break on div rather than /div
 
FF:
 <br>            <-> N
 has (and needs) <br> at end

Portable rules (all case insensitive):
 remove \r \n
 <p>&nbsp;</p>    -> N
 <div><br></div>  -> N
 <br>            <-> N
 </p>             -> N
 </div>           -> N
 always have <br> at end (read/write)
 &lt;...         <-> < > & space
*/

// text from html - what about <br/>?
function jtfromh(d)
{
 //! t=d;
 d= d.replace(/\r|\n/g,"");
 d= d.replace(/<\/?[sS]\/?[^>]+(>|$)/g,""); // remove <span...> </span> tags
 d= d.replace(/<br><div>/gi,"<div>"); //! chrome - kludge
 d= d.replace(/<p>&nbsp;<\/p>|<div><br><\/div>|<br>|<\/p>|<div>/gi,"\n");
 // d= d.replace(/<p>&nbsp;<\/p>/gi,"\n");
 // d= d.replace(/<div><br><\/div>/gi,"\n");
 // d= d.replace(/<br>/gi,"\n");
 // d= d.replace(/<\/p>/gi,"\n");
 // d= d.replace(/<div>/gi,"\n");
 d= d.replace(/<\/?[^>]+(>|$)/g,""); // remove all remaining tags
 d= d.replace(/&lt;/g,"<");
 d= d.replace(/&gt;/g,">");
 d= d.replace(/&amp;/g,"&");
 d= d.replace(/&nbsp;/g," ");
 if('\n'!=d[d.length-1]){d=d+"\n";}
 //! alert(t+"\nX\n"+d);
 return d
}

// inverse jtfromh
function jhfromt(d)
{
 d= d.replace(/&/g,"&amp;");
 d= d.replace(/</g,"&lt;");
 d= d.replace(/>/g,"&gt;");
 d= d.replace(/ /g,"&nbsp;");
 d= d.replace(/\n/g,"<br>");
 return d
}

function jshow(id){jbyid(id).style.display="block";}
function jhide(id){jbyid(id).style.display="none";}

function jdlgshow(id,focus)
{
 if(jbyid(id).style.display=="block")
  jhide(id);
 else
 {
  jshow(id);
  jbyid(focus).focus();
 }
}

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

// debug

// numbers from unicode
function debcodes(t)
{
 r= "";
 for(var i=0;i<t.length;++i)
  r= r+" "+t.charCodeAt(i);
 return r;
}
)
