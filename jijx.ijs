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
urlresponse=: 3 : 0
d=. LOGN
uplog''
if. METHOD-:'post' do. NB. 'true'-:getv'jajax'
 htmlresponse d,~hajax rplc '<LENGTH>';":#d
else.
 create y
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
'<LOG>'
form
jsentence
'</form>'
'<div id="kbspace" sytle="display:none"></div>'
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
js=.  JSCORE,jsx hrplc 'PROMPT FLIP NOARROWS RECALLS';y;iphone;iphone;recalls y
b=. >iphone{B;BFLIP
b=. (b getbody BIS)hrplc 'LOG';LOG
hr 'jijx';(css CSS,cssfontcolors'');js;b
)

fliplog=: 3 : ';|.(markprompt E. y) <;.1 y'

recalls=: 3 : 0
t=. y;INPUT
t=. t rplc each <'"';'\"';'\';'\\'
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
var URL= "jijx" // page url - same as j app
var reci= 0;
var recs= [<RECALLS>];
var s;
var flip= <FLIP>;
var noarrows= <NOARROWS>;

window.onfocus= refocus;

// ajax update window with new output
function rqupdate()
{
 var n= document.createElement("div");
 var t= rq.responseText;
 n.innerHTML= t;
 var f=document.getElementById("j");
 if(flip)
  f.parentNode.insertBefore(n,f.nextSibling ); // insertAfter(n,f);
 else
  document.body.insertBefore(n,f);
 // prompt '' '   ' '      ' in parens in last html comment
 s.value= t.substring(1+t.lastIndexOf("("),t.lastIndexOf(")"));
 setTimeout(scrollin,1); // allow doc to update

 if(-1!=t.indexOf("<!-- refresh -->"))location="jijx"; //!
}

// add sentence to log unless blank or same as last
function addrecall()
{
 var a,i,blank=0,same=0;
 a= s.value;
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

function scrollin(){if(flip)window.scrollTo(0,0);else window.scrollTo(0,1000000);}

// refocus jsentence unless focus was on body
// taking focus from body breaks copy/paste in IE
function refocus()
{
 var ie= document.all && !window.opera;    
 if(ie && document.activeElement.name==null) return;
 setfocus();
}

function setfocus()
{
 scrollin();
 s.focus();
}

function doshortcut(c)
{
 switch(c)
 {
  default: dostdshortcut(c); break;
 }
}

function uarrow(){++reci;reci= reci>=recs.length ? reci-1 : reci ; s.value= recs[reci];}
function darrow(){if(--reci<0) {reci= -1; s.value="   ";} else s.value= recs[reci];}

function evload()
{
 s= document.getElementById("jsentence");
 s.focus();
 scrollin();
 s.value='<PROMPT>';
}

function ev_up_click(){uarrow();refocus();}

function ev_dn_click(){darrow();refocus();}
function ev_jsentence_enter(){jbyid("kbspace").style.display= "none";addrecall();jdo(s.value,true,[]);}

// menu handlers

function ev_studio_click(){menuclick()}
function ev_tool_click(){menuclick();}
function ev_link_click(){menuclick();}

function sdo(){jdoh([]);setfocus();}

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
