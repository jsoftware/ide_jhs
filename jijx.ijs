NB. J HTTP Server - jijx app
coclass'jijx'
coinsert'jhs'

LABFILE=: ''

NB.! why isn't this create?
jev_get=: 3 : 'i.0 0'

NB. move new transaction(s) to log
uplog=: 3 : 0
LOG_jhs_=: LOG,LOGN
LOGN_jhs_=: ''
)

NB. y is J prompt - '' '   ' or '      '
NB. called at start of input
NB. ff/safari/chrome have problems with empty prompt div
NB. empty prompt is &bull; which is removed if present from input
urlresponse=: 3 : 0
if. 0=#y do.
 t=. '&bull;'
else.
 t=. (6*#y)$'&nbsp;'
end.
t=. '<div id="prompt" class="log">',t,'</div>'
NB. LOGN_jhs_=: LOGN,t
d=. LOGN,t
uplog''
if. METHOD-:'post' do. NB. 'true'-:getv'jajax'
 htmlresponse d,~hajax rplc '<LENGTH>';":#d
else.
 create y,t
end.
)

B=: 0 : 0 NB. body template
body
jma
 up dn
 studio demo advance labs
 tool   projman pacman debug
 link   jmijs jmijx jmfile jmlogin jmhelp
jmz
form
'</form>'
'<div id="log" contenteditable=true autocomplete="off" autocapitalize="off" spellcheck="false" onkeydown="return jev(''log'',''enter'',event)">'
 '<LOG>'
 '<div id="logz"></div>'
'</div>'
'<div id="kbspace" style="display:none;height:120px"></div>'
'</body>'
)

BFLIP=: 0 : 0 NB. body template with push down log
body
form
lab jsep up + dn jsep jdemo+jal jsep jide
jsentence
'</form>'
'<LOG>'
'</body>'
)

BIS=: 0 : 0 NB. body template id-sentence pairs
jsentence ht'';40
form      hform''
body      '<body onload="jevload();">'
up       >IP{' ';hmga'up'
dn       >IP{' ';hmga'dn'
studio   hmg'studio'
 demo     'jdemo'hml'demo';''
 advance  hmab'advance';''
 labs     labs''
tool     hmg'tool'
 projman  hmab'project manager';''
 pacman   'jal'hml'package manager';''
 debug    hmab'Debug';''
link     hmg'link' 
)

labs=: 3 : 0
t=.   'lab0'hmab'open Introduction';''
t=. t,'lab1'hmab'open Idiosyncratic';''
t=. t,'lab2'hmab'open Taste 1';''
t=. t,'lab3'hmab'open Taste 2';''
t=. t,'lab4'hmab'open Course';''
)
 

NB. -3px aligns input text with output text
CSS=: 0 : 0
*{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
#jsentence{width:99%; margin:3px 3px 3px -3px}
form{margin-top:0;margin-bottom:0;}
)

NB. refresh response - not jajax
NB. mac safari input text ghost images are pushed up by ajax output
NB. kludge fix of margin:3px fixes the problem
NB. the margin requires reducing width to 99 to avoid hitting the right edge
create=: 3 : 0
iphone=. 0<#('iPhone'ss t),'iPod'ss t=. gethv_jhs_ 'User-Agent:'
IP=: iphone NB.! IP global used in BIS for up dn
js=.  JSCORE,jsx hrplc 'PROMPT KBSPACE NOARROWS RECALLS';y;iphone;iphone;recalls''
NB.! b=. >iphone{B;BFLIP
b=. (B getbody BIS)hrplc 'LOG';LOG
hr 'jijx';(css CSS,cssfontcolors'');js;b
)

NB.! kill off flip as soon as confident kbspace is the way to go
fliplog=: 3 : ';|.(markprompt E. y) <;.1 y'

recalls=: 3 : 0
t=. INPUT
t=. t rplc each <'"';'\"';'\';'\\'
t=. t-.each <CRLF
_2}.;'"',each t,each<'",',LF
)

NB. mtyo class font colors
cssfontcolors=: 3 : 0
t=.   ' *.fm   {color:',PC_FM_COLOR,  ';}',LF
t=. t,' *.er   {color:',PC_ER_COLOR,  ';}',LF
t=. t,' *.log  {color:',PC_LOG_COLOR, ';}',LF
t=. t,' *.sys  {color:',PC_SYS_COLOR, ';}',LF
t,' *.file {color:',PC_FILE_COLOR,';}',LF
)

labmsg=: 0 : 0
Open a lab from studio menu.
Open additional labs from link|open. 

Warning: labs not updated for J7
 and may fail in various ways.

ctrl+. to advance (studio|advance)
)

labopen=: 3 : 0
require__'~system/util/lab.ijs'
LABFILE_jijx_=: jpath'~system/extras/labs/language/',y,'.ijt'
smselout_jijs_=: smfocus_jijs_=: [ NB.! allow introcourse to run
smoutput 'Lab opened: advance with studio|advance or ctrl+.'
)

