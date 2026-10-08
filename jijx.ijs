NB. J HTTP Server - jijx app
coclass'jijx'
coinsert'jhs'

termmenu=: 0 : 0
jhmenu'term';('overview'jhb'overview'),LF,'advance'jhb'advance'

'menu0'      jhmenugroup ''
             jhmenulink 'jpages';'pages'
'advance'    jhmenuitem 'advance';'a'             
'sp'         jhmenuitem 'projects';'p'
'spdefault'  jhmenuitem 'project default';'o'
'jinputs'    jhmenuitem  'inputs';'i'
'jbreak'     jhmenuitem 'break';'c'
'dissect'    jhmenuitem 'dissect input line';'j'
'help'       jhmenuitem 'help';'h'   
'cleartemps' jhmenuitem 'remove red boxes';'r'             
'close'      jhmenuitem 'quit';'q'
jhmenugroupz''

'jpages' jhmenugroup''
'jfile'  jhmenuitem 'explore files';'e'
'jfif'   jhmenuitem 'find in files';'f'
'jdebug'  jhmenuitem 'debug';'d'
'jijs'    jhmenuitem 'edit new temp file';'n'
'jpacman' jhmenuitem 'package manager'
'jlocale' jhmenuitem 'explore locales'
'allhelp' jhmenuitem 'all help';'1'
'jdoc'    jhmenuitem 'create app';'2'
'closepages' jhmenuitem 'close all'
jhmenugroupz''

)

HBS=: 0 : 0 rplc '<termmenu>';termmenu
<termmenu>
jhflexa
'log' jhec'<LOG>'
'jframes'jhdiva''
jhflexz
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

ev_doc_click=: 3 : 0
'jdoc'jpage''
)

ev_help_click=: 3 : 0
jhshelp''
)

ev_allhelp_click=: 3 : 0
'jhelp'jpage''
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

ev_spdefault_click=: 3 : 0
SPFILE_z_=: '~temp/sp/spfile.ijs'
load SPFILE
echo'   p_default_jsp_'''''
p_default_jsp_''
)

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
*.fm   {color:<PC_FM_COLOR>;}
*.er   {color:<PC_ER_COLOR>;}
*.log  {color:<PC_LOG_COLOR>;}
*.sys  {color:<PC_SYS_COLOR>;}
*.file {color:<PC_FILE_COLOR>;}
.jhb#overview,.jhb#advance{background-color:transparent;border:none;margin:0 0 0 0;font-weight:bold;color:green;}
.jhb#advance {margin:0 10px 0 0;}
#prompt{background-color:blanchedalmond;border:2px solid black;padding:8px 0 8px 0;}
)

INC=: INC_chartjs NB. include chart js code

JS=: ('var qrules= ',":QRULES),LF,fread JSPATH,'jijx.js'
