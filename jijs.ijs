NB. J HTTP Server - ijs app
coclass'jijs'
coinsert'jhs'

jev_get=: 3 : 0
create jnew''
) 

B=: 0 : 0 NB. body template
'<div id="a">'
 jma action ro save saveas findrep
     run    runw runwd
     jmlink
 jmz
 report
filename filenamed
'</div>'
htmlarea
textarea
)

NB.! padding should be related to textarea

BIS=: 0 : 0 NB. body template id-sentence pairs
action   hmg'action'
 ro       hmab'readonly';'t'
 save     hmab'save';'&nbsp;&nbsp;&nbsp;&nbsp;s'
 saveas   hmab'save as';''
 findrep  hmab'find';''
run      hmg'run'
 runw     hmab'window';'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;r'
 runwd    hmab'window display';''
report    '<div id="rep"></div>'
filename  hh'<FILENAME>'
filenamed '<div id="filenamed">[<span id="status">0</span>] <FILENAME></div>'
synhi     hradio'syntax';'radg'
edit      hradio'edit';'radg'
textarea  htarea'<DATA>'
htmlarea  '<div id="c" style="display:none;padding-top:4px;padding-left:3px;"><SYNHIDATA></div>'
)

createbody=: 3 : 0
(B getbody BIS)hrplc y
)

CSS=: 0 : 0
#rep{color:red}
#filenamed{color:blue;}
textarea{width:100%;}
*{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
)

NB. y if fullfilename
create=: 3 : 0
try. d=. 1!:1<y catch. d=. 'file read failed' end.
hr (getfile y);(css CSS);(JSCORE,JS);createbody 'FILENAME DATA SYNHIDATA';y;d;synhi d
)

save=: 3 : 0
if. #USERNAME do.
 fu=. jpath'~user'
 'save only allowed to ~user paths' assert fu-:(#fu){.y
end.
(toHOST getv'textarea')1!:2<y
)


ev_save_click=: 3 : 0
f=. jpath getv'filename'
try.
 save f
 ajaxresponse 'saved without error'
catch.
 ajaxresponse htmlfroma 13!:12''
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
 ajaxresponse 'ran saved without error'
catch.
 ajaxresponse htmlfroma 13!:12''
end.
)

ev_runwd_click=: ev_runw_click

ev_ro_click=: 3 : 0
ajaxresponse synhi getv'textarea'
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

getfile=: 3 : '(>:y i: PS)}.y' NB. filename from fullname

JS=: hjs 0 : 0
window.onresize= resize;
window.onfocus= xfocus;
var saved,ta,status,readonly;

function evload() // body onload->jevload->evload
{
 ta= document.j.textarea;
 status = jbyid("status");
 ta.onmouseup= ta.onkeydown= reqlineup;
 resize();
 saved= ta.value;
 if(0==saved.length)
 {
  readonly= false;
  jbyid("c").style.display= "none";
  ta.style.display= "block";
  ta.focus();
 }
 else
 {
  readonly= true;
  ta.style.display= "none";
  jbyid("c").style.display= "block";
  jbyid("ro").innerHTML= "editable"; 
 }
}

function xfocus(){if(ta.style.display=="block")ta.focus();}

function ctrl_comma(){jev("runw","click");}
function ctrl_dot()  {jev("save","click")}
function ctrl_slash(){jev("ro","click")}

function ev_save_click(){jdoh(["filename","textarea"]);}
function ev_runw_click(){jdoh(["filename","textarea"]);}
function ev_runwd_click(){jdoh(["filename","textarea"]);}

function ev_saveas_click(){jbyid("rep").innerHTML= "save as not implemented";}
function ev_findrep_click(){jbyid("rep").innerHTML= "find/replace not implemented";}

// toggle readonly
function ev_ro_click()
{
 readonly= !readonly;
 if(readonly)
 {
  jdoh(["filename","textarea"]);
  jbyid("ro").innerHTML= "editable"; 
 }
 else
 {
  jbyid("c").style.display= "none";
  ta.style.display= "block";
  ta.focus();
  jbyid("ro").innerHTML= "readonly"; 
 }
}

function rqupdate()
{
 if(jform.jmid.value=="ro")
 {
  ta.style.display= "none";
  jbyid("c").style.display= "block";
  jbyid("c").innerHTML= rq.responseText;
 }
 else
  jbyid("rep").innerHTML= rq.responseText;
}

function resize(){
 var a= gpwindowh();      // window height
 a-= gpbodymh();          // body margin h (top+bottom)
 a-= gpdivh("a");         // div a height
 a-= 10;                   // div and textarea borders???
 a=  a<10?0:a;            // - not allowed
 ta.style.height= a+"px"; // size ta to fit
}

// menu hide/show

function mc(){jbyid("rep").innerHTML= ""; menuclick();}
function ev_run_click()   {mc();}
function ev_action_click(){mc();}
function ev_jmlink_click(){mc();}

// ta line status

var tid=0; // timeout id

function reqlineup()
{
 if(tid!=0) clearTimeout(tid);
 tid= setTimeout(lineup,50)
}

function lineup(){tid=0; jbyid("status").innerHTML= gettaline(ta);}

// get line number for textarea selection
function gettaline(ta)
{ 
 var t,n,sel,r= 0;
 if(ta.selectionStart!=null) //! !=null required by safari/chrome?
 {
  t= ta.value;
  n= ta.selectionStart; 
 }
 else if(document.selection)
 {
  var m= "\001";
  sel= document.selection.createRange();
  sel.collapse(); 
  sel.text= m;
  t= ta.value;
  n= t.indexOf(m);
  if(n==-1) n= t.length;
  sel.moveStart('character',-1); 
  sel.text= ""; 
 }
 else
  return 0;

 for(var i=0;i<n;++i)
 {
  if(t.charAt(i)=='\n') ++r;
 }
 return r; 
} 

function doshortcut(c)
{
 switch(c)
 {
  case 'r': setshortcut("runw");ev_runw_click(); break;
  case 's': setshortcut("save");ev_save_click(); break;
  case 't': setshortcut("ro");ev_ro_click(); break;
  default: dostdshortcut(c); break;
 }
}



)


