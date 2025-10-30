NB. verbs/nouns for creating page forms
coclass'jhs'

NB.*.1 verbs/nouns for creating forms

NB.* HBS=: 0 : 0 NB. HBS defines a form 
NB.  jhclose'' NB. menu with close
NB.  'bid' jhb 'button'
NB.  'tid' jhtext 'how now'
NB.  )

NB.* id jhab text - anchor like button with dblclick
jhab=: 4 : 0
(x jhb (boxopen y),<'jhab') jhaddatts ' ondblclick="return jev(event)"'
)

NB.* id jhb value [;class [;options ]] - button
NB.  id jhb 'value'
NB.  id jhb 'value';'';'='
NB.  id jhb 'value';'myb'
NB.  class '' is 'jhb'
NB.  option '~' does not run j handler from default js handler
NB.  option '=' value is already html and avoids jhfroma
jhb=: 4 : 0
id=. vid x
'value class options'=. y addd 'jhb';''
class=. gdef class;'jhb'
options=. voptions options
if. -.'='e.options do. value=. jhfroma value end.
t=. '<button id="<ID>" name="<ID>" class="<CLASS>" onclick="return jev(event)">'
t=. t hrplc 'ID VALUE CLASS';id;value;class
t=. t,value,'</button>'
t jhaddatts ('~'e.options)#'data-jhsnojdefault="1"'
)

NB.* <br>
jhbr=: '<br>'

NB.* id jhchart '' - chartjs
jhchart=: 4 : 0
'<div id="<id>_parent" class="jhchart_parent"><canvas id="<id>"></canvas></div>'hrplc 'id';x
)

NB.* id jhchk text [;check [;marks [;class [;options]]]]
NB.  id jhchk 'text'
NB.  id jhchk 'text';1
NB.  id jhchk 'text';0;'yn'
NB.  id jhchk 'text';0;'';'';'~'
NB.  not input tag type so is not included with submit
NB.  marks '' default '□▣'
NB.  class '' default is 'jhchk'
NB.  see jhb for more info
jhchk=: 4 : 0
'value check marks class options'=. y addd 0;'□▣';'jhchk';''
class=. gdef class;'jhchk'
marks=. gdef marks;'□▣'
value=. (8 u: check{7 u: marks),' ',value
t=. x jhb value;class;options
t jhaddatts 'data-jhscheck="<CHECK>" data-jhsmarks="<MARKS>"'hrplc 'CHECK MARKS';check;marks
)

NB.* jhclose title - menu with > term pages and close
jhclose=: 3 : 0
t=. jhmenu y
t=. t,'menu0'  jhmenugroup ''
t=. t,'close'  jhmenuitem 'close';'q'
t=. t,         jhmenugroupz''
t=. jhdivz,~jhdiva t
)

NB.* jhdemo'' - html link to defining script
jhdemo=: 3 : 'jhbr,jhijs y'

NB.* id jhdiv text - <div ...>text</div>
jhdiv=: 4 : 0
'<div id="',x,'" class="jhdiv" >',y,'</div>'
)

NB.* [id] jhdiva text - <div id...>text
jhdiva=: 3 : 0
''jhdiva y
:
'<div id="',x,'" class="jhdiv" >',y
)

NB.* jhdivz - </div>
jhdivz=: '</div>'

NB.* id jhd3_basic'' - div for d3 graphics 
jhd3_basic=: 4 : 0
r=. 'redspacer'jhdiv'&nbsp;'
r=. r,LF,(x,'_error')jhdiv''
r=. r,LF,(x,'_header')jhdiv''
r=. r,LF,(x,'_title')jhdiv''
r=. r=. r,LF,x jhdiv''
r=. r,LF,(x,'_legend')jhdiv''
r=. r,LF,(x,'_footer')jhdiv''
(x,'_box')jhdiv LF,r,LF
)

NB.* id jhec html - contenteditable div
jhec=: 4 : 0
t=. '<div id="<ID>" contenteditable="true"',jeditatts
NB. t=. t,' style="white-space:nowrap;" ' - CSS
t=. t,' onkeydown="return jev(event)"'
t=. t,' onkeypress="return jev(event)"'
t=. t,' onfocus="jecfocus();"'
t=. t,' onblur="jecblur();"'
t=. t,'>',y,'</div>'
t hrplc 'ID';x
)

