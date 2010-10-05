NB. html templates and utilities
coclass'jhs'

NB. body css affects menu
NB. menu position:fixed
NB. .menu{width:100%;position:fixed;background:#eee;
NB.  margin-top:-20px;margin-left:-10px;padding-left:10px;padding-top:3px;padding-bottom:3px;
NB. }
NB. menu position scroll
NB. .menu{width:100%;}

NB. menu fixed font kludges shortcut right align
CSSCORE=: 0 : 0
*{font-family:"sans-serif";font-size:<PC_FONTSIZE>}
*.jcode{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;white-space:pre;}
*.hab:hover{cursor:pointer;color:red;}
*.hab{text-decoration:none;}
*.hmab:hover{cursor:pointer;}
*.hmab{text-decoration:none;color:black;}
*.hmg:hover{cursor:pointer;}
*.hmg:visited{color:black;}
*.hmg{color:black;}
*.hmg{text-decoration:none;}
*.hml{color:black;}
*.hml:visited{color:black;}
*.hsel{background-color:buttonface;font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
body{margin-top:0;}
.menu{width:100%;position:fixed;background:#eee;
 margin-left:-10px;padding-left:10px;padding-top:3px;padding-bottom:3px;
}
.menu li{
 display:block;white-space:nowrap;
 padding:2px;color:#000;background:#eee;
 font-family:"courier new","courier","monospace";
}
.menu a{font-family:"courier new","courier","monospace";}
.menu a:hover{cursor:pointer;color:#000;background:#ddd;width:100%;}
.menu span{float:left;position:relative;}
.menu ul{
 position:absolute;top:100%;left:0%;display:none;
 list-style:none;border:1px black solid;margin:0;padding:0;
}
)

NB. core plus page styles with config replaces
NB. apply outer style tags after removing inner ones
css=: 3 : 0
t=. 'PC_FONTSIZE PC_FM_COLOR PC_ER_COLOR PC_LOG_COLOR PC_SYS_COLOR PC_FILE_COLOR'
t=. (CSSCORE,y) hrplc t;PC_FONTSIZE;PC_FM_COLOR;PC_ER_COLOR;PC_LOG_COLOR;PC_SYS_COLOR;PC_FILE_COLOR
t=. t rplc '<style type="text/css">';'';'</style>';'' NB.! are they any inner ones to remove?
'<style type="text/css">',t,'</style>'
)

NB. core plus page js
js=: 3 : 0
'<script type="text/javascript">',JSCORE,y,'</script>'
)

seebox=: 3 : 0
1 seebox y
:
;((x+>./>#each y){.each "1 y),.<LF
)

seehtml=: 3 : 0
y rplc '<';LF,'<'
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
,'%',.(16 16#:a.i.y){'0123456789ABCDEF'
)

jmarka=:     '<!-- j html output a -->'
jmarkz=:     '<!-- j html output z -->'
jmarkc=: #jmarka

NB. output starting with jmarka and ending with jmarkv,LF
NB.  is assumed to be html and is not touched
jhtmlfroma=: 3 : 0
if. (jmarka-:jmarkc{.y)*.jmarkz-:(-jmarkc){.}:y do. y return. end.
NB.! y=. y rplc '<';'&lt;';'>';'&gt;';'&';'&amp;';'"';'&quot;';CRLF;'<br>';LF;'<br>';CR;'<br>';' ';'&nbsp;'
jhfroma y
)

jhfroma=: 3 : 0
y rplc '<';'&lt;';'>';'&gt;';'&';'&amp;';'"';'&quot;';CRLF;'<br>';LF;'<br>';CR;'<br>';' ';'&nbsp;'
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
t=. jhtx'<ID>';'<VALUE>';10;mid;' onchange="return jev(''<ID>'',''change'',event)"'
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
d=. ((gid,'_hh') jhh name),d NB. name of data for this grid
d=. ((gid,'_vv') jhh''),d   NB. new value for this grid
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

NB. jhbs body builders

NB. HBS is LF delimited list of sentences
NB. jhbs returns list of sentence results
jhbs=: 3 : 0
t=. ;jhbsex each <;._2 y
'<body onload="jevload();">',(jhform''),t,'</body></form>'
)

