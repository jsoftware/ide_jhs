NB. J HTTP Server - ijs app
coclass'jijs'
coinsert'jhs'

HBS=: 0 : 0
jhma''
'action'    jhmg'action';1;10
 'runw'     jhmab'run         r^'
 'runwd'    jhmab'run display'
 'save'     jhmab'save        s^'
 'saveas'   jhmab'save as...'
 'findd'    jhmab'find...     q^'
 'findfirst'jhmab'find first  w^'
 'findnext' jhmab'find next   e^'
 'replace'  jhmab'replace...'
'option'    jhmg'option';1;8
 'ro'       jhmab'readonly    t^'
 'color'    jhmab'color       c^'
 'number'   jhmab'number      n^'
jhjmlink''
jhmz''

'saveasdlg'    jhdivahide''
 'saveasdo'    jhb'save as'
 'saveasx'     jht'';10
  'saveasclose'jhb'X'
'<hr></div>'

'repldlg'      jhdivahide''
 'repldo'      jhb'replace all with'
  'replnew'    jht'';10
    'replclose'jhb'X'
'<hr></div>'

'finddlg'    jhdivahide''
 'find'      jhb'find'
 'what'      jht'';10
 'context'   jhselne(<;._2 FIFCONTEXT_jfif_);1;0
 'matchcase' jhckbne'case';'matchcase';1
 'findclose'  jhb'X'
'<hr></div>'

'rep'         jhdiv''

'filename'    jhh  '<FILENAME>'
'filenamed'   jhdiv'<FILENAME>'

'num'         jhecleft''
'ijs'         jhecright'<DATA>'

'textarea'    jhh''
)

NB. y file
create=: 3 : 0
try. d=. 1!:1<y catch. d=. 'file read failed' end.
(jgetfile y) jhr 'FILENAME DATA';y;jhfroma d
)

jev_get=: 3 : 0
if. 'open'-:getv'mid' do.
 create getv'path' 
else.
 create jnew''
end.
)

save=: 3 : 0
if. #USERNAME do.
 fu=. jpath'~user'
 'save only allowed to ~user paths' assert fu-:(#fu){.y
end.
assert -._1-:(toHOST getv'textarea')fwrite <y
)

ev_save_click=: 3 : 0
f=. jpath getv'filename'
try.
 save f
 jhrajax 'saved without error'
catch.
 jhrajax 'save failed'
end.
)

ev_runw_click=: 3 : 0
f=. jpath getv'filename'
try.
 save f
 if. 'runw'-:getv'jmid' do.
  load__ f
 else.
  loadd__ f
 end.  
 jhrajax 'ran saved without error'
catch.
 jhrajax 13!:12''
end.
)

ev_runwd_click=: ev_runw_click

NB.! saveas replace cancel option if file already exists
ev_saveasx_enter=: 3 : 0
f=. getv'filename'
n=. getv'saveasx'
if. n-:n-.'~/' do.
 new=. (jgetpath f),n
else.
 new=. jpath n
end.
if. fexist new do. jhrajax 'file already exists' return. end.
try.
 save new
 jhrajax ('saved as ',n),JASEP,new
catch.
 jhrajax 'save failed'
end.
)

