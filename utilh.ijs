NB. html templates and utilities
coclass'jhs'

jsdata=: '"uninitialized"'   NB. jsdata not set by app - must be legal javascript

INC=: CSS=: JS=: HBS=: ''  NB. overidden in app locale
NOCACHE=: 0                NB. use cached js files

INC_jquery=: 0 : 0
~addons/ide/jhs/js/jquery/smoothness/jquery-ui.custom.css
~addons/ide/jhs/js/jquery/jquery-2.0.3.min.js
~addons/ide/jhs/js/jquery/jquery-ui.min.js
~addons/ide/jhs/js/jquery/jquery-ui.css"
)

INC_d3=: INC_jquery,0 : 0
~addons/ide/jhs/js/d3/d3.css
~addons/ide/jhs/js/d3/d3.min.js
)

INC_d3_basic=: INC_d3,0 : 0
~addons/ide/jhs/js/jsoftware/d3_basic.js
)

INC_handsontable=: INC_jquery, 0 : 0
~addons/ide/jhs/js/handsontable/handsontable.full.min.js
~addons/ide/jhs/js/handsontable/handsontable.full.min.css
)

INC_handsontable_basic=: INC_handsontable NB. no jsoftware stuff yet

INC_chartjs=: 0 : 0
~addons/ide/jhs/js/chartjs/chart.js
~addons/ide/jhs/js/chartjs/defaults.js
)

INC_splitter=: 0 : 0
~addons/ide/jhs/js/splitter/styles.min.css
~addons/ide/jhs/js/jsoftware/jsplitter.js
)

NB. extra html - e.g. <script .... src=...> - included after CSS and before JSCORE,JS
HEXTRA=: '' 

NB. core plus page styles with config replaces
NB. css from y has legacy <PC_FONTFIXED> and may have PC_FONTFIXED
NB. csscore.css has only PC_FONTFIXED
css=: 3 : 0
core=. fread JSPATH,'csscore.css'
t=. 'PC_JICON PC_FONTFIXED PC_FONTVARIABLE PC_FM_COLOR PC_ER_COLOR PC_LOG_COLOR PC_SYS_COLOR PC_FILE_COLOR PC_BUTTON PC_MENU_HOVER PC_MENU_FOCUS'
d=. PC_JICON;PC_FONTFIXED;PC_FONTVARIABLE;PC_FM_COLOR;PC_ER_COLOR;PC_LOG_COLOR;PC_SYS_COLOR;PC_FILE_COLOR;PC_BUTTON;PC_MENU_HOVER;PC_MENU_FOCUS
page=. y hrplc t;d                NB. <PC_...>
page=. page rplc (;:t),.":each d  NB. PC_...>
core=. core rplc (;:t),.":each d  NB. PC_...
'<style type="text/css">',LF,core,page,'</style>',LF
)

seebox=: 3 : 0
1 seebox y
:
;((x+>./>#each y){.each "1 y),.<LF
)


NB. Lambert/Raul forum
literate=: 3 : 0
; (LF;~dtb)"1]1 1}._1 _1}.":<y
)

seehtml=: 3 : 0
y rplc '<';LF,'<'
)

NB. form template - form, hidden handler sentence, hidden button for form enter (ff)
formtmpl=: 0 : 0 -. LF
<form id="j" name="j" method="post" action="<LOCALE>">
<input type="hidden" id="jdo" name="jdo"     value="">
<input type="hidden" id="jlocale" name="jlocale" value="<LOCALE>">
<input type="hidden" id="jid" name="jid"     value="">
<input type="hidden" id="jtype" name="jtype"   value="">
<input type="hidden" id="jmid" name="jmid"    value="">
<input type="hidden" id="jsid" name="jsid"    value="">
<input type="hidden" id="jclass" name="jclass"    value="">
<input type="hidden" id="jinfo" name="jinfo"    value="">
<input type="submit" value="" onclick="return false;" style="display:none;width:0px;height:0px;border:none">
)

NB. form urlencoded has + for blank
jurldecodeplus=: 3 : 0
jurldecode y rplc '+';' '
)

