NB. J HTTP Server - jijx app
coclass'jijx'
coinsert'jhs'

HBS=: 0 : 0
jhma''
'studio'   jhmg'studio';1;10
 'jdemo'   jhml'demos'
 'advance' jhmab'advance a^'
 'lab'     jhmab'labs...'
 actionmenu''
 debugmenu''
 jhjmlink''
jhmz''

'scratchdlg' jhdivadlg''
'scratcharea'jhtextarea''
'</div>'

'labsdlg'   jhdivadlg''
 'labrun'   jhb'run'
 labsel''
 'labsclose'jhb'X'
'</div>'
jhresize''

'log' jhec'<LOG>'

'recalls'jhhidden'<RECALLS>'
)

jev_get=: 3 : 'i.0 0'

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
t=. '<div id="prompt" class="log">',t,'</div>'
d=. LOGN,t
uplog''
if. METHOD-:'post' do.
 jhrajax d
else.
 create''
end.
)

NB. refresh response - not jajax
NB. mac safari input text ghost images are pushed up by ajax output
NB. kludge fix of margin:3px fixes the problem
NB. the margin requires reducing width to 99 to avoid hitting the right edge
create=: 3 : 0
NB.! iphone=. 0<#('iPhone'ss t),'iPod'ss t=. gethv_jhs_ 'User-Agent:'
JS=: js=.  JSCORE,jsdebug,~jsx
'jijx' jhr 'LOG RECALLS';LOG;recalls''
)

getlabs=: 3 : 0
LABTITLES=: LABCATS=: LABFILES=: ''
d=. dirpath t=. jpath'~addons/labs'
if. 1=#d do. d=. dirpath t=. jpath'~system/extras/labs' end. NB.! old location
try.
 for_p. d do.
  for_q. 1 dir '/*.ijt',~>p do.
  LABFILES=: LABFILES,q
  cat=. (>:#t)}.>q
  cat=. (cat i.'/'){.cat
  LABCATS=:  LABCATS,<cat
  title=. toJ fread q
  title=. (title i.LF){.title
  title=. (>:title i.'''')}.title
  title=. (title i:''''){.title 
  LABTITLES=: LABTITLES,<title NB.! cat,': ',
  end.
 end.
catch.
end.
s=. /:LABTITLES
LABFILES=:  s{LABFILES
LABCATS=:   s{LABCATS
LABTITLES=: s{LABTITLES
)

labsel=: 3 : 0
getlabs''
'labsel'jhselect LABTITLES;1;0
)

updn=: 3 : 0
if. IP do. hmga y else. ' ' end.
)

jvm__=: 3 : 0
try. require'viewmat'
catch. 
 'Viewmat not installed. Use JAl to install:',LF,' graphics/viewmat and graphics/bmp'
 return.
end.
ifRGB_jviewmat_=: 0 NB.!
t=. (<6#16)#: each <"0>1{''getvm_jviewmat_ y
t=. '#',each t{each <'0123456789abcdef'
a=. (<'<font ',LF,'style="background-color:'),each t
a=. a,each (<'; color:'),each t
a=. a,each <';">ww</font>'
jhtml ;a,.<'<br>'
)

recalls=: 3 : 0
t=.INPUT
t=.(0~:;#each t-.each' ')#t
(;t,each LF)rplc <'"';'\"';'\';'\\'
)

labmsg=: 0 : 0
Open a lab from studio menu.
Open additional labs from link|open. 

Warning: labs not updated for J7
 and may fail in various ways.

Menu studio|advance to advance.
)

labopen=: 3 : 0
require__'~addons/labs/lab.ijs'
smselout_jijs_=: smfocus_jijs_=: [ NB.! allow introcourse to run
labinit_jlab_ y{LABFILES
)

ev_advance_click=: 3 : 0
if. (<'jlab')e.conl 0 do.  labnext_jlab_'' else. labopen 0 end.
)

ev_labrun_click=: 3 : 0
labopen ".getv'jsid'
)

jloadnoun__=: 0!:100

ev_scratchr_click=: 3 : 0
try. jloadnoun__ getv'scratcharea' catch. 13!:12'' end.
)

actionmenu=: 3 : 0
a=. 'action'   jhmg'action';1;10
a=. a,'scratch' jhmab'scratch...'
a=. a,'scratchr'jhmab'scratch r^'
try.
 load'~user/projects/ja/ja.ijs'
 amenu=: <;._2 ja_menu
 t=. a
 for_i. i.#amenu do.
  t=. t,('actionn*',":i)jhmab(>i{amenu),>(i<3){'';' ',(i{'qwe       '),'^'
 end.
catch.
 t=. a
end.
t 
)


ev_action_click=:  3 : 0
smoutput 'see help ijx menu action for customization info'
)

action=: 3 : 0
".'''''',~'ja_',(>y{amenu),'_base_'
)

