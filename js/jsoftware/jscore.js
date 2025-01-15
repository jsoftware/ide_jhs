var jijxwindow;    // jijx (could be closed) or null - that led (jijx->jfile->jijs) to this window
var jlogwindow;    // set by jjhs - ~temp/jlog.ijs logging window
var dirty=false;
var JASEP= '\x01';   // delimit substrings in ajax response
var jform;         // page form
var jevev;         // event handler event object
var jevtarget=null;   // event handler target object
// var jisiX    = iOS();
var VKB      = 0;  // iX kb height
var LS= location.href; // localStorage key
var i= LS.indexOf("#");
if(-1!=i) LS= LS.substring(0,i); // strip off # fragment
LS+= ".";
var logit= "";
var closing=0; // set 1 when page/locale is closing to prevent events

var touch= ('ontouchstart' in window)||(navigator.maxTouchPoints>0)||(navigator.msMaxTouchPoints>0);

const jmarka=     '<!-- j html output a -->';
const jmarkz=     '<!-- j html output z -->';

const jmarkjsa    = '<!-- j js a --><!-- ';
const jmarkjsz    = ' --><!-- j js z -->';
const jmarkremove = jmarka+jmarkjsa+" "; // ; is refresh and ajax and blank is ajax only
const jmarkrcnt   = jmarkremove.length;

const PUBLOCKED= "pop-up blocked\n\
adjust browser settings to allow localhost pop-up\n\
see: jijx>wiki>JHS>Help>pop-up";

window.addEventListener('beforeunload', function (e) {
  if(!isdirty()) return;
  e.preventDefault(); // If you prevent default behavior in Mozilla Firefox prompt will always be shown
  e.returnValue = ''; // Chrome requires returnValue to be set
});

/*
function iOS() {
 return ['iPad Simulator','iPhone Simulator','iPod Simulator','iPad','iPhone','Pod'
  ].includes(navigator.platform)
  ||
  (navigator.userAgent.includes("Mac") && "ontouchend" in document)
}
*/

function iphone() {
  //return ['iPhone Simulator','iPhone'].includes(navigator.userAgent); // ||
  return (/iPhone/.test(navigator.userAgent));
  // (navigator.userAgent.includes("Mac") && "ontouchend" in document);
 }
 
//* jbyid(id)
function jbyid(id){return document.getElementById(id);}

//* jget(id) - value
function jget(id){return jbyid(id).value;}

//* jset(id,v)
function jset(id,v){jbyid(id).value= v;}

//* jgeth(id) - innerHTML
function jgeth(id){return jbyid(id).innerHTML;}

//* jseth(id,v)
function jseth(id,v){jbyid(id).innerHTML= v;}

function jsubmit(s){jform.jdo.value=jevsentence;jform.submit();}

// set caret in element id - collapse 0 start, 1 end
function jsetcaret(id,collapse)
{
 var p= jbyid(id);
 if(null==p)return;
 if (window.getSelection)
  window.getSelection().collapse(p,collapse);
 else
 {
  var tst= document.selection.createRange();
  tst.moveToElementText(p);
  tst.collapse(!collapse);
  tst.select();
 }
}

function jsetcaretn(node)
{
 if (window.getSelection)
 {
  var sel,rng;
  node.scrollIntoView(false);
  sel=window.getSelection();
  sel.removeAllRanges();
  rng=document.createRange();
  rng.selectNode(node);
  sel.addRange(rng);
 }
 else
 {
  var tst= document.selection.createRange();
  tst.moveToElementText(node);
  tst.select();
 }
}

function jcollapseselection(d)
{
 try
 {
  if (window.getSelection)
  {
   var sel,rng;
   sel=window.getSelection();
   rng=sel.getRangeAt(0);
   sel.removeAllRanges();
   rng.collapse(d);
   sel.addRange(rng);
  }
  else
  {
   var tst;
   tst=document.selection.createRange();
   tst.collapse(d);
   tst.select();
  }
 }catch(e){}
}

