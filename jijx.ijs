NB. J HTTP Server - jijx app
coclass'jijx'
coinsert'jhs'

HBS=: 0 : 0
jhma''
'studio'   jhmg'studio';1;10
 'jdemo'   jhml'demos'
 'advance' jhmab'advance a^'
 'lab'     jhmab'labs...'
'action'   jhmg'action';1;15
 'projman' jhmab'project manager'
 'debug'   jhmab'Debug'
 jhjmlink''
jhmz''

'log' jhec'<LOG>'

'labsdlg'   jhdivahide'labs:'
 labsel''
 'labsclose'jhb'X'
'</div>'

)

NB.! create causes problems? related to jloging goto create_jijx_
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
if. METHOD-:'post' do. NB. 'true'-:getv'jajax'
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
iphone=. 0<#('iPhone'ss t),'iPod'ss t=. gethv_jhs_ 'User-Agent:'
IP=: iphone NB.! IP global used in BIS for up dn
NB.! pass js parameters through html jhh elements!
JS=: js=.  JSCORE,jsx hrplc 'PROMPT KBSPACE NOARROWS RECALLS';y;iphone;iphone;recalls''
'jijx' jhr 'LOG';LOG
)

getlabs=: 3 : 0
LABTITLES=: LABCATS=: LABFILES=: ''
try.
 t=. jpath'~system/extras/labs'
 for_p. dirpath t do.
  for_q. 1 dir '/*.ijt',~>p do.
  LABFILES=: LABFILES,q
  cat=. (>:#t)}.>q
  cat=. (cat i.'/'){.cat
  LABCATS=:  LABCATS,<cat
  title=. toJ fread q
  title=. (title i.LF){.title
  title=. (>:title i.'''')}.title
  title=. (title i:''''){.title 
  LABTITLES=: LABTITLES,<cat,': ',title
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
if. _1=nc<'LABTITLES' do. getlabs'' end.
'labsel'jhsel LABTITLES;1;0
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
t=. INPUT
t=. t rplc each <'"';'\"';'\';'\\'
t=. t-.each <CRLF
_2}.;'"',each t,each<'",',LF
)

labmsg=: 0 : 0
Open a lab from studio menu.
Open additional labs from link|open. 

Warning: labs not updated for J7
 and may fail in various ways.

Menu studio|advance to advance.
)

labopen=: 3 : 0
require__'~system/util/lab.ijs'
smselout_jijs_=: smfocus_jijs_=: [ NB.! allow introcourse to run
labinit_jlab_ y{LABFILES
)

ev_advance_click=: 3 : 0
if. (<'jlab')e.conl 0 do.  labnext_jlab_'' else. labopen 0 end.
)

ev_labsel_click=: 3 : 0
labopen ".getv'jsid'
)

ev_projman_click=: 3 : 0
'Project Manager not implemented yet.'
)

ev_debug_click=: 3 : 0
'Debug not implemented yet.'
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
var URL= "jijx" // page url - same as j app
var reci= -1;
var recs= [<RECALLS>];
var kbspace= <KBSPACE>;
var noarrows= <NOARROWS>;
var flip= 0; // kill off
var phead= '<div id="prompt" class="log">';
var ptail= '</div>';

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

function scrollz(){window.scrollTo(0,1000000);}

function ev_2_shortcut(){jbyid("log").focus();scrollz();jsetcaret("prompt",1);}
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

function evload()
{
 jbyid("log").focus();
 newpline("   ");
}

function keyp(){jbyid("kbsp").style.display= "block";scrollz();return true;} // space for screen kb

function ev_up_click(){uarrow();}
function ev_dn_click(){darrow();}

function ev_log_keypress(){return true;}

// log enter - contenteditable
// run line with caret
// do not know how to handle multiple-line selection - ignore selection for now
function ev_log_enter()
{
 var t,sel,rng,tst,n,a,i,p,recall=0;
 p= jbyid("prompt");
 if (window.getSelection)
 {
  sel= window.getSelection();
  rng= sel.getRangeAt(0);
  t= rng.toString();
  if(0!=t.length) return; //! ignore selection for now cause we do not get LF
  rng.setStartBefore(rng.startContainer,0); // extend selection to line
  rng.setEndAfter(rng.endContainer);
  t= rng.toString();
  t= t.replace(/\u00A0/g," "); // &nbsp;

  // last line exec vs old line recall
  if(null!=p)
  {
   tst= rng.cloneRange();
   tst.selectNode(p);
   tst.collapse(true);
   recall= -1!=tst.compareBoundaryPoints(tst.END_TO_END,rng);
  }
 }
 else
 {
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
  // last line exec vs old line recall
  if(null!=p)
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
  jdo(t,true,[]);
 }
}

function ev_advance_click(){jdoh([]);}
function ev_lab_click(){jshow("labsdlg");jbyid("labsel").focus();}
function ev_labsclose_click(){jhide("labsdlg");}

function ev_labsel_click()
{
 jhide("labsdlg");
 jform.jsid.value= jbyid("labsel").selectedIndex;
 jdoh([]);
}

function ev_projman_click(){jdoh([]);}
function ev_debug_click(){jdoh([])}

)