NB.* id jhecwrap html - contenteditable div that wraps
jhecwrap=: 4 : 0
y=. y rplc '&nbsp;';'&nbsp;&ZeroWidthSpace;' NB. breaking space
'<div  class="html" style="overflow-wrap: break-word; white-space: normal;">',y,'</div>'
)

NB.* id jhhidden value - <input type="hidden"....>
jhhidden=: 4 : 0
t=. '<input type="hidden" id="<ID>" name="<ID>" value="<VALUE>">'
t hrplc 'ID VALUE';x;y
)

NB.* [id] jhh1 text - <h1>text</h1>
jhh1=: 3 : 0
''jhhn 1;y
:
x jhhn 1;y
)

NB.* [id] jhhn n;text - <hn>text</hn>
jhhn=: 4 : 0
''jhhn y
:
n=. ":;{.y
a=. '<h',n
b=. '</h',n,'>'
(a,HBSX,'><TEXT>',b)hrplc 'ID CLASS TEXT';x;'jhh1';;{:y
)

NB.* jhr - deprecated - use jhline
jhhr=: '<hr/>' NB. deprecated - use jhline

NB.* [id] jhiframe src[;class[;style]]
NB.  src can be named locale like jfile or object locale like '123'
jhiframe=: 3 : 0
'' jhiframe y
:
idn=. getidn x
'src class style'=. y addd 'jhiframe';''
class=. gdef class;'jhiframe'
s=. ;(-.''-:style){'';' style="',style,'" '
'<iframe ',idn,' src="',src,'" class="',class,'" ',s,' ></iframe>'
)

NB.* jhijs'' - button for edit of defining script
NB.  also creates the ev_jscript_click handler
jhijs=: 3 : 0
c=. ;coname''
c=. '.ijs',~;(_~:_".c){c;{.copath coname''
t=. 4!:3''
s=. (>:;t i:each '/')}.each t
p=. ;(s i: <c){t NB. get last script
JSCRIPT=: p
ev_jscript_click=: jhijshandler
'jscript'jhb'edit source script'
)

NB.* id jhline '' - jhhr with an id
jhline=: 4 : 0
t=. '<hr id="<ID>" name="<ID>" class="jhline" />'
t hrplc 'ID';x
)

