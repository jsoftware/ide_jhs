NB. html templates and utilities
coclass'jhs'


NB. B getbody BIS
NB. ids from ;: (J rules)
NB. 'abc' adds abc
NB. Nabc  adds noun Nabc
NB. Vabc  adds result of sentence Vdef''
NB. abc   adds result of sentence from BIS,BISCORE
NB. ID global available for use in sentence
NB. if no <body...> default <body.><form.></body></form> added
getbody=: 4 : 0
ids=. ;:x rplc LF;' '
t=. dlb each<;._2 y,BISCORE
i=. t i.each' '
n=. i{.each t
v=. dlb each i}.each t
v=. v,<'+''no sentence'''
r=. ''
for_id. ids do.
 ID=: >id
 select. {.ID
  case. '''' do. s=. ID
  case. 'N'  do. s=. ID
  case. 'V'  do. s=. ID,''''''
  case.      do. s=. >(n i. id){v
 end.
 try.
   assert.-.''-:t=. ".s
   r=. r,t
 catch.
   smoutput '*** failed template id - sentence: ',ID,' - ',s,LF,13!:12''
   r=. r,'*** see ijx for debug info ***'
 end.
end.
if. -.'<body'-:5{.r do.
 r=. '<body onload="jevload();">',(hform''),r,'</body></form>'
end.
r
)

NB. body template id-sentence pairs
BISCORE=: 0 : 0
jsep  '&diams;'
jide  hjide''
jma   '<div class="menu">'[MSTATE=:1[MINDEX=:100
jmz   '</ul></span></div>'[MSTATE=:0
+ ' ' 
^ '<br>'
- '<hr>'
[ '<table>'
] '</table>'
{ '<tr><td>'
} '</td></tr>'
; '</td><td>'
)

CSSCORE=: 0 : 0
*{font-family:"sans-serif";font-size:<PC_FONTSIZE>}
*.jcode{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;white-space:pre;}
*.hab:hover{cursor:pointer;color:red;}
*.hab{text-decoration:none;}
*.hsel{background-color:buttonface;font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
.menu{width:100%;float:left;}
.menu a{
 display:block;white-space:nowrap;
 padding:2px;color:#000;background:#fff;}
.menu a:hover{cursor:pointer;color:#000;background:#ddd;}
.menu span{float:left;position:relative;}
.menu ul{
 position:absolute;top:100%;left:0%;display:none;
 list-style:none;border:1px black solid;margin:0;padding:0;}
)

hcss=: 3 : 0
'<style type="text/css">',y,'</style>'
)

hjs=: 3 : 0
'<script type="text/javascript">',y,'</script>'
)

NB. core plus page styles with config replaces
NB. apply outer style tags after removing inner ones
css=: 3 : 0
t=. (CSSCORE,y) hrplc 'PC_FONTSIZE';PC_FONTSIZE
hcss t rplc '<style type="text/css">';'';'</style>';''
)

NB. core plus page js
NB. apply outer js tags after removing inner ones
js=: 3 : 0
hjs (JSCORE,y)rplc '<script type="text/javascript">';'';'</script>';''
)

NB. form template - form, hidden handler sentence, hidden button for form enter (ff)
formtmpl=: 0 : 0 -. LF
<form id="j" name="j" method="post" action="<LOCALE>">
<input type="hidden" name="jdo"     value="">
<input type="hidden" name="jajax"   value="false">
<input type="hidden" name="jlocale" value="<LOCALE>">
<input type="hidden" name="jid"     value="">
<input type="hidden" name="jtype"   value="">
<input type="hidden" name="jmid"    value="">
<input type="hidden" name="jsid"    value="">
<input type="submit" value="" onclick="return false;" style="display:none;width:0px;height:0px;border:none">
)

hform=: 3 : 0
formtmpl hrplc 'LOCALE';>coname''
)

NB. utils for generating html
NB. ID global (kludge, but so convenient to use B id from getbody)
NB. class hardwired based on util

hjide=: 3 : 0
'<a href="jijx">ijx</a> <a href="jfile">file</a> <a href="jhelp">help</a>',(0~:#PASS)#' <a href="jlogin">logout</a>'
)

hb=: 3 : 0
t=. '<input type="submit" id="<ID>" name="<ID>" value="<VALUE>" class="hb" onclick="return jev(''<ID>'',''click'',event)">'
t hrplc 'ID VALUE';ID;y
)

hc=: 3 : 0
t=. '<input type="checkbox" id="<ID>" value="<ID>" class="hcb" name="<SET>" onclick="return jev(''<ID>'',''click'',event)"/><VALUE>'
t hrplc 'ID VALUE SET';ID;y
)

hab=: 3 : 0
t=. '<a id="<ID>" href="#" name="<ID>" class="hab" onclick="return jev(''<ID>'',''click'',event)"'
t=. t,' ondblclick="return jev(''<ID>'',''dblclick'',event)"><VALUE></a>'
t hrplc 'ID VALUE';ID;y
)

hradio=: 3 : 0
t=. '<input type="radio" id="<ID>" value="<ID>" class="<CLASS>" name="<SET>" onclick="return jev(''<ID>'',''click'',event)"/><VALUE>'
t hrplc 'ID VALUE SET';ID;y
)

editatts=: ' autocomplete="off" autocapitalize="off" spellcheck="false" '

ht=: 3 : 0
t=. '<input type="text" id="<ID>" name="<ID>" class="ht"',editatts,'value="<VALUE>" size="<SIZE>" onkeydown="return jev(''<ID>'',''enter'',event)" >'
t hrplc 'ID VALUE SIZE';ID;y
)

htp=: 3 : 0
t=. '<input type="password" id="<ID>" name="<ID>" class="ht"',editatts,'value="<VALUE>" size="<SIZE>" onkeydown="return jev(''<ID>'',''enter'',event)" >'
t hrplc 'ID VALUE SIZE';ID;y
)

NB. grid
htx=: 3 : 0
t=. '<input type="text" id="<ID>" name="<ID>" class="<CLASS>" <EXTRAS>',editatts,'value="<VALUE>" size="<SIZE>" onkeydown="return jev(''<ID>'',''enter'',event)" >'
t hrplc 'ID VALUE SIZE CLASS EXTRAS';5{.y,(#y)}.'';'';'';'ht';''
)

htarea=: 3 : 0
t=. '<textarea id="<ID>" name="<ID>" class="htarea" wrap="off" rows="1" cols="1"',editatts,'><DATA></textarea>'
t hrplc 'ID DATA';ID;y
)

hh=: 3 : 0
t=. '<input type="hidden" id="<ID>" name="<ID>" value="<VALUE>">'
t hrplc 'ID VALUE';ID;y
)

href=: 3 : 0
y=. boxopen y
t=. '<a href="<REF>" class="href" ><VALUE></a>'
t hrplc 'REF VALUE';ID;y
)

NB. no id/name for options
hsel=: 3 : 0
'values size sel'=. y
t=. '<select id="<ID>" name="<ID>" class="hsel" size="<SIZE>" onchange="return jev(''<ID>'',''click'',event)" >'
t=. t hrplc 'ID SIZE SEL';ID;size;sel
opt=. '<option value="<VALUE>" label="<VALUE>" <SELECTED>><VALUE></option>'
for_i. i.#values do.
 t=. t,opt hrplc'VALUE SELECTED';(i{values),(i=sel){'';'selected="selected"'
end.
t=. t,'</select>'
)

NB. menu group button - ID global
hmg=: 3 : 0
t=. >(MSTATE=1){'</ul></span>';''
t=. t,'<span style="z-index:<INDEX>";>'
t=. t,'<span><a href="#" id="<ID>" name="<ID>" class="hab"'  
t=. t,' onclick="return jev(''<ID>'',''click'',event)" ><VALUE> &#9660; </a></span>'
t=. t,'<ul id="<ID>_ul">'
t=. t hrplc 'ID VALUE INDEX';ID;y;":MINDEX
MSTATE=: 2
MINDEX=: <:MINDEX
t
)

NB. menu link
hml=: 3 : 0
t=. '<li><a href="<REF>" onclick="return menuhide();" onmouseup="return menuhide();" ><VALUE></a></li>'
t hrplc 'REF VALUE';ID;y
)

NB. menu button - ID global
hmb=: 3 : 0
'<li>',(hab y),'</li>'
)

hopenijs=: 3 : 0
t=. '<TA><a href="jfile?mid=open&path=<FULL>"><SHORT></a><TZ>'
t hrplc 'TA FULL SHORT TZ';y
)

seebox=: 3 : 0
1 seebox y
:
;((x+>./>#each y){.each "1 y),.<LF
)

seehtml=: 3 : 0
y rplc '<';LF,'<'
)


jsstring=: 3 : 0
y rplc '"';'\"'
)

NB. form urlencoded has + for blank
urldecodeplus=: 3 : 0
urldecode y rplc '+';' '
)

urldecode=: 3 : 0
t=. <"1 (1 2 +"1 0 (y='%')#i.#y){y
d=. ".each(<'16b'),each tolower each t
d=. d{each <a.
t=. '%',each t
,t,.d
y rplc ,t,.d
)

markprompt=: '<!-- j prompt ('
marka=:     '<!-- j html output a -->'
markz=:     '<!-- j html output z -->'
markc=: #marka

NB. convert J text to html
NB. output starting with marka and ending with markv,LF
NB.  is assumed to be html and is not touched
htmlfroma=: 3 : 0
if. (marka-:markc{.y)*.markz-:(-markc){.}:y do.y return. end.
y=. y rplc '&';'&amp;';'<';'&lt;';'>';'&gt;';LF;'<br>';CR;'<br>';' ';'&nbsp;';'-';'&#45;';'"';'&quot;'
)

NB. app did not send response - send one now
jbad=: 3 : 0
smoutput'*** response not sent for ',URL
if. METHOD-:'get' do.
 htmlresponse html404 NB. URL not found
 smoutput'*** html404 (URL not found) sent'
else.
 htmlresponse html204 NB. leave page as is
 smoutput'*** html402 (leave page as is) sent'
end.  
)

htmlresponse=: 3 : 0
logapp'htmlresponse'
NB. y 1!:2<jpath'~temp/lastreponse.txt'
putdata LASTRESPONSE=: y
sdclose_jsocket_ SKSERVER
SKSERVER_jhs_=: _1
i.0 0 NB. nothing to display if final J result
)

hr=: 3 : 0
't c j b'=. y
tmpl=. hrtemplate
if. SETCOOKIE do.
 SETCOOKIE_jhs_=: 0
 tmpl=. tmpl rplc (LF,LF);LF,'Set-Cookie: ',cookie,LF,LF
end.
htmlresponse tmpl hrplc 'TITLE CSS JS BODY';t;c;j;b
)

hrajax=: 3 : 0
htmlresponse y,~hajax rplc '<LENGTH>';":#y
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
gridgen=: 4 : 0
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
gridnumedit=: 3 : 0
'gid colh rowh name'=. y
try.
 assert. 0=nc <name
 data=. ".name
 assert. (2=$$data)*.(3!:0 data) e. 4 8 16
catch.
 NB.! smoutput name,'*** bad grid data - reset to default'
 data=. i.2 3
 ".name,'=: data'
end.
'r c'=. $data
if. ''-:colh do. colh=.   ,:(<'C'),each ":each i.c end.
if. ''-:rowh do. rowh=. |:,:(<'R'),each ":each i.r end.
assert. c={:$colh
assert. r=#rowh

mid=. gid,'_dd'
t=. htx'<ID>';'<VALUE>';10;mid;' onchange="return jev(''<ID>'',''change'',event)"'
dd=. t gridgen mid;<data
mid=. gid,'_ch'
t=. htx'<ID>';'<VALUE>';10;'<MID>';'readonly="readonly" tabindex="-1" '
ch=. (t rplc '<MID>';mid) gridgen mid;<colh
mid=. gid,'_cf'
cf=. (t rplc '<MID>';mid) gridgen mid;<,:+/data
mid=. gid,'_rh'
rh=. (t rplc '<MID>';mid) gridgen mid;<rowh
mid=. gid,'_rf'
rf=. (t rplc '<MID>';mid) gridgen mid;<|:,:+/"1 data
mid=. gid,'_xx'
co=. (t rplc '<MID>';mid) gridgen mid;<,:,<''
co=. <name
cx=. <'+/'
t=. co,.ch,.cx
m=. rh,.dd,.rf
b=. cx,.cf,.<''
d=. t,m,b
d=. (<'<td>'),each(<'</td>'),~each d
d=. (<'<tr>'),.(<'</tr>'),.~d
d=. ('</table>'),~,('<table id="',gid,'" cellpadding="0" cellspacing="0">'),;d
ID=: gid,'_hh'
d=. (hh name),d NB. name of data for this grid
ID=: gid,'_vv'
d=. (hh''),d   NB. new value for this grid
)

NB. gid;80px
gridnumeditcss=: 3 : 0
'gid width'=. y
t=.   '.',gid,'_dd{text-align:right;width:',width,';}',LF 
t=. t,'.',gid,'_ch{text-align:left; width:',width,';}',LF
t=. t,'.',gid,'_cf{text-align:right;width:',width,';}',LF
t=. t,'.',gid,'_rh{text-align:left; width:',width,';}',LF
t=. t,'.',gid,'_rf{text-align:right;width:',width,';}',LF
t=. t,'.',gid,'_xx{text-align:right;width:',width,';}',LF
)

NB. Cache-Control: no-cache

NB. html template <XXX>
NB. TITLE
NB. CSS   - styles
NB. JS    - javascript
NB. BODY  - body
hrtemplate=: 0 : 0
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><TITLE></title>
<CSS>
<JS>
</head>
<BODY>
</html>
)

NB. html 204 response (leave the page as is)
html204=: 0 : 0
HTTP/1.1 204 OK
Content-Type: text/html; charset=utf-8


)

NB. html 404 response (url not found)
html404=: 0 : 0
HTTP/1.1 404 OK
Content-Type: text/html; charset=utf-8


)


NB. html for jajax response
NB. no-cache critical - otherwise we get old
NB. answers to the same question!
hajax=: 0 : 0
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Cache-Control: no-cache
Content-Length: <LENGTH>

)

ASEP=: 1{a. NB. delimit substrings in ajax response

ajaxresponse=: 3 : 0
htmlresponse y,~hajax rplc '<LENGTH>';":#y
)

cmdbase=: '<a href="jijx">ijx</a> <a href="jfile">file</a> <a href="jhelp">help</a>'

cmdsep=: '&diams;' NB. separate command groups

svgjs=: '<!--[if IE]><script src="svg.js"></script><![endif]-->'

