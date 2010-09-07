NB. J HTTP Server - ijs app
coclass'jijs'
coinsert'jhs'

HBS=: 0 : 0
jhma''
'run'      jhmg'run';1;12
 'runw'    jhmab'run         r^'
 'runwd'   jhmab'run display'
'action'   jhmg'action';1;10
 'save'    jhmab'save        s^'
 'saveas'  jhmab'save as...'
 'replace' jhmab'replace...'
'style'    jhmg'style';1;6
 'ro'      jhmab'readonly    t^'
 'color'   jhmab'color       c^'
jhjmlink''
jhmz''

'saveasdlg'   jhdivahide'save as'
 'saveasx'    jht'';10
  'saveasclose'jhb'X'
'<hr></div>'

'repldlg'     jhdivahide'replace'
 'replx'      jht'';10
  'with'
   'reply'      jht'';10
    'repldo'     jhb'replace'
     'replundo'   jhb'undo'
      'replclose'  jhb'X'
'<hr></div>'

'rep'         jhdiv''

'filename'    jhh  '<FILENAME>'
'filenamed'   jhdiv'<FILENAME>'

'ijs'         jhec'<DATA>'

'textarea'    jhh''
)

NB. y file
create=: 3 : 0
try. d=. 1!:1<y catch. d=. 'file read failed' end.
(jgetfile y) jhr 'FILENAME DATA';y;jhfroma d
)

jev_get=: 3 : 'create jnew'''''

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
var ta,rep,readonly,color,saveasx,replx;

function evload() // body onload->jevload->evload
{
 ce= jbyid("ijs");
 rep= jbyid("rep");
 ta= jbyid("textarea");
 saveasx=jbyid("saveasx");
 replx=jbyid("replx");
 ro(0!=ce.innerHTML.length);
 ce.focus();
 jsetcaret("ijs",0);
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

function ev_saveasx_enter(){click();}
function ev_saveas_click()     {jshow("saveasdlg");saveasx.value="";saveasx.focus();}
function ev_saveasclose_click(){jhide("saveasdlg");}

function ev_replx_enter(){;}
function ev_reply_enter(){;}
function ev_replace_click()  {jshow("repldlg");replx.focus();}
function ev_replclose_click(){jhide("repldlg");}

//function repl(x,y)
function repl(x,y)
{
 var d=jtfromh(ce.innerHTML);
 d=d.replace(RegExp(x,"g"),y);
 ce.innerHTML=jhfromt(d);
}

function ev_repldo_click()  {repl(replx.value,reply.value);}
function ev_replundo_click(){repl(reply.value,replx.value);}

function ev_ro_click(){ro(readonly= !readonly);}

function colcs(d) {return "\0001"+d+"\0000";}  // control structure
function colnb(d) {return "\0002"+d+"\0000";}  // nb
function collit(d){return "\0003"+d+"\0000";} // literal

var controls= RegExp("(assert|break|continue|for|if|do|else|elseif|end|return|select|case|fcase|throw|try|catch|while|whilest)\.","g");

//! coloring needs lots of work
// literals with '' and not closed
// for_abc. not colored
// consider doing coloring from kpress set timer event
//  should work well except for nasty problem of preserving caret
// loses focus and caret
function ev_color_click()
{
 var t;
 color= !color;
 t= ce.innerHTML;
 if(color)
 {
  t= jtfromh(t);
  t= t.replace(/NB\..*/g, colnb)
  t= t.replace(controls,  colcs);
  t= t.replace(/'[^']*'/g, collit);
  t= jhfromt(t);
  t= t.replace(/\0000/g, "</span>");
  t= t.replace(/\0001/g, "<span style=\"color:red\">");
  t= t.replace(/\0002/g, "<span style=\"color:green\">");
  t= t.replace(/\0003/g, "<span style=\"color:blue\">");
 }
 else
 {
  t= t.replace(/<span\/?[^>]+(>|$)/gi,"");
  t= t.replace(/<\/span>/gi,"");
 }
 ce.innerHTML= t;
 jsetcaret("ijs",0);
}

function ajax(ts)
{
 rep.innerHTML= ts[0];
 if(jform.jmid.value=="saveasx"&&2==ts.length)
 {
  jhide("saveasdlg");
  jbyid("filenamed").innerHTML=ts[1];
  jbyid("filename").value=jtfromh(ts[1]);
 }
}

function ev_ijs_enter(){return true;}

function ev_t_shortcut(){jscdo("ro");}
function ev_c_shortcut(){jscdo("color");}
function ev_r_shortcut(){jscdo("runw");}
function ev_s_shortcut(){jscdo("save");}
function ev_2_shortcut(){ce.focus();window.scrollTo(0,0);jsetcaret("ijs",0);}
)