jurldecode=: 3 : 0
t=. ~.<"1 (1 2 +"1 0 (y='%')#i.#y){y
d=. ".each(<'16b'),each tolower each t
d=. d{each <a.
t=. '%',each t
,t,.d
y rplc ,t,.d
)

jurlencode=: 3 : 0
,'%',.(16 16#:a.i.,y){'0123456789ABCDEF'
)

jmarka=:     '<!-- j html output a -->'
jmarkz=:     '<!-- j html output z -->'
jmarkc=: #jmarka

jmarkjsa        =: '<!-- j js a --><!-- ' NB. next char ; is for refresh+ajax and blank for ajax only
jmarkjsz        =: ' --><!-- j js z -->'
jmarkremove     =: jmarka,jmarkjsa,' '
jmarkrcnt       =: #jmarkremove

NB. unique query string - avoid cache
uqs=: 3 : 0
canvasnum=: >:canvasnum
'?',((":6!:0'')rplc' ';'_';'.';'_'),'_',":canvasnum
)

NB. output starting with jmarka and ending with jmarkz,LF
NB.  is assumed to be html and is not touched
jhtmlfroma=: 3 : 0
if. (jmarka-:jmarkc{.y)*.jmarkz-:(-jmarkc){.}:y do. y return. end.
jhfroma y
)

bad=: 1{a. NB. this character hangs the browser

NB. &amp is a problem - '&amp;&nbsp;'
jhfroma=: 3 : 0
y rplc '<';'&lt;';'>';'&gt;';'&';'&amp;';'"';'&quot;';CRLF;'<br>';LF;'<br>';CR;'<br>';' ';'&nbsp;';bad;''
)

NB. special version with normal space entity instead of &nbsp; - used in jhtext and jhpassword
NB. javascript inverse: jtfromh
jhfromax=: 3 : 0
y rplc '<';'&lt;';'>';'&gt;';'&';'&amp;';'"';'&quot;';CRLF;'<br>';LF;'<br>';CR;'<br>';' ';'&#32;';bad;''
)

NB. app did not send response - send one now
jbad=: 3 : 0
if. METHOD-:'get' do.
 htmlresponse html409 NB. conflict - not working properly - reload
 echo 'html409 response for ',URL
else.
 echo NV
 e=. LF,'J event handler ev_',(getv'jmid'),'_',(getv'jtype'),' ran but did not provide ajax response'
 echo e
 jhrajax ({.a.),jsencode jcmds 'alert *',e NB. ajax jhrcmds
end.  
)

htmlresponse=: 3 : 0
logapp'htmlresponse'
NB. y 1!:2<jpath'~temp/lastreponse.txt'
LASTTS=: 6!:1''
putdata LASTRESPONSE=: y
shutdownJ_jsocket_ SKSERVER ; 2
sdclose_jsocket_ ::0: SKSERVER
SKSERVER_jhs_=: _1
i.0 0 NB. nothing to display if final J result
)

NB. x hrplc 'aa bb cb';daa;dbb;dcc
NB. aa treated as <aa>
NB. numbers converted to string
hrplc=: 4 : 0
x rplc ('<',each (;:>{.y),each'>'),. ": each }.y
)

NB. grid stuff