ev_lab0_click=: 3 : 'labopen''j'''
ev_lab1_click=: 3 : 'labopen''intro'''
ev_lab2_click=: 3 : 'labopen''jtaste1'''
ev_lab3_click=: 3 : 'labopen''jtaste2'''
ev_lab4_click=: 3 : 'labopen''introcourse'''

ev_advance_click=: 3 : 0
if. (<'jlab')e.conl 0 do.
 if. LABFILE-:'' do.
  labnext_jlab_''
 else.
  labinit_jlab_ LABFILE
  LABFILE=: ''
 end.
else.
 labopen'j'
end.
)

ev_projman_click=: 3 : 0
'Project Manager not implemented yet.'
)

ev_debug_click=: 3 : 0
'Debug not implemented yet.'
)



jsx=: hjs 0 : 0
//! issues
/*
ff/safari/chrome f=: 3 : 0 has trouble with empty prompt div
kludge for now is to prompt with &bull; and drop it from input

ff input log does not get the blanks from the prompt
so log lines have no indent - no kludge yet

*/

var URL= "jijx" // page url - same as j app
var reci= 0;
var recs= [<RECALLS>];
var kbspace= <KBSPACE>;
var noarrows= <NOARROWS>;
var flip= 0; // kill off
var phead= '<div id="prompt" class="log">'
var ptail= '</div>'

function updatelog(t)
{
 var n= document.createElement("div");
 n.innerHTML= t;

 // remove prompt line - before adding log and result
 // try because it once was possible to fail, perhaps no longer necessary
 try{var p= jbyid("prompt");p.parentNode.removeChild(p);}catch(e){;}
 jbyid("log").appendChild(n);

 if (window.getSelection)
 {
  var sel= window.getSelection();
  var rng = document.createRange(); // remove kills old - no rangeat 
  rng.selectNode(jbyid("prompt"));
  sel.removeAllRanges();
  sel.addRange(rng);
  // ff multiple selections - does not set caret
  sel.collapse(jbyid("prompt"),true); 
 }
 else
 {
  //IE set caret at end
  var ierng= document.selection.createRange();
  ierng.expand("textedit");
  ierng.collapse(false);
  ierng.moveStart("character",-3); //! ugh need to back up to make visible (CRLF????)
  ierng.moveEnd("character",-3);
  ierng.select();
 }
 setTimeout(scrollin,1); // allow doc to update
}

// ajax update window with new output
function rqupdate()
{
 var t= rq.responseText;
 updatelog(t);
 if(-1!=t.indexOf("<!-- refresh -->"))location="jijx"; //!
}

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

function scrollin(){window.scrollTo(0,1000000);}

function doshortcut(c)
{
 switch(c)
 {
  default: dostdshortcut(c); break;
 }
}

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
 updatelog(phead+"&nbsp;&nbsp;&nbsp;"+ptail);
}

function keyp(){jbyid("kbsp").style.display= "block";scrollin();return true;} // space for screen kb

function ev_up_click(){uarrow();}
function ev_dn_click(){darrow();}

// log enter - contenteditable
// run line with caret
// do not know how to handle multiple-line selection - ignore selection for now
function ev_log_enter()
{
 var t,sel,rng,n,a,i;
 if (window.getSelection)
 {
  sel= window.getSelection();
  rng= sel.getRangeAt(0);
  t= rng.toString();
  if(0!=t.length) return; // ignore selection for now
  rng.setStart(rng.startContainer,0); // extend selection to line
  rng.setEndAfter(rng.endContainer);
  t= rng.toString(); //! ff does not see prompt blanks
  t= t.replace(/\u00A0/g," "); // &nbsp;
 }
 else
 {
  sel= document.selection.createRange();
  t= sel.text;
  if(0!=t.length) return; // ignore selection for now
  // IE -  move left until CR or NaN - move right til no change
  while(1) 
  {
    sel.moveStart('character',-1);
    t= sel.text;
    if(t.charAt(0)=='\r'||isNaN(t.charCodeAt(0))){sel.moveStart('character',1); break;}
  }
  while(1) 
  {
    n= sel.text.length; // no size change for CRLF
    sel.moveEnd('character',1);
    if(n==sel.text.length){sel.moveEnd('character',-1); break;}
  }
  t= sel.text;
 }
 addrecall(t);
 jdo(t,true,[]);
}


// menu handlers
function ev_studio_click(){menuclick()}
function ev_tool_click(){menuclick();}
function ev_link_click(){menuclick();}

function sdo(){jdoh([]);}

function ev_lab0_click(){sdo();}
function ev_lab1_click(){sdo();}
function ev_lab2_click(){sdo();}
function ev_lab3_click(){sdo();}
function ev_lab4_click(){sdo();}
function ev_advance_click(){sdo();}

function ev_projman_click(){sdo();}
function ev_debug_click(){sdo();}

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