jhbsex=: 3 : 0
try.
 t=. }.' ',,".y NB. need lit list
catch.
 smoutput t=.'HBS error:',(>coname''),' ',y
 t=.'<div>',t,'</div>'
end.
t
) 

NB. show HBS sentences with html results
jhbshtml=: 3 : 0
s=.<;._2 HBS
seebox s,.LF-.~each jhbsex each s
)

jhh=: 4 : 0
t=. '<input type="hidden" id="<ID>" name="<ID>" value="<VALUE>">'
t hrplc 'ID VALUE';x;y
)

jmon=: 3 : 0
t=.   ' onblur="return jmenublur(event);"'
t=. t,' onfocus="return jmenufocus(event);"'
t=. t,' onkeyup="return jmenukeyup(event);"'
t=. t,' onkeydown="return jmenukeydown(event);"'
    t,' onkeypress="return jmenukeypress(event);"'
)

NB. menu group button
NB. id jmg 'text';decor;width
NB. decor 0 for '' and 1 for &#9660; (dropdown)
jhmg=: 4 : 0
'text dec w'=. y
text=. text,>dec{'';'&#9660;'
t=. >(MSTATE=1){'</ul></span>';''
t=. t,'<span style="z-index:<INDEX>";>'
t=. t,'<span><a href="#" id="<ID>" name="<ID>" class="hmg"'
t=. t,' onclick="return jmenuclick(event);"'
t=. t,jmon''
t=. t,'><VALUE>&nbsp;</a></span>'
t=. t,'<ul id="<ID>_ul">'
t=. t hrplc 'ID VALUE INDEX';x;text;":MINDEX
MSTATE=: 2
MINDEX=: <:MINDEX
JMWIDTH=: w
t
)

jhmx=: 3 : 0
if. '^'={:y do.
 s=. ' ',_2{y
 t=. _2}.y
else.
 s=. '  '
 t=. y
end.
(dltb t);s
)

NB. menu link button
jhmab=: 4 : 0
't s'=.jhmx y
t=. (JMWIDTH{.t),s
t=. x jhab t rplc ' ';'&nbsp;'
t=. t rplc 'class="hab"';'class="hmab"',jmon''
'<li>',t,'</li>'
)

NB. menu link
jhml=: 4 : 0
't s'=.jhmx y
value=. t
text=. ((0>.JMWIDTH-#value)#' '),s
value=. value rplc ' ';'&nbsp;'
text=. text rplc ' ';'&nbsp;'
t=.   '<li><a href="<REF>" class="hml" onclick="return jmenuhide();"'
t=. t,jmon''
t=. t,'><VALUE></a><TEXT></li>'
t hrplc 'REF VALUE TEXT';x;value;text
)

jhec=: 4 : 0
t=. '<div id="<ID>" contenteditable="true"',jeditatts
t=. t,'style="white-space:nowrap;" '
t=. t,'onkeydown="return jev(''<ID>'',''enter'',event)"'
t=. t,'onkeypress="return jev(''<ID>'',''keypress'',event)"'
t=. t,'>',y,'</div>'
t hrplc 'ID';x
)

jhecleft=: 4 : 0
t=. '<div id="<ID>" contenteditable="true"',jeditatts
t=. t,'style="white-space:nowrap;float:left;" '
t=. t,'onkeydown="return jev(''<ID>'',''enter'',event)"'
t=. t,'onkeypress="return jev(''<ID>'',''keypress'',event)"'
t=. t,' tabindex="-1"'
t=. t,'>',y,'</div>'
t hrplc 'ID';x
)

jhecright=: 4 : 0
t=. '<div id="<ID>" contenteditable="true"',jeditatts
t=. t,'style="white-space:nowrap;right:left;" '
t=. t,'onkeydown="return jev(''<ID>'',''enter'',event)"'
t=. t,'onkeypress="return jev(''<ID>'',''keypress'',event)"'
t=. t,'>',y,'</div>'
t hrplc 'ID';x
)


jeditatts=: ' autocomplete="off" autocapitalize="off" spellcheck="false" '