NB. template gridgen mid;vals
NB. mid*row*col
NB. template has <ID> and <VALUE> (other repaces already done)
jgridgen=: 4 : 0
'mid v'=. y
'r c'=. $v
d=. ''
for_i. i.r do.
 for_j. i.c do.
  id=. mid,'*',(":i),'*',":j
  d=. d,<x hrplc 'ID VALUE';id;j{i{v
 end.
end.
($v)$d
)

NB. create grid for editing named numeric matrix
NB. y is gid;colheads;rowheads;name
NB. gid makes up family of mids - gid_dd gid_ch ...
NB. colheads/rowheads'' gets defaults
NB. rowheads must be column
NB. edit events are gid_dd_enter gid_dd_change
NB. gid_hh contains the edited noun name for the event
NB. gid_vv contains new cell value for the event
jgridnumedit=: 3 : 0
'gid colh rowh name'=. y
try.
 assert. 0=nc <name
 data=. ".name
 assert. (2=$$data)*.(3!:0 data) e. 4 8 16
catch.
 data=. i.2 3
 ".name,'=: data'
end.
'r c'=. $data
if. ''-:colh do. colh=.   ,:(<'C'),each ":each i.c end.
if. ''-:rowh do. rowh=. |:,:(<'R'),each ":each i.r end.
assert. c={:$colh
assert. r=#rowh

mid=. gid,'_dd'
t=. jhtx'<ID>';'<VALUE>';10;mid;' onchange="return jev(event)"'
dd=. t jgridgen mid;<data
mid=. gid,'_ch'
t=. jhtx'<ID>';'<VALUE>';10;'<MID>';'readonly="readonly" tabindex="-1" '
ch=. (t rplc '<MID>';mid) jgridgen mid;<colh
mid=. gid,'_cf'
cf=. (t rplc '<MID>';mid) jgridgen mid;<,:+/data
mid=. gid,'_rh'
rh=. (t rplc '<MID>';mid) jgridgen mid;<rowh
mid=. gid,'_rf'
rf=. (t rplc '<MID>';mid) jgridgen mid;<|:,:+/"1 data
mid=. gid,'_xx'
co=. (t rplc '<MID>';mid) jgridgen mid;<,:,<''
co=. <name
cx=. <'+/'
t=. co,.ch,.cx
m=. rh,.dd,.rf
b=. cx,.cf,.<''
d=. t,m,b
d=. (<'<td>'),each(<'</td>'),~each d
d=. (<'<tr>'),.(<'</tr>'),.~d
d=. ('</table>'),~,('<table id="',gid,'" cellpadding="0" cellspacing="0">'),;d
d=. ((gid,'_hh') jhhidden name),d NB. name of data for this grid
d=. ((gid,'_vv') jhhidden''),d   NB. new value for this grid
)

NB. gid;80px
jgridnumeditcss=: 3 : 0
'gid width'=. y
t=.   '.',gid,'_dd{text-align:right;width:',width,';}',LF 
t=. t,'.',gid,'_ch{text-align:left; width:',width,';}',LF
t=. t,'.',gid,'_cf{text-align:right;width:',width,';}',LF
t=. t,'.',gid,'_rh{text-align:left; width:',width,';}',LF
t=. t,'.',gid,'_rf{text-align:right;width:',width,';}',LF
t=. t,'.',gid,'_xx{text-align:right;width:',width,';}',LF
)

NB. html template <...>
NB. TITLE
NB. CSS   - styles
NB. JS    - javascript
NB. BODY  - body
hrtemplate=: toCRLF 0 : 0
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Connection: close
Cache-Control: no-cache

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><TITLE></title>
<CSS>
<HEXTRA>
<JS>
</head>
<BODY>
</html>
)

hrxtemplate=: toCRLF 0 : 0
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Connection: close

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><TITLE></title>
)

NB. html 204 response (leave the page as is)
html204=: toCRLF 0 : 0
HTTP/1.1 204 OK
Content-Type: text/html; charset=utf-8
Connection: close

)

NB. html 301 response (redirect to another url)
html301=: toCRLF 0 : 0
HTTP/1.1 301 Permanently moved
Location: <NEWURL>
Cache-Control: no-cache
Pragma: no-cache
Expires: 0
Connection: close


)

NB. html 409 Conflict response (J code didn't provide result)
html409=: toCRLF 0 : 0
HTTP/1.1 409 Conflict
Content-Type: text/html; charset=utf-8
Connection: close


get/post request failed<br>
response code 409<br>
application did not produce result<br>
try browsing to url again<br>
additional info in jijx<b/><br>
<button onclick="if('undefined'==typeof window.parent.spaclose) return window.close(); return window.parent.spaclose(window);" >close and return to term</button>

)

gsrchead=: toCRLF 0 : 0
HTTP/1.1 200 OK
Server: JHS
Content-Length: <LENGTH>
Content-Type: <TYPE>
Cache-Control: no-cache
Connection: Keep-Alive

)


gsrcf=: 4 : 0
htmlresponse y,~gsrchead rplc '<TYPE>';x;'<LENGTH>';":#y
)