NB. new ijs temp filename
jnew=: 3 : 0
d=. 1!:0 jpath '~temp\*.ijs'
a=. 0, {.@:(0&".)@> _4 }. each {."1 d
a=. ": {. (i. >: #a) -. a
f=. <jpath'~temp\',a,'.ijs'
'' 1!:2 f
>f
)

NB.! p{} klduge cause IE insert <p> instead of <br> for enter
CSS=: 0 : 0
#rep{color:red}
#filenamed{color:blue;}
*{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
p{margin:0;}
)

JS=: 0 : 0
var ta,rep,readonly,colorflag,saveasx,toid=0;
var markcaret="&#8203;"; // \u200B
var rwhat="";            // find regexp
var spanmark="<span class=\"mark\" style=\"background-color:#D7D7D7\">";

function evload() // body onload->jevload->evload
{
 ce= jbyid("ijs");
 rep= jbyid("rep");
 ta= jbyid("textarea");
 saveasx=jbyid("saveasx");
 ro(0!=ce.innerHTML.length);
 jbyid("num").setAttribute("contenteditable","false");
 if(!readonly){ce.focus();jsetcaret("ijs",0);}
 colorflag=1;
 color();
}

function ro(only)
{
 readonly= only;
 ce.setAttribute("contenteditable",readonly?"false":"true");
 ce.style.background= readonly?"#eee":"#fff";
}

function click(){ta.value= jtfromh(ce.innerHTML);jdoh(["filename","textarea","saveasx"]);}
function ev_save_click() {click();}
function ev_runw_click() {click();}
function ev_runwd_click(){click();}

function ev_saveasdo_click(){click();}
function ev_saveasx_enter(){click();}
function ev_saveas_click()     {jdlgshow("saveasdlg","saveasx");}
function ev_saveasclose_click(){jhide("saveasdlg");}

function ev_replnew_enter(){;}
function ev_reply_enter(){;}
function ev_replace_click()  {jdlgshow("repldlg","replnew");}
function ev_replclose_click(){jhide("repldlg");}

function ev_findd_click(){jdlgshow("finddlg","what");}

function ev_findclose_click(){jhide("finddlg");}

function ev_repldo_click()
{
 var t,v,r;
 find();
 t=ce.innerHTML;
 v=jbyid("replnew").value;
 r=RegExp(spanmark+"[^<]*</span>","g");
 t=t.replace(r,v);
 ce.innerHTML=t;
}

function ev_ro_click(){ro(readonly= !readonly);}

function ev_color_click()
{
 colorflag=!colorflag;
 color();
}

function ev_number_click()
{
 numberflag=!numberflag;
 number();
}

function ev_c_shortcut(){jscdo("color");}
function ev_n_shortcut(){jscdo("number");}
function ev_q_shortcut(){jscdo("findd");}
function ev_w_shortcut(){jscdo("findfirst");}
function ev_e_shortcut(){jscdo("findnext");}

var alphanum= "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

// return 0 not assign, 1 =:, 2 =.
function asschk(j,s)
{
 while(j<s.length&&" "==s.charAt(j))++j;
 if(j==s.length||s.charAt(j)!="=")return 0;
 if(++j==s.length)return 0;
 var c=s.charAt(j);
 if(c==":")return 1;
 return(c==".")?2:0;
}

function colmark(d,i,s) // mark find
{
 var a=" ",b=" ",m="\u0004"+d+"\u0000";
 var t=jbyid("context").selectedIndex;
 if(0==t)return m;
 if(0!=i)a=s.charAt(i-1);
 if(s.length!=i+d.length)b=s.charAt(d.length+i);
 if(-1!=alphanum.indexOf(a)||-1!=alphanum.indexOf(b))return d;
 switch(t)
 {
  case 1: // name
   return m;
   break;
  case 2: // =. or =:
   return(0==asschk(i+d.length,s))?d:m;
   break;
  case 3: // =:
   return(1==asschk(i+d.length,s))?m:d;
   break;
  case 4: // =.
   return(2==asschk(i+d.length,s))?m:d;
   break;
 }
}

function colhit(d) // syntax color
{
 var t;
 if("'"==d[0])
  t="\u0003";
 else
  if("NB."==d.substr(0,3))
   t="\u0002";
  else
   if(2<d.length)
    t="\u0001";
   else
    return d;
 return t+d+"\u0000";
}

function findspan(t)
{
 return('string'==typeof rwhat)?t:t.replace(/\u0004/g,spanmark);
}

function findmark(t){return('string'==typeof rwhat)?t:t.replace(rwhat,colmark);}


// caret preserved by
//  inserting ZWSP, manipulating, ZWSP to span id, selecting span id
// rwhat global to mark finds
function color()
{
 var t,sel,rng,mark=0;
 if(!readonly) // IE readonly caret stuff messes up menu vs border 
 {
  ce.focus();
  try // mark caret location with ZWSP
  {
   if(window.getSelection)
   {
    sel= window.getSelection();
    rng= sel.getRangeAt(0);
    rng.collapse(true);
    sel.removeAllRanges();
    sel.addRange(rng);
    document.execCommand("insertHTML",false,markcaret);
   }
   else
   {
    rng= document.selection.createRange();
    rng.collapse(true);
    rng.pasteHTML(markcaret);
   }
   mark=1;
  }catch(e){;}
 }
 t= ce.innerHTML;
 if(colorflag)
 {
  t=jtfromh(t);
  t=findmark(t);
  // '...' or '...LF or NB....LF or name.
  var r="('[^'\u000A]*['\u000A])|(NB\..*)|([a-zA-Z][a-zA-Z0-9_\u200B]*[\.])";
  t= t.replace(RegExp(r,"g"),colhit);
  t= jhfromt(t);
  t= t.replace(/\u0000/g, "</span>");
  t= t.replace(/\u0001/g, "<span class=\"color1\" style=\"color:red\">");
  t= t.replace(/\u0002/g, "<span class=\"color2\" style=\"color:green\">");
  t= t.replace(/\u0003/g, "<span class=\"color3\"style=\"color:blue\">");
  t= findspan(t);
 }
 else
 {
  t=jtfromh(t);
  t=findmark(t);
  t= jhfromt(t);
  t=findspan(t);
  t=t.replace(/\u0000/g, "</span>");
 }
 rwhat="";
 t= t.replace(/\u200B/,spancaret);
 ce.innerHTML= t;
 if(mark)jsetcaret("caret",0);
}

var numberflag=0;
var spancaret="<span id=\"caret\" class=\"caret\"></span>";

function number()
{
 var t,i,j,b,lines=0;
 if(numberflag)
 {
  t=jtfromh(ce.innerHTML);
  lines=0;
  for(i=0;i<t.length;++i)
   lines+='\n'==t[i];
  t="";
  for(i=0;i<lines;++i)t+=i+"&nbsp;<br>";
  jbyid("num").innerHTML=t;
  jshow("num");
 }
 else
 {
  jbyid("num").innerHTML="";
  jhide("num");
 }
}

function update()
{
 if(colorflag)color();
 if(numberflag)number();
}

function ev_ijs_keypress()
{
 if(jsc||0==jevev.charCode) return true; // ignore shortcuts,arrows,bs,del,enter,etc.
 if(toid!=0)clearTimeout(toid);
 if(colorflag||numberflag)toid=setTimeout(update,100);
 return true;
}

function ev_what_enter(){jscdo("find");}

function ev_refind_click(){jscdo("find");}

function findzwsp(d){return d+"\u200B*";}

function find()
{
 var t=jform.what.value;
 if(0==t.length)return;
 t=t.replace(/./g,findzwsp);
 flags=(jform.matchcase.checked?1:0)?"g":"gi"
 rwhat=RegExp(t,flags);
 color();
}

function ev_find_click()
{
 //!ce.focus(); // IE needs focus before setting caret
 //!jsetcaret("ijs",0);
 find();
}

function ev_findfirst_click(){
 var i,len,nodes;
 find();
 nodes= ce.getElementsByTagName("span");
 len=nodes.length;
 for(i=0;i<len;++i)
 {
  if("mark"==nodes[i].getAttribute("class"))
  {
   jsetcaretx(nodes[i],1);
   return;
  }
 }
}

function ev_findnext_click()
{
 var i,len,nodes,c=0;
 find();
 nodes= ce.getElementsByTagName("span");
 len=nodes.length;
 for(i=0;i<len;++i)
 {
  if("caret"==nodes[i].getAttribute("class"))c=1;
  if(1==c&&"mark"==nodes[i].getAttribute("class"))
  {
   jsetcaretx(nodes[i],1);
   return;
  }
 }
}

// still used by jdoh callers - kill off
function ajax(ts)
{
 rep.innerHTML= ts[0];
 if(2==ts.length&&jform.jmid.value=="saveasx"||jform.jmid.value=="saveasdo")
 {
  jhide("saveasdlg");
  jbyid("filenamed").innerHTML=ts[1];
  jbyid("filename").value=jtfromh(ts[1]);
 }
}

function ev_ijs_enter(){return true;}

function ev_t_shortcut(){jscdo("ro");}
function ev_r_shortcut(){jscdo("runw");}
function ev_s_shortcut(){jscdo("save");}
function ev_2_shortcut(){ce.focus();window.scrollTo(0,0);jsetcaret("ijs",0);}
)
