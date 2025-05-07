NB. J HTTP Server - ijs app - textarea version

coclass'jijs'
coinsert'jhs'

HBS=: 0 : 0
'<script type="module" src="~addons/ide/jhs/js/jsoftware/editor.js"></script>'

jhmenu'edit'

'filename'    jhhidden'<FILENAME>'
'rep'         jhdiv'<REP>'

'saveasdlg'    jhdiva''
 'saveasdo'    jhb'save as'
 'saveasx'     jhtext'';40
  'saveasclose'jhb'X'
'<hr></div>'

NB.! use flow instead of resize - avoid scroll due to meny space
jhresize''

'cm6_editor'   jhdiv''
'ijs'         jhtextarea'<DATA>';20;10
'textarea'    jhhidden''


NB. menu must come after codemirror
'menu0'   jhmenugroup ''
'ro'      jhmenuitem 'readonly';'t'
'runw'    jhmenuitem 'load';'^r'
          jhmenulink 'edit';'edit'
          jhmenulink 'more';'more'
'close'   jhmenuitem 'close';'q'
jhmenugroupz''

'edit' jhmenugroup''
NB. cut/copy/paste do not have cm.commands - only ctrl+xcv
NB. cut/copy/paste for touch - not supported in codemirror
'undo'    jhmenuitem 'undo';'^z'
'redo'    jhmenuitem 'redo';'^y'

'find'     jhmenuitem 'find';'^f'
'next'     jhmenuitem 'next';'^g'
'previous' jhmenuitem 'previous';'^G'
'replace'  jhmenuitem 'replace';'^F'
'repall'   jhmenuitem 'replaceall';'^R'
jhmenugroupz''

'more' jhmenugroup''
'save'   jhmenuitem 'save';'^s'
'saveas' jhmenuitem 'save as ...'
'runwd'  jhmenuitem 'loadd'
'lineadv' jhmenuitem 'run line/selection';'^.'
'comment' jhmenuitem 'NB. add/remove';'^/'
'chelp'   jhmenuitem 'context sensitive';'h'
'numbers' jhmenuitem 'numbers'
'theme' jhmenuitem 'theme'
jhmenugroupz''


)

NB. y file
create=: 3 : 0
y=. jshortname y
rep=.''
try.
 d=. (1!:1<jpath y) rplc '&';'&amp;';'<';'&lt;'
 addrecent_jsp_ y
catch.
 d=. ''
 rep=. 'file read failed ',(ftype y){::'(does not exist)';'';'(it is a folder)'
end.
(jgetfile y) jhr 'FILENAME REP DATA';y;rep;d
)

jev_get=: 3 : 0
'a b'=. getvs'jpagearg jwid'
if.     #a do. t=. a
elseif. #b do. t=. b
elseif. 1  do. t=. ''
end.
create ;(0=#t){t;jnew ''
)

0 : 0
line/lineadv/selection support removed
conflict with spa
spa save/load/loaded need immediate error report in spa
)

NB. save only if dirty
ev_save_click=: 3 : 0
'dirty line'=. <;._2 getv'jdata'
f=. getv'filename'
ta=. getv'textarea'
bta=. <;.2 ta,LF,LF NB. ensure trailing LF and extra one for emtpy last line
if. 'chelp'-:getv'jmid' do.
 'a b'=. 2{.line
 t=. dltb;{.;:b}.;a{bta
 t=. ;(t-:''){t;'voc'
 s=. 'jhswiki''',t,''''
 jhrajax JASEP,s,JASEP,":0
 return.
end.

if. dirty-:'dirty' do.
 mkdir_j_ (f i:'/'){.f
 r=. (toHOST ta)fwrite f
 if. r<0 do. jhrajax'file save failed' end.
end. 

line=. ,/:~2 2$ 0".line
ln=. <:{.line NB. line with caret - J 0 origin - cm6 1 origin
caret=. 2+ln
s=. ''
select. getv'jmid'
case. 'runw'             do. s=. 'load ''',f,''''
case. 'runwd'            do. s=. 'loadd ''',f,''''
case. 'lineadv' do.
 if. (2{.line)-:2}.line do. NB. run line or multiple line defn
  s=. ln getblock bta
  caret=. >:ln+#s
  s=. ;s
 else.
  'a b'=. /:~1 3{line NB. selection positions in ta
  s=. (b-a){.a}.ta
  caret=. 0
 end. 
end.

NB. try. do__ s catch. e=. 13!:12'' end. 
NB. jijsrun_jhs_=: s
NB. 9!:27 '0!:111 jijsrun_jhs_'
NB. 9!:29 (1)
jhrajax '',JASEP,s,JASEP,":caret
)

ev_close_click=: ev_sel_click=: ev_line_click=: ev_lineadv_click=: ev_runw_click=: ev_save_click
ev_runwd_click=: ev_chelp_click=: ev_save_click

ev_saveasdo_click=:ev_saveasx_enter

NB. should have replace/cancel option if file exists
ev_saveasx_enter=: 3 : 0
f=. jpath getv'saveasx'
if. f-:jpath getv'filename' do. jhrajax'same name' end.
if. fexist f do. jhrajax'already exists' return. end.
if. '~'={.f do. jhrajax'~ bad name' return. end.
try.
 mkdir_j_ (f i:'/'){.f
 r=. (toHOST getv'textarea')fwrite f
 addrecent_jsp_ f
 jhrajax JASEP,jshortname f
catch.
 jhrajax 'save failed'
end.
)

NB. new ijs temp filename
jnew=: 3 : 0
d=. 1!:0 jpath '~temp\*.ijs'
a=. ":>:>./0, {.@:(0&".)@> _4 }. each {."1 d
NB. a=. ": {. (i. >: #a) -. a
f=. <jpath'~temp\',a,'.ijs'
'' 1!:2 f
>f
)

NB. 1+ >./0,;0 ". each _4}.each {."1 d

NB. jdoajax load/loadd need response - mimic jijx
urlresponse=: 3 : 0
jhrajax''
)

NB. linenumber f lines - get block of lines
NB. simliar to spx requirements
NB. handles only simple cases
NB.  does not handle multiple n : 0 on first line
NB.  {{ on first line runs to first }} - no nesting
getblock=: 4 : 0
t=. ;:;x{y
i=. t i. <,':'
c=. 1
if. ((<'define')e.t)+.(,each':';'0')-:(i+0 1){t,'';'' do. NB. collect up to )
  c=. >:(dltb each x}.y)i.<')',LF
elseif. (<'{{')e.t do. NB. collect up to }}
  a=. ;x}.y
  b=. (a e.'}}')i.1
  c=. >:+/LF=(b+2){.a
elseif. ('NB.')-:3{.dltb ;x{y do. NB. collect NBs
 c=. >:(;(3{.each dltb each }.x}.y) -: each <'NB.')i.0
end.
c{.x}.y
)

NB. p{} klduge because IE inserts <p> instead of <br> for enter
NB. codemirror needs jresizeb without scroll
NB. codemirror requires no div padding (line number vs caret) so set padding-left:0
NB. see activeline-background in util/jheme.4.2.css
CSS=: 0 : 0
#rep{color:red}
#filenamed{color:blue;background-color:white;}
#saveasdlg{display:none;}
*{font-family:<PC_FONTFIXED>;font-weight:550;}
/* #jresizeb{overflow:visible;border:solid;border-width:1px;clear:left;} */
#ijs { display:none; }
div{padding-left:0;}
#cm6_editor { height: 100vh; }
)

JS=: fread JSPATH,'jijs.js'