jhb=: 4 : 0
t=. '<input type="submit" id="<ID>" name="<ID>" value="<VALUE>" class="hb" onclick="return jev(''<ID>'',''click'',event)">'
t hrplc 'ID VALUE';x;y
)

NB. checkbox control
jhckb=: 4 : 0
'value set checked'=. y
checked=. >checked{'';'checked="checked"'
t=.   '<input type="checkbox" id="<ID>" value="<ID>" class="hcb" name="<SET>" <CHECKED>'
t=. t,' onclick="return jev(''<ID>'',''click'',event)"/><label for="<ID>"><VALUE></label>'
t hrplc 'ID VALUE SET CHECKED';x;value;set;checked
)

NB. checkbox control with no event call
jhckbne=: 4 : 0
'value set checked'=. y
checked=. >checked{'';'checked="checked"'
t=.   '<input type="checkbox" id="<ID>" value="<ID>" class="hcb" name="<SET>" <CHECKED>'
t=. t,' /><label for="<ID>"><VALUE></label>'
t hrplc 'ID VALUE SET CHECKED';x;value;set;checked
)

NB radio control
jhradio=: 4 : 0
'value set checked'=. y
checked=. >checked{'';'checked="checked"'
t=.   '<input type="radio" id="<ID>" value="<ID>" class="<CLASS>" name="<SET>" <CHECKED>'
t=. t,' onclick="return jev(''<ID>'',''click'',event)"/><label for="<ID>"><VALUE></label>'
t hrplc 'ID VALUE SET CHECKED';x;value;set;checked
)

NB radio control with no event call
jhradio=: 4 : 0
'value set checked'=. y
checked=. >checked{'';'checked="checked"'
t=.   '<input type="radio" id="<ID>" value="<ID>" class="<CLASS>" name="<SET>" <CHECKED>'
t=. t,' /><label for="<ID>"><VALUE></label>'
t hrplc 'ID VALUE SET CHECKED';x;value;set;checked
)

jht=: 4 : 0
t=.   '<input type="text" id="<ID>" name="<ID>" class="ht"',jeditatts,'value="<VALUE>" size="<SIZE>"'
t=. t,' onkeydown="return jev(''<ID>'',''enter'',event)"'
t=. t,'>'
t hrplc 'ID VALUE SIZE';x;y
)

jhtp=: 4 : 0
t=. '<input type="password" id="<ID>" name="<ID>" class="ht"',jeditatts,'value="<VALUE>" size="<SIZE>" onkeydown="return jev(''<ID>'',''enter'',event)" >'
t hrplc 'ID VALUE SIZE';x;y
)


jhtarea=: 4 : 0
t=. '<textarea id="<ID>" name="<ID>" class="htarea" wrap="off" rows="1" cols="1"',jeditatts,'><DATA></textarea>'
t hrplc 'ID DATA';x;y
)

NB. J ide link menu
jhjmlink=: 3 : 0
t=.   'jmlink'jhmg'link';1;7
t=. t,'jijx'  jhml'ijx     j^'
t=. t,'jfile' jhml'file    f^'
t=. t,'jijs'  jhml'ijs     J^'
t=. t,'jfif'  jhml'fif     F^'
t=. t,'jal'   jhml'pacman'
t=. t,>(-.0-:gethv'Cookie:'){' ';'jlogin'jhml'logout'
t=. t,'jhelp' jhml'help    h^'
)

NB.! replace all M... with JM... when all in HBS style
jhma=: 3 : 0
MSTATE=:1[MINDEX=:100
'<div class="menu">'
)

jhmz=: 3 : 0
MSTATE=:0
'</ul></span></div><br><br>'
)

jhform=: 3 : 0
formtmpl hrplc 'LOCALE';>coname''
)

jhdiva=: 4 : 0
'<div id="',x,'">',y
)

jhdivahide=: 4 : 0
'<div id="',x,'" style="display:none;">',y
)
 
jhdiv=: 4 : 0
if. ''-:x do.
 '<div>',y,'</div>'
else.
 '<div id="',x,'">',y,'</div>'
end.
)

jhspan=: 4 : 0
if. ''-:x do.
 '<span>',y,'</span>'