ev_actionn_click=: 3 : 0
action ".getv'jsid'
)

CSS=: 0 : 0
*{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
form{margin-top:0;margin-bottom:0;}
*.fm   {color:<PC_FM_COLOR>;}
*.er   {color:<PC_ER_COLOR>;}
*.log  {color:<PC_LOG_COLOR>;}
*.sys  {color:<PC_SYS_COLOR>;}
*.file {color:<PC_FILE_COLOR>;}
)

NB. *#log:focus{border:1px solid red;}
NB. *#log:focus{outline: none;} /* no focus mark in chrome */

jsx=: 0 : 0
var recs;
var reci= -1;
var phead= '<div id="prompt" class="log">';
var ptail= '</div>';

function evload()
{
 var t=jbyid("recalls").value;
 if(0==t.length)
  recs=[];
 else
  recs=t.split("\n");
 jbyid("scratcharea").style.width="100%";
 jbyid("scratcharea").setAttribute("rows","8");
 jbyid("log").focus();
 newpline("   ");
 jresize();
}

function updatelog(t)
{
 var p,parent,n= document.createElement("div");
 n.innerHTML= t;

 // remove all prompts - normally 1 but could be none or multiples
 // remove parent it removal of prompt empties it
 while(1)
 {
  p= jbyid("prompt");
  if(null==p) break;
  parent= p.parentNode;
  parent.removeChild(p);
  if(0==parent.childNodes.length) parent.parentNode.removeChild(parent);
 }
 jbyid("log").appendChild(n);
 jbyid("log").focus(); // required by FF ???
 jsetcaret("prompt",1);
 setTimeout(scrollz,1); // allow doc to update
}

// ajax update window with new output
function ajax(ts){updatelog(ts[0]);}

// add sentence to log unless blank or same as last
function addrecall(a)
{
 var i,blank=0,same=0;
 for(i=0;i<a.length;++i)
  blank+= ' '==a.charAt(i);

 if(0!=recs.length && a.length==recs[0].length)
 {
  for(i=0;i<a.length;++i)
   same+= a.charAt(i)==recs[0].charAt(i);
 }

 if(blank!=a.length && same!=a.length)
  recs.unshift(a); reci=-1; // recalls
}

function scrollz(){jbyid("prompt").scrollIntoView(false);}

function ev_2_shortcut(){jbyid("log").focus();scrollz();jsetcaret("prompt",1);}
function ev_3_shortcut(){jbyid("scratcharea").focus();}
function ev_a_shortcut(){jscdo("advance");}

function newpline(t)
{
 t= t.replace(/&/g,"&amp;");
 t= t.replace(/</g,"&lt;");
 t= t.replace(/>/g,"&gt;");
 t= t.replace(/ /g,"&nbsp;");
 t= t.replace(/-/g,"&#45;");
 t= t.replace(/\"/g,"&quot;");
 updatelog(phead+t+ptail);
}

function uarrow()
{
 if(++reci>=recs.length) reci= recs.length-1;
 if(reci==-1)
  newpline("   ");
 else
  newpline(recs[reci]);
}

function darrow()
{
 var t;
 if(--reci<0)
  {reci= -1; t= "   ";}
 else
  t= recs[reci]
 newpline(t);
}

function keyp(){jbyid("kbsp").style.display= "block";scrollz();return true;} // space for screen kb

function ev_up_click(){uarrow();}
function ev_dn_click(){darrow();}

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
  addrecall(t);
  jdoajax([],"",t);
 }
}

function ev_advance_click(){jdoajax([],"");}

function ev_lab_click(){jdlgshow("labsdlg","labsel");}
function ev_labsclose_click(){jhide("labsdlg");}

function ev_scratch_click(){jdlgshow("scratchdlg","scratcharea");}
function ev_scratchclose_click(){jhide("scratchdlg");}

function ev_scratchr_click(){jdoajax(["scratcharea"],"");}

function ev_r_shortcut(){jscdo("scratchr");}

function ev_labrun_click()
{
 jhide("labsdlg");
 jform.jsid.value= jbyid("labsel").selectedIndex;
 jdoajax([],"");
}

function ev_actionn_click(){jdoajax([],"");}

function ev_q_shortcut(){jscdo("actionn","0");}
function ev_w_shortcut(){jscdo("actionn","1");}
function ev_e_shortcut(){jscdo("actionn","2");}
)