fsrchead=: toCRLF 0 : 0
HTTP/1.1 200 OK
Server: JHS
Content-Type: <TYPE>

)

NB. html for jajax response
NB. no-cache critical - otherwise we get old
NB. answers to the same question!
hajax=: toCRLF 0 : 0
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Cache-Control: no-cache
Content-Length: <LENGTH>

)

NB. html for ajax response in chunks
hajax_chunk=: toCRLF 0 : 0
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Cache-Control: no-cache
Transfer-Encoding: chunked

)

hajaxlogoff=: toCRLF 0 : 0
HTTP/1.1 403 OK
Content-Type: text/html; charset=utf-8
Cache-Control: no-cach
Content-Length: <LENGTH>
Set-Cookie: jcookie=0

)

NB. jhbs body builders

HBSX=: ' id="<ID>" name="<ID>" class="<CLASS>" '

NB. HBS is LF delimited list of sentences
NB. jhbs returns list of sentence results
jhbs=: 3 : 0
jhbsjs=: '' NB. hbs js statments captured in globals
t=. <;._2 y
t=. LF,~LF,~LF,;jhbsex each t
i=. 1 i.~'</div><div id="jresizeb">'E.t
if. i~:#t do.
 t=. '<div id="jresizea">',t,'</div>'
end.
t=. '<div id="status-busy"><br>server busy<br>event ignored<br><br></div>',t
t=. '<div>',t,'</div>' NB. all in a div - used by flex
t=. '<body onload="jevload();" onunload="jevunload();" onfocus="jevfocus();">',LF,(jhform''),LF,t,jsa,jhbsjs,jsz,LF,'</form></body>'
)

jhbsex=: 3 : 0
try.
 t=. LF,}.' ',,".y NB. need lit list
catch.
 echo t=.'HBS error: locale: ',(>coname''),' line: ',y,LF,13!:12''
 t=.'<div>',(jhfroma t),'</div>'
end.
t
) 

NB.? autocapitalize="none"
jeditatts=: ' autocomplete="off" autocapitalize="off" autocorrect="off" spellcheck="false" '

jhform=: 3 : 0
formtmpl hrplc 'LOCALE';>coname''
)

JASEP=: 1{a. NB. delimit substrings in ajax response

jgetfile=: 3 : '(>:y i: PS)}.y=.jshortname y'
jgetpath=: 3 : '(>:y i: PS){.y=.jshortname y'


NB.*.1 event handlers and responses

NB.* jnv*jnv 1 - toggle display of event name/value pairs
jnv=: 3 : 'NVDEBUG=:y' NB. toggle event name/value display

NB. build html response from page globals CSS JS HBS
NB. CSS or JS undefined allowed
NB.* jhr*title jhr names;values - names to replace with values
NB.* *send html response built from HBS CSS JS names values
jhr=: 4 : 0
if. _1=nc<'JS'  do. JS=:'' end.
if. _1=nc<'CSS' do. CSS=:'' end.
tmpl=. hrtemplate
if. SETCOOKIE do.
 SETCOOKIE_jhs_=: 0
 tmpl=. tmpl rplc (CRLF,CRLF);CRLF,'Set-Cookie: ',cookie,CRLF,CRLF
end.
htmlresponse tmpl hrplc 'TITLE CSS HEXTRA JS BODY';(TIPX,x);(css CSS);HEXTRA;(getjs'');(jhbs HBS)hrplc y
)

NB.* jhrx*title jhrx (getcss'...'),(getjs'...'),getbody'...'
NB.* *send html response built from INCLUDE, CSS, JS, HBS
jhrx=: 4 : 0
JTITLE=: x
htmlresponse (hrxtemplate hrplc 'TITLE';(TIPX,x)),y
)

NB.* jhrpage*title jhrpage (getcss'...'),(getjs'...'),getbody'...'
NB.* *page response to a get
jhrpage=: 4 : 0
(hrxtemplate hrplc 'TITLE';(TIPX,x)),y
)

