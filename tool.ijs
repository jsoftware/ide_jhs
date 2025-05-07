NB. jijx help sysetem
NB. iphone se displays to col: 34

jhsrun_z_=:  labrun_jijx_
jhshelp_z_=: jhshelp_jijx_
jhsget_z_=:  jhsget_jijx_
jhslab_z_=:  jhslab_jijx_
jhswiki_z_=: jhswiki_jijx_
jhstour_z_=: jhstour_jijx_

coclass'jijx'
coinsert'jhs'

jhshelp=: 3 : 0
jselect gethelp y
)

gethelp=: 3 : 0
t=. fread'~addons/ide/jhs/help.txt'
n=. 'GRULES GFILES WIKI TOOL TOUR CATEGORIES'
t =. t hrplc n;tool_guest_rules;tool_guest_files;(getwiki'');(gettool'');(gettour'');(getcategories'')
d=. <;.2 t,LF
b=. (<'***')=3{.each d
h=. b <;.1 d
s=. ;{.each h
i=. s i. <'***start ',y,LF
if. i=#s do. y,' - topic not found' return. end.
t=. ;}.;i{h
b=. t=LF
(b i. 0)}.(>:b i: 0){.t
)

walkhelp=: 3 : 0
r=. LF,'<div class="jhdiv" id="help-',y,'" >'
t=. '   jhshelp ''',y,''''
r=. r,'<b>',t,'</b>',LF
d=. gethelp y
NB. fix jhshelp to be link to id
d=. <;.2 d,LF
b=. (<'jhshelp')=7{.each dltb each d
b=. b#i.#d
for_i. i.#b do.
 t=. dltb ;(i{b){d
 t=. (t i: ''''){.t
 t=. (>:t i. '''')}.t
 d=.  (<'<a href="#help-',t,'">','   jhshelp ''',t,'''</a><br>')    (i{b)}d
end. 
d=. ;d
r=. r,d,'</div>'
d=. <;._2 LF,~gethelp y
for_i. i.#d do.
 n=. dltb ;i{d
 if. -.'jhshelp'-:7{.n do. continue. end.
 if. 'jhshelp'''''-:9{.n-.' ' do. continue. end.
 r=. r,".'walkhelp',7}.n
end. 
r
)

NB. jhsget 'app/app01'
NB. jhsget 'app/app01';arg
jhsget=: 3 : 0
'p a'=. 2{.(boxopen y),<''
f=. '~temp/jhs/',p,'.ijs'
i=. p i. '/'
c=. (>:i)}.p
b=. i{.p
t=. '~addons/ide/jhs/',p,'.ijs'
'source file does not exist'assert fexist t
1!:5 :: [ <jpath'~temp/jhs/',b
(fread t)fwrite f
load f
echo 'source file: ',t
echo 'temp file created and loaded'
echo '   edit''',f,''''
echo 'object locale created as instance of: ', c
c jpage a
)

NB. jijx stuff not directly tied to contenteditable repl

tour=: 4 : 0
jhtml'<hr>'
echo x
spx '~addons/ide/jhs/spx/',y
jhtml'<hr/>'
)

jhsgif=: 3 : 0
t=. '<div class="gif"><img src="~addons/ide/jhs/src/gif/<FILE>.gif"  width="500" height="400"/><div>'rplc'<FILE>';y
t=. t,'<br><button id="gifstop" name="gifstop" class="jhb"style="width:500px" onclick="removeElementsByClass(''gif'');return true;" >stop</button>'
jhtml t
)
jhsgif_z_=: jhsgif_jijx_

getwiki=: 3 : 0
;(<'   jhswiki '),each(<;._2 wiki_names),each LF
)

gettool=: 3 : 0
;(<'   jhshelp '),each(<;._2 tool_names),each LF 
)

gettour=: 3 : 0
;(<'   jhstour '),each(<;._2 tour_names),each LF
)

getcategories=: 3 : 0
getlabs''
'lab categories',LF,;LF,~each (<'   jhslab '),each'''',~each'''',each ~.LABCATS
)

jhswiki=: 3 : 0
if. ''-:y do. jselect getwiki'' return. end.
jhsvocab y
)

jhstour=: 3 : 0
if. ''-:y do. jselect ;(<'   jhstour'),each(<;._2 tour_names),each LF return. end.
jhtml'<hr>'
spx '~addons/ide/jhs/spx/',y,'.ijt'
jhtml'<hr/>'
)

jhslab=: 3 : 0
if. ''-:y do. jselect getcategories'' return.  end.
getlabs''
titles=. /:~(LABCATS = <dltb y)#LABTITLES
titles=. /:~(LABCATS = <dltb y)#LABTITLES
t=. <'run one of the following sentences:'
jselect t,(<'   jhsrun '),each'''',~each'''',each titles
)

wiki_names=: 0 : 0
''
'voc'  NB. NuVoc vocabulary
'i.'   NB. edit i. for others - click Dyad for x i. y
'if.'  NB. control words
'!:'   NB. foreigns
'12x'  NB. constants
'a'    NB. ancilliary 
'std'  NB. standard library
'rel'  NB. J release notes
'JHS'  NB. JHS info
'807'  NB. 807 legacy html
'main' NB. main page
)

tool_names=: 0 : 0
'man'     NB. man'jhsoption'
'print'   NB. hardcopy
'table'   NB. spreadsheet
'node'    NB. server
'jd3'     NB. D3 javascript plot library
'debugjs' NB. javascript
)

tour_names=: 0 : 0
''
'overview' NB. start here!
'chart'    NB. plot
'canvas'   NB. draw
'plot'     NB. other ways to plot
'spx'      NB. projects 
)

ev_overview_click=: 3 : 0
'overview lab'tour'overview.ijt'
)

ev_spx_click=:  3 : 0
'spx tour'tour'spx.ijt'
)

NB. default ctrl+,./ handlers
ADVANCE=: 'none'

tool_simple_project=: sphelp

tool_watch=: 0 : 0
   'jwatch;0 0' jpage '?4 6$100' NB. watch an expression
)

NB. following are still used!
tool_guest_rules=: tool_guest_files=: 'this session is not a server guest'

getlabs=: 3 : 0
LABFILES=: f=. excludes ,{."1 dirtree'~addons/*.ijt' NB. exclude inserted to remove excluded labs - see exlabs.txt
d=. (>:#jpath'~addons')}.each f
d=. (;d i: each '/'){.each d
b=. ;(<'labs/labs/')=10{.each d
d=. (b*10)}.each d
d=. (<'addons') ((-.b)#i.#d)}d
LABCATS=: d
t=. toJ each fread each f
t=. (t i.each LF){.each t
t=. (>:each t i.each ':')}.each t
t=. t-.each ''''
t=. deb each t
LABTITLES=: t
)

excludes=: 3 : 0  NB. based on excludes_jlab805_ with a different final line
t=. 'b' fread '~addons/labs/labs/exlabs.txt'
if. t-:_1 do. y return. end.
t=. t #~ '#' ~: {.&> t
0!:100 ; t ,each LF

NB. add jhs only files
EXJHS=: EXJHS,;LF,~each (#jpath'~addons/')}.each 1 dir'~addons/ide/jhs/spx/*.ijt'

r=. EXALL
if. IFJHS do.
 r=. r,EXJHS
elseif. IFQT do.
 r=. r,EXJQT
elseif. IFJNET do.
 r=. r,EXJNET
end.
r=. ((jpath '~addons/'),deb) each <;._2 r
y #~ -. y e. r                       NB. This line is different from the jlab805 version as LABFILES is a list
)

labrun=: 3 : 0
f=. ;LABFILES{~LABTITLES i. <dltb y
echo ;f
ADVANCE=: 'lab'
require__'~addons/labs/labs/lab.ijs'

NB. restore spx
spx__=:    spx_jsp_
spx_jhs_=: spx_jsp_

ADVANCE_jlab_=: 'To advance, press ctrl+.'
smselout_jijs_=: smfocus_jijs_=: [ NB. allow introcourse to run
echo'JHS lab advance - ctrl+. or menu >'
lab_jlab_ f
)