else.
 '<span id="',x,'">',y,'</span>'
end.
)

jhh1=: 3 : 0
'<h1>',y,'</h1>'
)

jhab=: 4 : 0
t=. '<a id="<ID>" href="#" name="<ID>" class="hab" onclick="return jev(''<ID>'',''click'',event)"'
t=. t,' ondblclick="return jev(''<ID>'',''dblclick'',event)"><VALUE></a>'
t hrplc 'ID VALUE';x;y
)

jhref=: 4 : 0
y=. boxopen y
t=. '<a href="<REF>" class="href" ><VALUE></a>'
t hrplc 'REF VALUE';x;y
)

NB. select control
jhsel=: 4 : 0
'values size sel'=. y
t=. '<select id="<ID>" name="<ID>" class="hsel" size="<SIZE>" onchange="return jev(''<ID>'',''click'',event)" >'
t=. t hrplc 'ID SIZE SEL';x;size;sel
opt=. '<option value="<VALUE>" label="<VALUE>" <SELECTED>><VALUE></option>'
for_i. i.#values do.
 t=. t,opt hrplc'VALUE SELECTED';(i{values),(i=sel){'';'selected="selected"'
end.
t=. t,'</select>'
)

NB. select control with no event calls
jhselne=: 4 : 0
'values size sel'=. y
t=. '<select id="<ID>" name="<ID>" class="hsel" size="<SIZE>" >'
t=. t hrplc 'ID SIZE SEL';x;size;sel
opt=. '<option value="<VALUE>" label="<VALUE>" <SELECTED>><VALUE></option>'
for_i. i.#values do.
 t=. t,opt hrplc'VALUE SELECTED';(i{values),(i=sel){'';'selected="selected"'
end.
t=. t,'</select>'
)

NB. jgrid
jhtx=: 3 : 0
t=. '<input type="text" id="<ID>" name="<ID>" class="<CLASS>" <EXTRAS>',jeditatts,'value="<VALUE>" size="<SIZE>" onkeydown="return jev(''<ID>'',''enter'',event)" >'
t hrplc 'ID VALUE SIZE CLASS EXTRAS';5{.y,(#y)}.'';'';'';'ht';''
)

jhtr=: 3 : 0
'<tr>','</tr>',~;(<'<td>'),each y,each<'</td>'
)

jhtaba=: '<table>'
jhtabz=: '</table>'
jhbr=: '<br/>'
jhhr=: '<hr/>'

NB. standard demo html boilerplate
jhdemo=: 3 : 0
c=. '.ijs',~>coname''
if. 'jdemo.ijs'-:c do. t=. '' else. t=. 'demo/' end.
p=. jpath'~addons/ide/jhs/',t,c
t=. '<hr/>'
t=. t,'jijx' jhref'ijx'
t=. t,' ','jdemo'  jhref'jdemo'
for_i. >:i.8 do.
 d=. 'jdemo',":i
 t=.t,' ',d jhref d
end.
t=. t,'<br/>'
t,'Open script: <a href="jfile?mid=open&path=',p,'">',c,'</a>'
)

NB. title jhr (body hrplc arguments)
NB. build html response from page globals CSS JS HBS
NB. CSS or JS undefined allwed
jhr=: 4 : 0
if. _1=nc <'CSS' do. CSS=: '' end.
if. _1=nc <'JS'  do. JS=: '' end.
tmpl=. hrtemplate
if. SETCOOKIE do.
 SETCOOKIE_jhs_=: 0
 tmpl=. tmpl rplc (LF,LF);LF,'Set-Cookie: ',cookie,LF,LF
end.
htmlresponse tmpl hrplc 'TITLE CSS JS BODY';x;(css CSS);(js JS);(jhbs HBS)hrplc y
)

JASEP=: 1{a. NB. delimit substrings in ajax response

NB.! jhfroma ??? required for some uses?
jhrajax=: 3 : 0
htmlresponse y,~hajax rplc '<LENGTH>';":#y
)

jgetfile=: 3 : '(>:y i: PS)}.y'
jgetpath=: 3 : '(>:y i: PS){.y'