getincs=: 3 : 0
t=. ~.<;._2 INC
t=. (;(<y)-:each (-#y){.each t)#t
if. 0=#t do. t return. end.
b=. ;fexist each t
('INC file not found: ',>{.(-.b)#t)assert b
t
)

NB. INC css provided inline - not as href - avoid cache woes
getcss=: 3 : 0
'getcss arg not empty'assert ''-:y
t=. getincs'.css'
t=. ;(<'<style type="text/css">',LF),each (fread each t),each<'</style>',LF
t,css CSS hrplc 'PS_FONTCODE';PS_FONTCODE NB. PS_FONTCODE contains PC_... 
)

NB. INC js provided inline - not as src - avoid cache woes
fixjsi=: 3 : 0
 '<script type="text/javascript">',LF,'// NOCACHE: ',y,LF,(fread y),LF,'</script>'
)


jsa=: LF,'<script type="text/javascript">',LF
jsz=: LF,'</script>',LF


getjs=: 3 : 0
t=. getincs'.js'
t=. ;LF,~each fixjsi each t 
t=. t,jsa,'function jevload(){alert("load javascript failed:\nsee jijx menu tool>debug javascript")};',jsz
t,jsa,(fread JSPATH,'jscore.js'),(JS hrplc y),'var jsdata= ',jsdata,';',jsz
)

NB. core plus y - used for special pages
js=: 3 : 0
jsa,(fread JSPATH,'jscore.js'),y,jsz
)

gethbs=: 3 : 0
'</html>',~'</head>',y hrplc~jhbs HBS
)

NB.* jhrajax*jhrajax data - JASEP delimited data
jhrajax=: 3 : 0
htmlresponse y,~hajax rplc '<LENGTH>';":#y
)

NB.* jcmds*jcmds cmds - 0 or more boxed list of browser commands
jcmds=: 3 : 0
t=. boxopen y
'jcmds arg is not 0 or more boxed strings'assert 2=;3!:0 each t
'jhrcmds';<t
)

jwdbuffer=: '' NB. empty in jhs - buffer of cmds for jhrcmds

NB.* jwd* jwd cmds - y is 0 or more strings that are jhrcmds cmds
NB.* *add y cmds to jwdbuffer in locale
jwd=: 3 : 'jwdbuffer=: jwdbuffer,boxopen y'

NB.* jhrcmds*jhrcmds cmds - 0 or more boxed cmds
NB.* *y cmds are added to jwdbuffer and all cmds are then run
NB.* *jwdbuffer is cleared
NB.* *run in event handler to return cmds to javascript
NB.* *set id *value     - html elements (e.g. jhtext) with value
NB.* *id can be id of jhrad or jhchk
NB.* *set id *innerHTML - html elements with HTML (e.g. jhspan)
NB.* *css *css          - set new extra CSS
NB.* *other cmds need to be documented here
jhrcmds=: 3 : 0
jwdlast=: jwd y
jwdbuffer=: ''
jhrajax ({.a.),jsajaxdata=: jsencode jcmds jwdlast
)

NB.* jhcmds*jhcmds - 0 or or more cmds to be run by ev_body_load
NB.* run in ev_create/create/jev_get to pass cmds to javascript in var jsdata
NB.* see jhrcmds 
jhcmds=: 3 : 0
jsdata=: jsencode jcmds y
)

NB.* jhrjson*jhrjson - 0 or more boxed name/value pairs
jhrjson=: 3 : 0
jhrajax ({.a.),jsencode y
)

chunk=: 3 : 0
if. 0=#y do.
 ''
else. 
 (hfd#y),CRLF,y,CRLF
end. 
)

NB.* jhrajax_a*jhrajax_a data - first chunk
jhrajax_a=: 3 : 0
putdata hajax_chunk,chunk y
)

NB.* jhrajax_b*jhrajax_b data - next chunk
jhrajax_b=: 3 : 0
putdata chunk y
)

NB.* jhrajax_b*jhrajax_z data - last chunk
jhrajax_z=: 3 : 0
putdata (chunk y),'0',CRLF,CRLF
shutdownJ_jsocket_ SKSERVER ; 2
sdclose_jsocket_ ::0: SKSERVER
SKSERVER_jhs_=: _1
)

jsencode=: 3 : 'enc_pjson_ (2,~-:$y)$y'