NB.* jhmenu title;extra - hamburger menu
jhmenu=: 3 : 0
'title xtras'=. 2{.(boxopen y),<''
c=. coname''
if. Num_j_ e.~{.;c do. c=. ;{.copath c end.
title=. (;c),(0~:#title)#' - ',title
menuids=:   <'menu0' 
menutexts=: <'☰'
menubacks=: <''
r=. ('jmenuburger'jhb'☰';'jmenuburger'),xtras
r=. r,jhbr,~'jmenutitle'jhspan title
)

NB.* id jhmenugroup '' - start manu group
jhmenugroup=: 4 : 0
menuid=: x
i=. menuids i. <x
if. i=#menuids do.  i=. 0 end. NB. user not informed of failure
value=. ;i{menutexts
backid=. ;i{menubacks
more=. '<span class="jmenuspanleft" >',(jhfroma'<  '),'</span>',(x-:'menu0')#'<span class="jmenuspanright">ctrl+,</span>'
t=. '<button id="<ID>" class="jmenuitem" ',jmon,' onclick="return menushow(''<BACK>'')" ><VALUE></button>'
t=. t hrplc 'BACK VALUE';backid;more,jhfroma value
t,~'<div id="<ID>" class="jmenugroup">'rplc '<ID>';x
)

NB.* jhgroupz'' - end menu group
jhmenugroupz=: 3 : '''</div>'''

NB.*  id jhmenuitem 'test'[;esc] - esc is '' or ^? or ?
jhmenuitem=: 4 : 0
'text esc'=. 2{.(boxopen y),<''

select. {.esc
case. ' ' do. t=. ''
case. '^' do. t=. 'ctrl+',1{esc
case.     do. t=. esc
end.
xesc=.  '<span class="jmenuspanright">',t,'</span>'

t=. '<button id="<ID>" class="jmenuitem" ',jmon,' onclick="mmhide();return jev(event)" ><VALUE></button>'
t=. t hrplc 'ID VALUE';x;(jhfroma text),xesc

if. 1=#esc do. jhbsjs=: jhbsjs,'var jmsc',esc,'= "',x,'";',LF end.
t
)

NB.* [id] jhmenulink text;id[;esc]
jhmenulink=: 3 : 0
'' jhmenulink y
:
if. #x do. x=. 'id="',x,'"' end.
'to text esc'=. 3{.y,<''

select. {.esc
case. ' ' do. t=. ''
case. '^' do. t=. 'ctrl+',1{esc
case.     do. t=. esc
end.

esc=.  '<span class="jmenuspanright">',t,'</span>'

menuids=: menuids,<to
menutexts=: menutexts,<text
menubacks=: menubacks,<menuid
more=. '<span class="jmenuspanleft" >&gt&nbsp;</span>'
t=. '<button class="jmenuitem" <ID> ',jmon,' onclick="return menushow(''<TO>'')" ><VALUE></button>'
t hrplc 'ID VALUE TO';x;(more,(jhfroma text),esc);to
)

NB.* id jhpassword '' - password text intput
jhpassword=: 4 : 0
id=. vid x
'value size class options'=. y addd 10;'jhtext';''
size=. gdef size;10
class=. gdef class;'jhpassword'
value=. jhfromax value NB. special jhfroma
t=. '<input type="password" id="<ID>" name="<ID>" class="<CLASS>" ',jeditatts,'placeholder="<VALUE>" '
t=. t,'size="<SIZE>" onkeydown="return jev(event)" >'
t=. t hrplc 'ID CLASS VALUE SIZE';id;class;value;size
t jhaddatts ('~'e.options)#'data-jhsnojdefault="1"'
)

NB.* id jhrad text [;check [;set [;marks [;class [;options]]]]]
NB.  prefered order:text;check;set
NB.  but old style is converted: set;text;check
NB.  set used to change button state in same set
NB.  not input tag type so is not included with submit
NB.  see jhchck for more info
jhrad=: 4 : 0
t=. y addd 0;'rad0';'◯⬤';'jhrad';''
NB. adjust set;text;check to be text;check;set
if. 2~:3!:0>2{t do. t=. (1 2 0{t),3}.t end.
'value check set marks class options'=. t
class=. gdef class;'jhrad'
marks=. gdef marks;'◯⬤'
set=.   gdef set;'rad0'
mark=. 8 u: check{7 u: marks
value=. (8 u: check{7 u: marks),' ',value
t=. x jhb value;class;options
t=. t jhaddatts 'data-jhsset="<SET>" data-jhscheck="<CHECK>" data-jhsmarks="<MARKS>"'hrplc 'SET CHECK MARKS';set;check;marks
)

NB.* jhref page;target;text - deprecated
jhref=: 3 : 0
'page target text'=. y
t=. '<a href="<REF>?jwid=<TARGET>" target="<TARGET>" class="jhref" ><TEXT></a>'
t hrplc 'REF TARGET TEXT';page;target;text
)

NB.* jhresize'' - separate fixed div from resizable div
jhresize=: 3 : '''</div><div id="jresizeb">'''

NB.* id jhselect texts [;size [;sel [;class [;options ]]]]
NB.  dropdown selection box
jhselect=: 4 : 0
id=. vid x
'first arg must be list of boxed texts'assert 2=L.{.y
'values size sel class options'=. y addd '';0;'jhselect';''
size=.  gdef size;0
sel=.   gdef sel;0
class=. gdef class;'jhselect'
t=. '<select id="<ID>" name="<ID>" class="<CLASS>" size="<SIZE>" onchange="return jev(event)" >'
t=. t hrplc 'ID CLASS SIZE';id;class;size
opt=. '<option value="<VALUE>" label="<VALUE>" <SELECTED>><VALUE></option>'
for_i. i.#values do.
 t=. t,LF,opt hrplc'VALUE SELECTED';(i{values),(i=sel){'';'selected="selected"'
end.
t=. t,'</select>'
t jhaddatts ('~'e.options)#'data-jhsnojdefault="1"'
)

NB.* id jhspan text - <span id...>text</span>
jhspan=: 4 : 0
'<span id="',x,'" class="jhspan">',y,'</span>'
)

NB.* [id] jhsplits [style] - separator -- 'style="abc:123"'
jhsplits=: 3 : 0
''jhsplits y
:
 '<div ',(getidn x),' role="separator" tabindex="1" ',y,'></div>'
)

NB.* [id] jhsplitv [style] - vertical - 'style="abc:123"'
jhsplitv=: 3 : 0
''jhsplitv y
:
 '<div ',(getidn x),' data-flex-splitter-vertical ',y,'>'
)

NB.* [id] jhsplith [style] - horizontal - 'style="abc:123"'
jhsplith=: 3 : 0
''jhsplith y
:
 '<div ',(getidn x),' data-flex-splitter-horizontal ',y,'>'
)

NB.* id jhtable '' - html table
jhtable=: 4 : 0
('<table',HBSX,'>')hrplc 'ID CLASS ';x;'jhtable'
)

NB.* jhtable - deprecated - use jhtable
jhtablea=: '<table>' NB. deprecated - use jhtable

NB.* jhtablez - </table>
jhtablez=: '</table>'

NB.* id jhtext text [;cols [;class [;options ]]]
NB.  text box
jhtext=: 4 : 0
id=. vid x
'value size class options'=. y addd 10;'jhtext';''
size=. gdef size;10
class=. gdef class;'jhtext'
value=. jhfromax value
t=. '<input type="text" id="<ID>" name="<ID>" class="<CLASS>" ',jeditatts,'value="<VALUE>" '
t=. t,'size="<SIZE>" onkeydown="return jev(event)" >'
t=. t hrplc 'ID CLASS VALUE SIZE';id;class;value;size
t jhaddatts ('~'e.options)#'data-jhsnojdefault="1"'
)

NB.* jhtextarea*id jhtextarea text [;rows-3;ccols-10]
NB.  textarea html element
NB.* no onkeydown handler
jhtextarea=: 4 : 0
t=.   '<textarea id="<ID>" name="<ID>" class="jhtextarea" wrap="off" rows="<ROWS>" cols="<COLS>" '
t=. t,jeditatts,'><DATA></textarea>'
t hrplc 'ID DATA ROWS COLS';x;3{.(boxopen y),3;10
)

NB.* id jhtitle text
jhtitle=: 4 : 0
'<span id="',x,'" class="jhtitle">',y,'</span><br>'
)

NB*  jhtable data
NB.  y - list of boxed table row data html
jhtr=: 3 : 0
'<tr>','</tr>',~;(<'<td>'),each y,each<'</td>'
)

NB.* id jhurl url [;target [;text] ]
jhurl=: 4 : 0
t=. boxopen y
if. 1=#t do. t=. t,<'_target' end.
if. 2=#t do. t=. t,{.t        end.
'page target text'=. t
t=. '<a id="<ID>" name="<ID>" href="<REF>" target="<TARGET>" class="jhref" ><TEXT></a>'
t hrplc 'ID REF TARGET TEXT';x;page;target;text
)

NB.*.1 verbs/nouns used by jh... verbs

NB. jgrid - special jht for grid
jhtx=: 3 : 0
t=. '<input type="text" id="<ID>" name="<ID>" class="<CLASS>" <EXTRAS>',jeditatts,'value="<VALUE>" size="<SIZE>" onkeydown="return jev(event)" >'
t hrplc 'ID VALUE SIZE CLASS EXTRAS';5{.y,(#y)}.'';'';'';'ht';''
)

NB.* jhbshtml_locale_'' -  show HBS sentences and html
jhbshtml=: 3 : 0
s=.<;._2 HBS
seebox s,.LF-.~each jhbsex each s
)

NB. standard menu on events
jmon=: 0 : 0
onblur="return jmenublur(event);"
onfocus="return jmenufocus(event);"
onkeyup="return jmenukeyup(event);"
onkeydown="return jmenukeydown(event);"
onkeypress="return jmenukeypress(event);"
)

NB. add defaults
addd=: 4 : 0
t=. boxopen x
t,(<:#t)}.boxopen y
)

NB. validate id - id can have blank and anything else
vid=: 3 : 0
id=. dltb y
NB. ('bad id: ',id)assert -.' 'e.id
id
)

voptions=: 3 :0
('invalid options: ',y)assert 0=#y-.' ~='
y
)

NB. get default - '' replaced by default
gdef=: 3 : 0
;(''-:;{.y){y
)

NB. get html id and name from y
getidn=: 3 : 0
a=. vid y
;(-.''-:a){'';' id="A" name="A" 'rplc'A';a
)

NB.* html jhaddatts attributes
jhaddatts=: 4 : 0
i=. x i. '>'
(i{.x),' ',y,i}.x
)

NB.* html jhrematts 'data-...'
jhrematts=: 4 : 0
'currently must be a single name  with no blanks or quotes'assert -.+/' "'e.y
a=. ' ',y,'="'
i=. 1 i.~a E. x
(i{.x),(i+#a)}.x
)

NB. jhijs event handler
jhijshandler=: 3 : 0
t=. pageopenargs'jijs?jwid=',JSCRIPT
jhrcmds'pageopen *',}:;t,each LF
)