// replace selection with val - collapse -1 none, 0 end, 1 start
function jreplace(id,collapse,val)
{
  try // mark caret location with ZWSP
  {
   if(window.getSelection)
   {
    let sel,rng;
    sel=window.getSelection();
    rng=sel.getRangeAt(0);
    if(collapse!=-1)rng.collapse(collapse);
    sel.removeAllRanges();
    sel.addRange(rng);
    document.execCommand("insertHTML",false,val);
   }
   else
   {
    let rng;
    rng= document.selection.createRange();
    if(collapse!=-1)rng.collapse(collapse);
    rng.pasteHTML(val);
   }
   return 1;
  }catch(e){return 0;}
}
function jhfroma(t)
{
  t= t.replace(/&/g,"&amp;");
  t= t.replace(/</g,"&lt;");
  t= t.replace(/>/g,"&gt;");
  t= t.replace(/ /g,"&nbsp;");
  t= t.replace(/-/g,"&#45;");
  t= t.replace(/\"/g,"&quot;");
  return t;
}

function jtfromhhit(t)
{
 switch(t[1])
 {
 case "n":  return " ";
 case "l":  return "<";
 case "g":  return ">";
 case "a":  return "&";
 case "Z":  return ""; // ZeroWidthSpace for wrap
 }
}

// convert html < etc to text
function jtfromh(d)
{
 d= d.replace(/\r|\n/g,"");          // IE requires
 d= d.replace(/<br><div>/g,"<div>"); // chrome - kludge (not i)
 d= d.replace(/<p>&nbsp;<\/p>|<div><br><\/div>|<br[^>]*>|<\/p>|<div>/gi,"\n");
 d= d.replace(/<\/?[^>]+(>|$)/g,""); // remove all remaining tags
 d= d.replace(/&nbsp;|&lt;|&gt;|&amp;|&ZeroWidthSpace;/g,jtfromhhit);
 if('\n'!=d[d.length-1]){d=d+"\n";}
 return d;
}

var JREGHFROMT=RegExp("[ \n<>&]","g");

function jhfromthit(t)
{
 switch(t[0])
 {
 case " ":  return "&nbsp;";
 case "\n": return "<br>";  
 case "<":  return "&lt;";
 case ">":  return "&gt;";
 case "&":  return "&amp;";
 }
}

function jhfromt(d){return d.replace(JREGHFROMT,jhfromthit);}

//* jshow(id)
function jshow(id,type= 'block'){jbyid(id).style.display=type;jresize();}

//* jhide(id)
function jhide(id){jbyid(id).style.display="none";jresize();}

//* jdlgshow(id,focus) - id to show and id to focus
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

var jdwn;     // dom walk nodes
var jdwi;     // dom walk indents
var jdwr;     // dom walk recursion level

function jdominit(node)
{
 jdwn=[];
 jdwi=[];
 jdwr=0;
 jdomwalk(node);
}

function jdomwalk(node)
{
 var c,n,i;
 ++jdwr;
 c=node.childNodes;
 for(i=0;i<c.length;++i)
 {
  n=c[i];
  jdwi.push(jdwr);
  jdwn.push(n);
  jdomwalk(n);
 }
 --jdwr;
}

function jdomshow(node)
{
 var i,j,t="";
 jdominit(node);
 for(i=0;i<jdwn.length;++i)
 {
  for(j=0;j<jdwi[i];++j)t+="| ";
  name=jdwn[i].nodeName;
  if(name=="#text")
   t+=name+" "+jdwn[i].nodeValue;
  else
   t+=name;
  t+="\n";
 }
 return t;
}

// framework internals
window.onresize=jresize;

var jevsentence; // J sentence to run
var JEV;         // js handler to call

function jresize()
{
 logit+= "B";
 // IE resize multiple frames sometimes gets id as null
 if(jbyid("jresizea")==null||jbyid("jresizeb")==null)return;
 var a= jgpwindowh(); // window height
 
 logit+= " a"+a;
 
 a-= jgpbodymh();     // body margin h (top+bottom)
 a-= jgpdivh("jresizea"); // header height
 a-= 6;               // fudge extra
 a-= VKB; // virtual keyboard - does not resize but overlays 
 a=  a<0?0:a;        // negative causes problems
 
 jbyid("jresizeb").style.height= a+"px";
}

// onload event handler - calls ev_body_load
function jevload()
{
 jijxset(); // connect jijx to new pages
 jform= document.j;
 jevsentence= "jev_"+jform.jlocale.value+"_ 0";
 dirty= !isNaN(parseInt(jbyid('jlocale').value)); // cojhs always dirty 
 var e= jbyid('menuburger'); 
 if(null!=e){
  if(!isTF()){
    e= jbyid('jmpage');if(null!=e) e.style.display= 'none'; // kill unwanted > term menu
  }
 }
 jscdo("body","","load");
 return false;
}

function jevunload(){jscdo("body","","unload");return false;}
 
function jevfocus()
{
 //if(closing||jform=="")return false; // error prevented javascript debugger from working
 jscdo("body","","focus"); // used only by jijx to call esc+2 to scroll to botton
 return false;
}

// event handler onclick etc - id is mid[*sid]
// enter event return or return+shift - iOS touch #+= has shift
// enter+shift no longer inserts newline in contenteditable
function jev(event){
 // jmenuhide(event);
 mmhide();
 jevev= window.event||event;
 // event.target gets child of element with handler
 // event.currentTarget gets bubble up to an element with handler
 jevtarget=event.currentTarget;
 var type=jevev.type;
 jform.jtype.value= type;
 var id=jevtarget.id;
 var i= id.indexOf('*');
 jform.jid.value  = id;
 jform.jmid.value = (-1==i)?id:id.substring(0,i);
 jform.jsid.value = (-1==i)?"":id.substring(++i,id.length);
 jform.jclass.value= jbyid(id).className;
 if(type=='keydown'&&27==jevev.keyCode)return false; // IE ignore esc
 if(type=='keydown'&&13==jevev.keyCode&&!jevev.ctrlKey) // iOS touch #+=
  {jform.jtype.value="enter";return jevdo();} 

 return jevdo();
}

// run sentence(s) in jijxwindow - false runs with jev_run and true runs bare sentence
function jijxrun(t,flag=true)
{
 if(jijxwindow!=null) {if(jijxwindow.closed) jijxwindow= null;}
 //! t= t.replaceAll("'","''");
 if(0==t.length) t= "\n"; // so '' displays as empty line
 if(flag) t= "jev_run'"+t.replaceAll("'","''")+"'";
 try{jijxwindow.jdoajax([],"",t,true);}
 catch(e){alert('orphaned (jijx that led to this page was closed)\n\
this action requires access to that jijx page\n\
close this page and reopen from jijx');}
}


// ajax
var rq,rqchunk,rqstate=0,rqoffset=0;

// xmlhttprequest not supported in kongueror 3.2.1 (c) 2003
function newrq()
{
 try{return new XMLHttpRequest();} catch(e){}
 try{return new ActiveXObject("Msxml2.XMLHTTP.6.0");} catch(e){}
 try{return new ActiveXObject("Msxml2.XMLHTTP.3.0");} catch(e){}
 try{return new ActiveXObject("Msxml2.XMLHTTP");} catch(e){}
 alert("XMLHttpRequest not supported.");
}

// ajax request to J
//  ev_mid_type() -> jdoaajax(ids,data)
//   -> ev_mid_type=:  (getv...)
//    -> jhrajax (JASEP delimited responses)
//      -> jdor -> ajax(ts) or ev_mid_type_ajax(ts)
//         ts is array of JASEP delimited responses
// ids is array of form element names (values)
// data is JASEP delimited data to send 
// sentence (usually elided to use jevsentence)
// async is true for asynch and false for synch
// default is synch
function jdoajax(ids,data,sentence,async)
{
 if(0!=rqstate)
 { 
  // return; // previously - alert("busy - wait for previous request to finish");
  if(null!=jbyid("status-busy")) jbyid("status-busy").style.display="block";
  return;
 }
 async= (!async)?false:async;
 sentence=sentence||jevsentence;
 data=data||"";
 ids=ids||[];
 rq= newrq();
 rqoffset= 0;
 if(async) rq.onreadystatechange= jdor;
 rq.open("POST",jform.jlocale.value,async); // true for async call
 jform.jdo.value= ('undefined'==typeof sentence)?jevsentence:sentence;
 rq.send(jpostargs(ids)+"&jdata="+jencode(data)+"&jwid="+jencode(window.name));
 if(!async)jdor();
}

function jdoj(ids){jdoajax(ids.split(' '));}

// ! now that jbyid("jmid") works, it might be be possible to avoid some use of eval


// classes that provide jpostargs values for NV 
jnv_classes= 'jhrad jhchk jhtext jhtextarea jhselect jhpassword';

jnv_ids= ''; // calculate only first time or for changes

function get_nv_ids()
{
 if(''!=jnv_ids) return jnv_ids;
 let ids= [];
 var nodes= document.getElementsByTagName("*");
 var i,node,len= nodes.length;
 for(i=0;i<len;++i)
 {
  t= nodes[i];
  if(''!=t.className && jnv_classes.includes(t.className)) ids.push(t.id);
 }
 jnv_id= ids;
 return ids;
}

// missing j jlocale jid status-busy
j_post_ids= ["jdo","jtype","jmid","jsid","jclass"];

// return post args from standard form ids and extra form ids
function jpostargs(ids)
{
 var d,t="",s="";
 a= j_post_ids.concat(ids);
 for(var i=0;i<a.length;++i)
 {
  d= jbyid(a[i]);
  if(null==d) continue;
  if("undefined"==typeof d.value)
   d= d.innerHTML;
  else 
  {
   if("jhchk"==d.className||"jhrad"==d.className)
    d= jgetchk(d.id);
   else
    d= ("checkbox"==d.type||"radio"==d.type)?(d.checked?1:0):d.value;
  }
  t+= s+a[i]+"="+jencode(d);
  s= "&";
 }
 return t;
}

function jencode(d){return(encodeURIComponent(d)).replace("/%20/g","+");}

// rprocess ajax response(s) from J
// 0 or more state 3 and then state 4
// response header (Transfer-Encoding: chunked) indicates chunked

// not chunked - call ev_mid_type_ajax(ts) - if not defined call ajax(ts)
// ts is rq.responseText split on JASEP
// function can use rq.responseText directly instead of ts

// chunked - ev_mid_type_ajax_chunk() for each state 3 and ev_mid_type_ajax() for state 4
// ..._ajax_chunk and ..._ajax must keep track of what parts of rq.responseText to use
// meaningful chunk boundaries do not match with how responseText data is received
function jdor()
{
 var d,f;
 rqstate= rq.readyState;
 f= "ev_"+jform.jmid.value+"_"+jform.jtype.value+"_ajax";
 
 if(rqstate==3&&null!=rq.getResponseHeader("Transfer-Encoding")) // chunked
 {
  f+= "_chunk";
  if("function"==eval("typeof "+f))
    try{eval(f+"()");}catch(e){alert(f+" failed: "+e);}
  return;
 }
 
 if(rqstate==4)
 {
  if(null!=jbyid("status-busy")) jbyid("status-busy").style.display="none";
  if(200!=rq.status)
  {
   if(403==rq.status)
    location="jlogin";
   else
   {
    var t;
    if(0!=rq.status)
    {
     t="ajax request failed\n";
     t+=   "response code "+code+"\n";
     t+=   "server did not produce result\n";
     t+=   "press enter in jijx for more info";
     alert(t);
    }
   }
  }
  else
  {
   d= rq.responseText;
   // \0...  is jhrjson/jhrcmds data - otherwise jhrajax data
   if('\0'===d[0])
   {
      d= JSON.parse(d.substring(1)); // json data from response
      // if ev_..._json defined - call it
      // if not defined and d['jhrcmds'] is defined - call jhrcmds(d['jhrcmds'])
      var n= f+'_json';
      f= window[n];
      var c=d['jhrcmds'];
      if('function'!=typeof f && null!=c)
        jhrcmds(c);
      else
       try{f(d);}catch(e){alert(n+" failed: "+e);}
     
    } 
    else
      rajax(f,d);
  }
  rqstate= 0; rqoffset= 0;
 }
}

// process jhrajax result
function rajax(f,d)
{
  d= d.split(JASEP);
  if(  "undefined"==eval("typeof "+f) && "undefined"==typeof ajax)
  {
    alert("not defined: function "+f+"()");
  }
  else
  {
   if("function"==eval("typeof "+f))
    f+="(d)";
   else
    f="ajax(d)";
   try{eval(f);}catch(e){alert(f+" failed: "+e);}
  }
}

// run jhrcmds from jixj jjs
function runjhrcmds(t){
  t= decodeURIComponent(t);
  var d= JSON.parse(t); // json data
  var c=d['jhrcmds'];
  jhrcmds(c);
}

function jhrcmds(ts){
  var a,i,j,t,cmd,val,id; 
  for(i=0;i<ts.length;++i){
    try{ 
      // id can be mid*sid so search for start of value must be ' *'
      a= ts[i];
      if(0==a.replaceAll(' ','').length) return;
      j= a.indexOf(' *');
      if(-1==j){val='';cmd=a}
      else{val= a.substring(j+2);cmd= a.substring(0,j);}
      cmd= cmd.split(' ');
      switch(cmd[0]){
        case 'set' :
        id= jbyid(cmd[1]);
        if(null==id) throw cmd[1]+" is invalid id";
        if("undefined"==typeof id.value)
          id.innerHTML= val;
        else
          id.value= val;
        break; 

        case 'chartjs' :
          jsdata[cmd[1]]= val;
          chartjs(cmd[1],val);
          break;

        case 'css' :
          var sheet= document.getElementById('JCSS');
          if(null!=sheet) sheet.parentNode.removeChild(sheet);
          if(0!=val.length){
            sheet= document.createElement('style');
            sheet.id= "JCSS";
            sheet.innerHTML= val;
            document.body.appendChild(sheet);
          }
          break;
    
        case 'alert':
           alert(val);
           break;

         case 'copy':
           navigator.clipboard.writeText(val);
           break;

         case 'pageopen':
          var args= val.split(',');
          pageopen(args[0],args[1],args[2]);
          break;
           
     
         default: 
           throw cmd[0]+" is invalid command";
           break;
      }
    }
    catch(e){
      alert('jhrcmds command failed:\n'+a+'\n'+e);
      return;
    }
  }
}

// log lines in ~temp/jlog.ijs file
// printf/echo debugging tool
function jlog(t)
{
 if(jlogwindow==null) return;
 a= jlogwindow.cm.doc.getValue()+'\n'+t;
 jlogwindow.cm.doc.setValue(a);
}

function ifjijxwindow(){return (jijxwindow===undefined || jijxwindow==null || jijxwindow.closed) ? false:true;}

// set jijxwindow as jijx that led to this window
function jijxset()
{
  var w;
  w= window.parent;
  if(w!=window){jijxwindow= w;return;}
  w= window.opener;
  if(w!=null && "jijx"!=w.name) w= w.opener;
  if(w!=null && "jijx"!=w.name) w= null; // jijx->jfile->jijs
  jijxwindow= w;
}

// app keyboard shortcuts

document.onkeyup= keyup; // bad things happen if this is keydown
document.onkeypress= keypress;

var jsc= 0;

function jscset(){jsc=1;}

// page redefines to avoid std shortcuts
function jdostdsc(c)
{
 switch(c)
 {
  case 'q': jscdo('close');break;
 }
}

// IE/FF see esc etc but Chrome/Safari do not
function keypress(ev)
{
 var e=window.event||ev;
 var c=e.charCode||e.keyCode;

 // touch escape
 if(e.key=='è'){jsc=!jsc;return false;}  // esc shortcut - letter e + slide up

 var s= String.fromCharCode(c);
 if(!jsc)return true;
 jsc=0;
 try{eval("ev_"+s+"_shortcut()");}
 catch(ee){jdostdsc(s);}
 return false;
}

function keyup(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 if(e.ctrlKey)
 {
  if('MacIntel'==navigator.platform)
  {
   if(c==188&&e.shiftKey&&'function'==typeof uarrow){uarrow();return false;}
   if(c==190&&e.shiftKey&&'function'==typeof darrow){darrow();return false;}
  }
  if(c==188){jscdo(e.shiftKey?"less":"comma",undefined,"ctrl");return false;}
  if(c==190){jscdo(e.shiftKey?"larger":"dot",undefined,"ctrl");return false;}
  if(c==191){jscdo(e.shiftKey?"query":"slash",undefined,"ctrl");return false;}
  if(c==59){jscdo(e.shiftKey?"colon":"semicolon",undefined,"ctrl");return false;}
  if(c==222){jscdo(e.shiftKey?"doublequote":"quote",undefined,"ctrl");return false;}
  if(c==38&&e.shiftKey&&'function'==typeof uarrow){uarrow();return false;}
  if(c==40&&e.shiftKey&&'function'==typeof darrow){darrow();return false;}
 }
 if(c==27&&!e.shiftKey&&!e.altKey){jsc=!jsc;return !jsc;} // esc shortcut
 return true; 
}



// get pixel... - sizing/resizing

// window.onresize= resize; // required for resize
// and resize should be called in ev_body_load

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
function jgpdivh(id){return jbyid(id).offsetHeight;}

/*
function jgpdivh(id)
{
 var e=jbyid(id);
 if(e==null)return 50;
 //alert(e+" "+id);
 // alert(e.offsetHeight);
 //return jbyid(id).offsetHeight;
 var v=e.offsetHeight;
 //alert(id+" "+v);
 return v;
}
*/

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

// eval js sentences in s
// a is true in ajax and false in refresh
function jseval(ajax,s)
{
 var i,j,a,z,q;
 a= jmarka+jmarkjsa;
 z= jmarkjsz+jmarkz;
 while(0!=s.length)
 {
  i= s.indexOf(a);
  if(-1!=i)
  {
   i+= a.length;
   j= s.indexOf(z);
   q= s.substring(i,j);
   s= s.substring(j+z.length);
   if(ajax||';'==q.charAt(0)) try{eval(q);}catch(e){alert(e+"\n"+q);}
  }
  else
   s= "";
 }
}

// remove jjs ajax only from s
function jjsremove(s)
{
 var i,j;
 var z= jmarkjsz+jmarkz;
 var d= "";
 while(0!=s.length)
 {
  i= s.indexOf(jmarkremove);
  if(-1!=i)
  {
   d+= s.substring(0,i);
   j= s.indexOf(z);
   s= s.substring(j+z.length);
  }
  else
  {
   d+= s;
   s= "";
  } 
 }
 return d;
}

function getls(key){return localStorage.getItem(LS+key);}
function setls(key,v){localStorage.setItem(LS+key,v);}

function adrecall(id,a,start)
{
 setls(id+".index",start);
 if(0==a.length) return;
 var t= getls(id);
 if(t==null) t= "";
 var i,blank=0,same=0;
 for(i=0;i<a.length;++i)
  blank+= ' '==a.charAt(i);
 a= a+"\n";
 for(i=0;i<a.length;++i)
  same+= a.charAt(i)==t.charAt(i);
 if(blank!=a.length && same!=a.length)
 {
  t= a+t;
  if('\n'==t.charAt(t.length-1))
   t= t.substring(0,t.length-1); // drop trailing \n so split works
  if(1000<t.length)t= t.substring(0,t.lastIndexOf("\n"));
  setls(id,t);
 }
}

function uarrow(a){udarrow(a,1);}
function darrow(a){udarrow(a,0);}

function udarrow(a,up)
{
 var id,v,t,n;
 if(a==null) a= document.activeElement;
 if(a==null || a.type!="text")
  id= "document";
 else 
  id= a.id; 
 t= getls(id);
 n= getls(id+".index");
 if(t==null || n==null)return;
 t= t.split("\n");
 if(up)
 {
  if(++n>=t.length) n= t.length-1;
  if(n==-1)
   v= t[0];
  else
   v= t[n];
 }
 else
 {
  if(--n<0)
   {n= 0; v= t[0];}
  else
   v= t[n];
 }
 setls(id+".index",n);
 if(id=="document")
  document_recall(v);
 else
  a.value= v; 
}

function setlast(id)
{
  var a= jbyid(id);
  setls(id+".index","-1");
  udarrow(a,1);
}

// jfif/... just close - cojhs call J ev_close_click
// overidden by jijx, jijs and cojhs that need extra dirty work
function ev_close_click(){
 if(dirty) jdoajax();

 if('undefined'==typeof window.parent.spaclose)
 {
  document.open(); document.write('You quit this JHS page and can now close the browser window.'); // in case close fails
  window.close();
 }
 else{
   window.parent.spaclose(window);
 }

}

// isFrame - true if w is embeded in a frame
function isFrame(w){return null!=w.frameElement;}

// isTF - true if running in term or term SPA frame
function isTF(){return 'undefined'!=typeof(SPA) || isFrame(window);}

// isSPA - true if term window and SPA default is true
function isSPA(){
 if(!ifjijxwindow()) return false;
 return jijxwindow.SPA;  
}

function isPages(){
  if(!ifjijxwindow()) return false;
  return jijxwindow.allpages[1]!=null
}

function ev_close_click_ajax(){}

function isdirty(){return dirty;} // default - override

function ev_dot_ctrl(){jijxrun("ev_advance_click_jijx_''");} // lab advance lab

// chartjs start
function cjs(id){return Chart.getChart(id);}

function cjs_init(id){
  chartjs(id);
}

function cjs_update(id,defn){
  chartjs(id,defn);
}

function chartjs(id,defn){
  if('undefined'==typeof cjs(id)){
    // init
    var t= jsdata[id];
    if(0!=t.length)t= t.split("\n");
    var q= {};
    for(i=0;i<t.length;++i){cjs_set(q,t[i]);}
    new Chart(jbyid(id), q);
  }
  else{
    // update
    var d= {};
    var t= defn.split("\n");
    jsdata[id]= defn;
    for(i=0;i<t.length;++i){cjs_set(d,t[i]);}
    var c= cjs(id);
    c.config.type= d.type; // note c.config.type instead of c.type
    c.data= d.data;
    c.options= d.options;
    c.update();
  }
}

function cjs_set(d,s){
 if(0==s.length || '/'==s.charAt(0)) return;
 var i= s.indexOf(' ');
 var path= s.substr(0,i);
 var v= s.substr(i).trim();
 v= JSON.parse(v);
 cjs_setprop(d,path,v);
}

function cjs_setprop(obj, path, value) {
  const arr = path.split(".");
  while (arr.length > 1) {
    let t= arr.shift();
    if('undefined'==typeof obj[t]) obj[t]= {};
    obj= obj[t];
  }
  obj[arr[0]] = value;
}
// chartjs end

// remove sentence select lists after they are used
function removeElementsByClass(className){
  const elements = document.getElementsByClassName(className);
  while(elements.length > 0){
    elements[0].parentNode.removeChild(elements[0]);
  }
}

// hamburger menu
var mmshowing='';

function mmhide(){
//  alert('mmhide'+mmshowing); //!
  jbyid('menuclear').style.visibility= 'hidden';
  if(mmshowing!="")jbyid(mmshowing).style.visibility= 'hidden';
  mmshowing= "";
}

function mmshow(e){
 jbyid('menuclear').style.visibility= 'visible';
 jbyid(e).style.visibility= 'visible';
 mmshowing= e;
}

function ev_menuburger_click(){
 if(''==mmshowing)
 {
  mmshowing= 'menu0';
  mmshow(mmshowing);
 }
 else
  mmhide();
}

//!function ev_menuburger_click(){mmshow('menu0');}
function ev_menuburger_click(){menushow('menu0');}

function topage(n){jijxwindow.pageswitch(window,n);}

function ev_menuclear_click(){mmhide();}

// remove child from parent
function removeitem(id){
  var nid= jbyid(id);
  if(nid!=null) nid.parentNode.removeChild(nid);
}

// menuitem onclick 
function menushow(menuid){
  var id,a;
  mmhide();

  if(menuid=='menu0'){
    id= jbyid(menuid);
    removeitem('jmleft');
    removeitem('jmright');
    removeitem('jmpage');
    if(isPages()){
      a= '<a id="jmleft" href="#" class="jmenuitem" onclick="mmhide();return jev(event)" >left<span class="jmenuspanright">ctrl+<</span></a>'
      id.insertAdjacentHTML('beforeend',a);
      a= '<a id="jmright" href="#" class="jmenuitem" onclick="mmhide();return jev(event)" >right<span class="jmenuspanright">ctrl+></span></a>'
      id.insertAdjacentHTML('beforeend',a);
      a= '<a href="#" class="jmenuitem" id="jmpage" onclick="return menushow(\'jmpages\')" ><span class="jmenuspanleft" >&gt&nbsp;</span>term&nbsp;pages<span class="jmenuspanright"></span></a>'
      id.insertAdjacentHTML('beforeend',a);
    }
  }

  if(menuid=='jmpages'){
    // populate live menu - remove old and add new
    id=jbyid('jmpages'); //!
    while (id.firstChild!=id.lastChild){id.removeChild(id.lastChild);}
    var n= jijxwindow.pagenames();
    var t= '';
    for(var i= 0 ; i<n.length ; i++ ){ // term already there
      a= '<a class="jmenuitem" onclick="mmhide();topage(';
      a+= i+')" >'+n[i]+'<span class="jmenuspanright"></span></a>'
      t+= a;
    }
    id.insertAdjacentHTML('beforeend',t);
  }

  if(menuid!="") mmshow(menuid);
  return false; // essential!
 }

 // jscore stuff - new for jhchk and jhrad

function ev_body_load(){
  if('object'==typeof jsdata){
    var c= jsdata['jhrcmds'];
    if(null!=c) jhrcmds(c);
  }  
}

function ev_body_unload(){}
function ev_body_focus(){}

function jgetchk(id){return +jbyid(id).getAttribute("data-jhscheck");}

function jsetchk(id,v)
{
 var e= jbyid(id);
 e.setAttribute("data-jhscheck",+v);
 var m= e.getAttribute("data-jhsmarks")[+v];
 e.innerHTML= m+e.innerHTML.substring(1);
 var set= e.getAttribute("data-jhsset");
 if(set!=null && 1==+v)
 {
  // rad state from to 0 to 1- set others in set to 0
  let d= document.getElementsByClassName(e.className);
  for (let i = 0; i < d.length; i++)
  {
   if(e!=d[i] && set==d[i].getAttribute("data-jhsset"))
   {
     d[i].setAttribute("data-jhscheck",0);
     m= d[i].getAttribute("data-jhsmarks")[0];
     d[i].innerHTML= m+d[i].innerHTML.substring(1); 
   }
  }
 }
}

// click on chk or rad always changes state
function dochk(id)
{
  var e= jbyid(id);
  if(null==e)return;
  if(e.className=='jhchk')
   jsetchk(id,jgetchk(id)!=1);
  else if(e.className=='jhrad')
   if(jgetchk(id)==0) jsetchk(id,1);
}

//  ev_mid_type(id)
//   ev_class_type(id)
//    special default actions
//     alert error
function jevdo()
{
 mid=  jform.jmid.value;
 sid=  jform.jsid.value;
 type= jform.jtype.value;
 id=   jform.jid.value;

 dochk(id);

 JEV= "ev_"+mid+"_"+type; // mid not id - mid handler can check sid
 f= window[JEV];
 if('function'!=typeof f)
 {
  // no JS handler defined - call J handler uness data-jhsnojdefault
  // ! if(null==jevtarget)return true;
  if(['click','enter','change'].includes(type)){
    e= jbyid(id);
    if(null!=e)
    {
      t= e.getAttribute("data-jhsnojdefault");
      if(t!=null && t==1) return false;
    }
    jdoajax(get_nv_ids(),'');
    return false; // alert if j verb not defined
  }
  return true;
 }
 
 // f is handler to call
 let r;
 try{r= f();} // ! note jid not jmid
 catch(ex){
   alert(JEV+" failed: "+ex); return false;
  }
 if('undefined'!=typeof r) return r;
 return false;
}

// convert to event for mid [sid=""] [type="click"]
// sid undefined or '' does not add *
function jscdo(mid,sid,type) // click handler for mid [sid] type
{
 jevtarget=null; 
 jform.jtype.value= type?type:"click";
 if('undefined'==typeof sid || 0==sid.length)
 {
  jform.jid.value= mid;
  jform.jmid.value=mid;
  jform.jsid.value="";
 }
 else
 {
  jform.jid.value= mid+'*'+sid;
  jform.jmid.value=mid;
  jform.jsid.value=sid;
 }
 jevdo();
}

// used by jpage edit'...' jfif jfile jfiles ...
// open existing window or open it fresh
// new window added to jijxwindow.allwins
// returned window must not be used until the url has loaded
// specs - term or tab or 10 10 or '' for isSPA
// can be used with jijxwindow null
function pageopen(url,wid,specs){
  wid= decodeURIComponent(wid);

  if(specs=='term' || isSPA() && (null==specs || specs==""))
    return jijxwindow.newpage('jifr-'+url,'jifr',wid); //! jijxwindow.

  if(specs=='tab') specs= '';

  if(ifjijxwindow()) w= jijxwindow.getwindow(wid); else w=null;
  if(null!=w){w.setTimeout(function(){w.focus();},25);return;}
  w=window.open(url,wid,specs); // pageopen
  if(null==w){alert(PUBLOCKED);return w;}
  if(ifjijxwindow()) jijxwindow.allwins.push(w);
  return w;
 }
 
 // similar to pageopen, but not same origin - e.g. wiki pages
 function urlopen(url,specs){
  wid= decodeURIComponent(url);
  w=window.open(wid,wid,specs); // urlopen
  if(null==w) alert(PUBLOCKED);
  return w;
 }

// single page app stuff

// ctrl+shift+< or > are the same for all pages - spa left/right

function ev_less_ctrl(){ev_jmleft_click();}
function ev_larger_ctrl(){ev_jmright_click();}

function ev_jmleft_click() {mmhide();if(isTF())jijxwindow.termleft(window);}
function ev_jmright_click(){mmhide();if(isTF())jijxwindow.termright(window);}

function winclose(){jijxwindow.spaclose(window);}

// save server file to client downloads
function saveAs(content,fileName) {
  const a = document.createElement("a");
  const file = createBlob(content);
  const url = window.URL.createObjectURL(file);
  a.href = url;
  a.download = fileName;
  a.click();
  URL.revokeObjectURL(url);
}

function createBlob(data) {
  return new Blob([data], { type: "application/octet-stream" });
}

function base64ToArrayBuffer(base64) {
    var binary_string = window.atob(base64)
    var len = binary_string.length;
    var bytes = new Uint8Array(len);
    for (var i = 0; i < len; i++) {
      bytes[i] = binary_string.charCodeAt(i);
    }
    return bytes.buffer;
}



