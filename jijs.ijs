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
 'fif'     jhmab'find...     q^'
 'refind'  jhmab'refind      w^'
 'refindf' jhmab'refind fif  e^'
'option'    jhmg'option';1;8
 'ro'      jhmab'readonly    t^'
 'color'   jhmab'color       c^'
 'number'  jhmab'number      n^'
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

'fifdlg'     jhdivahide'find'
 'what'      jht'';10
 'context'   jhselne(<;._2 FIFCONTEXT_jfif_);1;0
 'matchcase' jhckbne'case';'matchcase';1
 'find'      jhb'find'
 'fifclose'  jhb'X'
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

NB. data what contextndx case
ev_find_click=: 3 : 0
'data what ndx case'=. <;._2 getv'jdata'
'c q'=. data ffssijs_jfif_ what;(".ndx);(".case) 
jhrajax (":#q),' lines with ',(":c),' hits',JASEP,":q
)

NB. refind in data based on FiF values
ev_refindf_click=: 3 : 0
data=. }:getv'jdata'
'c q'=. data ffssijs_jfif_ FIFWHAT_jfif_;FIFCONTEXT_jfif_;FIFCASE_jfif_ 
jhrajax (":#q),' lines with ',(":c),' hits',JASEP,":q
)

NB.! p{} klduge cause IE insert <p> instead of <br> for enter
CSS=: 0 : 0
#rep{color:red}
#filenamed{color:blue;}
*{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
p{margin:0;}
)

JS=: 0 : 0
var ta,rep,readonly,colorflag,saveasx,replx,toid=0;

function evload() // body onload->jevload->evload
{
 ce= jbyid("ijs");
 rep= jbyid("rep");
 ta= jbyid("textarea");
 saveasx=jbyid("saveasx");
 replx=jbyid("replx");
 reply=jbyid("reply");
 ro(0!=ce.innerHTML.length);
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

function ev_saveasx_enter(){click();}
function ev_saveas_click()     {jdlgshow("saveasdlg","saveasx");}
function ev_saveasclose_click(){jhide("saveasdlg");}

function ev_replx_enter(){;}
function ev_reply_enter(){;}
function ev_replace_click()  {jdlgshow("repldlg","replx");}
function ev_replclose_click(){jhide("repldlg");}

function ev_fif_click(){jdlgshow("fifdlg","what");}

function ev_fifclose_click(){jhide("fifdlg");}

function repl(x,y)
{
 var d=jtfromh(ce.innerHTML);
 d=d.replace(RegExp(x,"g"),y);
 ce.innerHTML=jhfromt(d);
}

function ev_repldo_click()  {repl(replx.value,reply.value);}
function ev_replundo_click(){repl(reply.value,replx.value);}

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

function ev_c_shortcut(){jscdo("click");}
function ev_n_shortcut(){jscdo("number");}
function ev_q_shortcut(){jscdo("fif");}
function ev_w_shortcut(){jscdo("refind");}
function ev_e_shortcut(){jscdo("refindf");}

function colcs(d) {return "\u0001"+d+"\u0000";}  // control structure
function colnb(d) {return "\u0002"+d+"\u0000";}  // nb
function collit(d){return "\u0003"+d+"\u0000";} // literal

var controls= RegExp("(assert|break|continue|for|if|do|else|elseif|end|return|select|case|fcase|throw|try|catch|while|whilest)\\.","g");

var markcaret="&#8203;"; // \u200B

//! coloring needs lots of work
// literals not closed - for_abc. - etc.
// caret is preserved by
//  inserting ZWSP, manipulating, ZWSP to span id, selecting span id
// recolor or uncolor
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
  t= jtfromh(t);
  t= t.replace(/NB\..*/g, colnb)
  t= t.replace(controls,  colcs);
  t= t.replace(/'[^']*'/g, collit);
  t= jhfromt(t);
  t= t.replace(/\u0009/,  "<span id=\"selection\"></span>");
  t= t.replace(/\u0000/g, "</span>");
  t= t.replace(/\u0001/g, "<span style=\"color:red\">");
  t= t.replace(/\u0002/g, "<span style=\"color:green\">");
  t= t.replace(/\u0003/g, "<span style=\"color:blue\">");
 }
 else
 {
  t= t.replace(/<span\/?[^>]+(>|$)/gi,"");
  t= t.replace(/<\/span>/gi,"");
 }
 t= t.replace(/\u200B/,"<span id=\"caret\"></span>");
 ce.innerHTML= t;
 if(mark)jsetcaret("caret",0);
}

var numberflag=0;
var numbermark=[];

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
  for(i=0;i<lines;++i)
  {
   b=0;
   for(j=0;j<numbermark.length;++j)
    b|=i==numbermark[j];
   if(b)
    t+="<span style=\"color:red\">"+i+":&nbsp;</span><br>";
   else
    t+=i+":&nbsp;<br>";
  }
 }
 else
  t="";
 jbyid("num").innerHTML=t;
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

function ev_find_click()
{
 var t=jtfromh(ce.innerHTML)+JASEP;
 t+=jform.what.value+JASEP;
 t+=jform.context.selectedIndex+JASEP;
 t+=(jform.matchcase.check?1:0)+JASEP;
 jdoa(t); // data what contextndx case
}

function ev_find_click_ajax(ts)
{
 rep.innerHTML=ts[0];
 if(0==ts[1].length)
  numbermark=[];
 else
 {
  var t=ts[1].split(" ");
  numbermark=new Array(t.length);
  for(var i=0;i<t.length;++i)
   numbermark[i]=t[i]-0;
 }
 numberflag=1;
 number();
}

function ev_refind_click(){jscdo("find");}
function ev_refindf_click(){jdoa(jtfromh(ce.innerHTML)+JASEP);}
function ev_refindf_click_ajax(ts){ev_find_click_ajax(ts);}

// still used by jdoh callers - kill off
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
function ev_r_shortcut(){jscdo("runw");}
function ev_s_shortcut(){jscdo("save");}
function ev_2_shortcut(){ce.focus();window.scrollTo(0,0);jsetcaret("ijs",0);}
)
