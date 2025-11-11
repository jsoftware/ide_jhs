NB. J HTTP Server - jijx app
coclass'jijx'
coinsert'jhs'

termmenu=: 0 : 0
jhmenu'term';'advance'jhb'⇒';'jmenuburger'

'menu0'      jhmenugroup ''
'sp'         jhmenuitem 'projects';'p'
'jinputs'    jhmenuitem  'inputs';'i'
'jbreak'     jhmenuitem 'break';'c'
'dissect'    jhmenuitem 'dissect input line';'j'
'jhshelp'    jhmenuitem 'help';'h'         
'closepages' jhmenuitem 'close pages'
             jhmenulink 'jpages';'system pages'
             jhmenulink 'options';'options and view'
'close'      jhmenuitem 'quit';'q'
jhmenugroupz''

'jpages' jhmenugroup''
'jfile'  jhmenuitem 'explore files';'e'
'jfif'   jhmenuitem 'find in files';'f'
'jdebug'  jhmenuitem 'debug';'d'
'jijs'    jhmenuitem 'edit new temp file';'n'
'jpacman' jhmenuitem 'package manager'
'jlocale' jhmenuitem 'locale explorer'
'jhelp'   jhmenuitem 'jhshelp texts'
'jdoc'    jhmenuitem 'framework docs'
jhmenugroupz''

'options'      jhmenugroup''
'wrap'         jhmenuitem 'NOWRAP ➜ wrap'
'spa'          jhmenuitem 'Tab ➜ term'
'flow'         jhmenuitem 'COLUMN ➜ row';'u' NB. see flowset for kludge to preserve shortcut
'cleartemps'   jhmenuitem 'remove red boxes';'r'
'clearwindow'  jhmenuitem 'clear window'
'clearrefresh' jhmenuitem 'clear refresh'
'clearLS'      jhmenuitem 'clear LS'
jhmenugroupz''

)

HBS=: 0 : 0 rplc '<termmenu>';termmenu
<termmenu>
jhdivz NB. flex active
      jhresize''
'log' jhec'<LOG>'
'jframes'jhdiva''
jhdivz
jhdiva'' NB. flex inactive - reopen main div
)

jev_get=: create

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
t=. '<div id="prompt" class="log"  onpaste="mypaste(event)">',t,'</div>'
d=. LOGN,t
uplog''
if. METHOD-:'post' do.
 if. CHUNKY do.
  CHUNKY_jhs_=: 0
  jhrajax_z d
 else.
  jhrajax d
 end. 
else.
 create''
end.
)

NB. refresh response - not jajax
create=: 3 : 0
uplog''
'term' jhr 'LOG';LOG
)

ev_advance_click=: 3 : 0
select. ADVANCE
case. 'spx' do. spx__''
case. 'lab' do. lab 0
case. 'wiki'do. wikistep_jsp_''
case.       do. echo 'no open lab/spx to advance'
end.
)

jloadnoun_z_=: 0!:100

ev_dissect_click=: 3 : 0
d=. getv'jdata'
d=. quote ('|'={.d)}.d NB. asssume leading | is from error report
9!:27'dissect ',d
9!:29[1
jhtml''
)

ev_clearrefresh_click=: 3 : 'LOG_jhs_=: '''''

ev_jhelp_click=: 3 : 0
'jhelp'jpage''
)

ev_jhshelp_click=: 3 : 0
jhshelp''
)

ev_about_click=: 3 : 0
jhtml'<hr/>'
echo JVERSION
echo' '
echo'Copyright 1994-2025 Jsoftware Inc.'
jhtml'<hr/>'
)

NB. aws server window.close fails (depends on how started)
ev_close_click=: 3 : 0
select. QRULES
case. 0 do. NB. localhost    - close pages, exit server, close jterm
 jhrajax'666'
 exit''
case. 1 do. NB.server user   - close pages, no exit, window.location=juser
 jhrajax 'juser>' NB. causes set of window.location
case. 2 do. NB. server guest - close pages, exit server, window.location=jguest
 exit'' NB. no jhrajax triggers jguest page
end.
)

ev_sp_click=:  3 : 'sp__'''''

ev_comma_ctrl =:  3 : 'i.0 0'
ev_dot_ctrl=: ev_advance_click
ev_slash_ctrl  =: 3 : 'i.0 0'
ev_less_ctrl   =: 3 : 'i.0 0'
ev_larger_ctrl =: 3 : 'i.0 0'
ev_query_ctrl =: 3 : 'i.0 0'
ev_semicolon_ctrl =:   3 : 'loadx__ 0'
ev_colon_ctrl =:       3 : 'echo''colon'''
ev_quote_ctrl_jijx_=:  3 : 'echo''quote'''
ev_doublequote_ctrl =: 3 : 'echo''doublequote'''

load'~addons/ide/jhs/loadx.ijs'


NB. csscore has log css
CSS=: 0 : 0 
*{font-family:<PC_FONTFIXED>;font-weight:550;}
form{margin-top:0;margin-bottom:0;}
*.fm   {color:<PC_FM_COLOR>;}
*.er   {color:<PC_ER_COLOR>;}
*.log  {color:<PC_LOG_COLOR>;}
*.sys  {color:<PC_SYS_COLOR>;}
*.file {color:<PC_FILE_COLOR>;}

.jhb#overview{background-color:<PC_JICON>;font-weight:bold;font-size:1em;margin-left:1em;}
#prompt{background-color:blanchedalmond;border:2px solid black;padding:8px 0 8px 0;}
)

INC=: INC_chartjs NB. include chart js code

JS=: ('var qrules= ',":QRULES),LF,fread JSPATH,'jijx.js'
