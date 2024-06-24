NB. y is noun tool_y_jijx_~ or an expression
NB. allows wrap with &ZeroWidthSpace
tool_jhs_=: 3 : 0
n=. 'tool_',y,'_jijx_'
if. 0=nc<n do. y=. n~ end.
jhtml'<hr>',(''jhecwrap jhtmlfroma y),'<hr>'
)

lablist_jhs_=: lablist_jijx_
labrun_jhs_=: labrun_jijx_

coclass'jijx'
coinsert'jhs'

NB. jijx stuff not directly tied to contenteditable repl

NB. tack on link to JHS wiki
xtool=: 3 : 0
n=. 'tool_',y,'_jijx_'
if. 0=nc<n do. y=. n~ end.
y=. y,LF,'click link for extra info - background, historical and perhaps not relevant to this release',LF
a=. 'https://code.jsoftware.com/wiki/Guides/JHS'
t=. '<div contenteditable="false"><a href="',a,'" target="_blank" >',a,'</a></div>'
jhtml'<hr>',(''jhecwrap (jhtmlfroma y),t),'<hr>'
)

ev_welcome_click=:   3 : 'xtool ''welcome'''
ev_shortcuts_click=: 3 : 'xtool ''shortcuts'''
ev_popups_click=:    3 : 'xtool ''popups'''
ev_closing_click=:   3 : 'xtool ''closing'''

ev_mobile_click=:      3 : 'tool ''mobile'''
ev_guest_rules_click=: 3 : 'tool tool_guest_rules'
ev_guest_files_click=: 3 : 'tool tool_guest_files'

tour=: 4 : 0
jhtml'<hr>'
echo x
spx '~addons/ide/jhs/spx/',y
jhtml'<hr/>'
)

ev_plot_click=:  3 : 0
'plot tour'tour'plot.ijs'
)

ev_overview_click=: 3 : 0
'overview lab'tour'overview.ijs'
)

ev_charttour_click=: 3 : 0
'chart tour'tour'chart.ijs'
)

ev_canvas_click=: 3 : 0
'canvas tour'tour'canvas.ijs'
)

jhs=: 3 : 0
a=. 'recent';'tool';'demo';'app';'lab'
jselect 'run 1 of the following:';(<'   jhs'),each a,each <''''''
)

jhs_z_=: jhs_jijx_

jhstool=: 3 : 0
if. ''-:y do. jselect 'run 1 of the following:',LF,;LF,~each'''',~each (<'   jhstool'''),each tools return. end.
tool_jhs_ y
)

jhsdemo=: 3 : 0
if. ''-:y do. jselect demo_txt,;(<'   jhsdemo'''),each(<;._2 demo_names),each<'''',LF return. end.
rundemo >:(<;._2 demo_names)i. <y
)

jhswiki=: 3 : 0
if. ''-:y do. jselect wiki_txt,;(<'   jhswiki'),each(<;._2 wiki_names),each LF return. end.
jhsvocab y
)

jhsapp=: 3 : 0
if. ''-:y do. jselect tool_app return. end.
runapp y
)

tool_tour=: 0 : 0
overview
chart
canvas
plot
spx
)

jhstour=: 3 : 0
if. ''-:y do. jselect (<'   jhstour '''),each '''',~each<;._2 tool_tour return. end.
jhtml'<hr>'
echo x
spx '~addons/ide/jhs/spx/',y,'.ijs'
jhtml'<hr/>'
)

jhslab=: 3 : 0
if. ''-:y do.
 getlabs''
 t=. <;._2 labs_txt
 jselect t,(<'   jhslab '''),each '''',~each~.LABCATS
 return.
end.
getlabs''
titles=. /:~(LABCATS = <dltb y)#LABTITLES
t=. <'run one of the following sentences:'
jselect t,(<'   jhsrun '),each'''',~each'''',each titles
)

jhstool_z_=:   jhstool_jijx_
jhsdemo_z_=:   jhsdemo_jijx_
jhsapp_z_=:    jhsapp_jijx_
jhslab_z_=:    jhslab_jijx_
jhswiki_z_=:   jhswiki_jijx_
jhstour_z_=:   jhstour_jijx_

ev_recall_click=: 3 : 'jhsline 0{.0'
ev_tool_click=:   3 : 'jhstool 0{.0'
ev_demo_click=:   3 : 'jhsdemo 0{.0'
ev_app_click=:    3 : 'jhsapp  0{.0'
ev_lab_click=:    3 : 'jhslab  0{.0'
ev_tour_click=:   3 : 'jhstour 0{.0'
ev_wiki_click=:   3 : 'jhswiki 0{.0'

jhsrun_z_=:    labrun_jijx_

ev_spx_click=:  3 : 0
'spx tour'tour'spx.ijs'
)

jhsline=: 3 : 0
NB. jjs_jhs_'recent(10);'
i.0 0
)

jhs_z_=: jhsline_jijx_

NB. default ctrl+,./ handlers
ADVANCE=: 'none'

ev_labs_click=:      3 : 'tool tool_labs 0'

NB. iphone se displays to col: 34

tool_simple_project=: sphelp

tool_debug=: 0 : 0
debug facilities: suspend execution at stop or error
 examine/modify values and definitions and continue

NOTE: jdebug into button requires j903 to work properly!

practice before you need it for real!

jijx ide>jdebug - open jdebug
 move tab so you can see jijx and jdebug at same time if possible
    
   dbr 1       NB. enable debug
   calendar'a' NB. will stop on error on dyadic line 0
   y=. 0       NB. fix error
   
press jdebug over button to step through verb
 check values as you move along
 ctrl+quote is same as over button - may be more convenient
 step until the verb is finished
 
   dbxsm'calendar 0:0' NB. stop on monadic/dyadic line 0
   calendar 0

press jdebug run button to run to stop on dyadic line 0

press jdebug over button to step through
)

tool_debugjs=: 0 : 0
browser html/css/javascript debuggers are excellent!
spend time getting familiar with your favorite browser
online docs are good, but mostly you just have to play
ctrl+shift+i might open the dbugger sub window

detect syntax errors with visual studio code (jshint extension)
 or install jshint in nodejs and run jshint cli
 ~/.jshintrc - {"esversion": 6,"multistr": true}
)

tool_react=: 0 : 0
react - popular javascript framework for building apps
you can take an existing react app and integrate it with J
tictactoe is a simple example where J is added to play O

run following sentence to setup tictactoe example:
   runreact_jhs_'tictactoe'
)

tool_node=: 0 : 0
node - commercial server - https://nodejs.org
node https proxy server sits between JHS and client
securely access your JHS server from any device on lan or remote

   load'~addons/ide/jhs/node.ijs'
   node_jhs_''
)

NB. jhslinkurl'www.d3js.org' NB. link to D3 home page
tool_jd3=: 0 : 0
plot d3 uses D3 javascript library
see www.d3js.org for more info
   jd3''
)

tool_chart=: 0 : 0
   jcjs'tutorial'
   jcjs'help'
)

tool_table=: 0 : 0
table (spreadsheet) uses Handsontable javascript library
see www.handsontable.com for more info 
   'jtable;0 0'jpage'n' [ n=. i.3 4
n immediately reflects any changes
edit cells and add new rows/cols
initial data was numeric, so non-numeric is red
   'jtable;20 20'jpage's' [ s=: 2 2$'aa';'b';'c';'dd'
)

tool_app=: 0 : 0 
how to build an app
apps are built with J, JHS framework,
 HTML, CSS, DOM, and javascript
learning curve is long, but not steep
 significant rewards along the way
what you learn is applicable not just to J,
 but to every aspect of web programming
JHS IDE is built with the same facilities
run and study each script/app in order
   runapp_jhs_ N [;xywh]
    - copies appN.ijs to ~temp/app
    - runs and opens script in a tab
    - opens app in a tab or at xywh
move script and app so you can study them
run 1 of the following:
<RUNAPP>
)

t=. <;.2 gettitles'' NB. app titles
t=. 3}.each t 
i=. t i. each '-'
t=. (i{.each t),each(<'NB.'),each }.each i}.each t
t=. (<'   jhsapp '),each t
t=. }:;t 


tool_app=: tool_app rplc'<RUNAPP>';t

tool_print=: 0 : 0
simple printing
     print_jhs_       'abc';i.2 3 4
   0 print_jhs_       'display without print dialog'
     printscript_jhs_ '~addons/ide/jhs/config/jhs.cfg'
   0 printscript_jhs_ '~addons/ide/jhs/config/jhs.cfg'
   printwidth_jhs_=: 80 NB. truncate longer lines with ... 
   printstyle_jhs_=: 'font-family:"courier new";font-size:16px;'
)


wiki_txt=: 0 : 0
look up things in the wiki
)

wiki_names=: 0 : 0
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

demo_txt=: 0 : 0
simple apps showing JHS gui programming
run demos to see some of the possibilities
study the source to see how it is done
study menu tool>app first as the source
will make more sense after that
run 1 of the following:
)

NB. sentence list should be built from demo folder files
demo_names=: 0 : 0
Roll submit
Roll ajax
Flip ajax
Controls/JS/CSS
Plot
Grid editor
Table layout
Dynamic resize
frames
Ajax chunks
Ajax interval timer
WebGL 3d graphics
D3 line and bar plots
D3 iframes - spreadsheet/graph
Flip - no javascript
pswd gen - no javascript
burger menu
)


tool_watch=: 0 : 0
   'jwatch;0 0' jpage '?4 6$100' NB. watch an expression
)

labs_txt=: 0 : 0
labs - interactive tutorials
labs are organized in categories
run 1 of the following:
)

tool_welcome=: 0 : 0
welcome - browser interface to J

new in this release:
click me button
☰ menu
overview tour improved
guest info
mobile right hand buttons
jterm (jijx) wrap/nowrap
)

tool_guest_rules=: tool_guest_files=: 'this session is not a server guest'

tool_mobile=: 0 : 0
mobile real keyboard is great!
mobile soft kb takes practice

mobile jterm page has 3 buttons on the right:
 green - ctrl+.
 blue  - ctrl+shift+↑
 red   - ctrl+shift+↓

mobile esc key is soft keyboard è
(iOS press e and slide up)
)

tool_shortcuts=: 0 : 0
☰ indicates shortcuts
browser uses most ctrl shortcuts
J esc shortcuts avoid conflict

esc-f - press and release esc then f

undo/cut/copy/paste/redo
 ctrl+zxcvy - standard

J ctrl shortcuts are supported for
 ,./<>?

custom jterm (jijx) handler for ctrl+?
ev_query_ctrl_jijx_=: 3 : 'i.5'
)

tool_popups=: 0 : 0
JHS works best if pop-ups allowed
some browers require permission
some browsers let you configure
 (make as restrictive as possible)

   edit'jnk.txt' NB. requires pop-up
)

tool_closing=: 0 : 0
close J page with ☰.close/quit
 or Esc-q
this lets J manage the close
 (save changes and free up resources)
browser close button misses these steps
)

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

NB. could be used to exclude labs - see exlabs.txt
EXJHS=: 0 : 0
)

excludes=: 3 : 0  NB. based on excludes_jlab805_ with a different final line
t=. 'b' fread '~addons/labs/labs/exlabs.txt'
if. t-:_1 do. y return. end.
t=. t #~ '#' ~: {.&> t
0!:100 ; t ,each LF
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

tool_labs=:3 : 0
getlabs''
if. 0=#LABCATS do.
 t=. 'No labs installed.',LF,'Do jal (pacman) labs/labs install and try again.'
else.
 t=. labs_txt
 d=. /:~~.LABCATS
 t=. t,;LF,~each(<'   lablist_jhs_ '),each'''',~each'''',each d
end.
t
)

lablist=: 3 : 0
getlabs''
titles=. /:~(LABCATS = <dltb y)#LABTITLES
echo'run one of the following sentences:'
echo ;LF,~each (<'   labrun_jhs_ '),each'''',~each'''',each titles
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

tools=: (5}.each'tool'nl_jijx_ 0)-.'welcome';'guest';'shortcuts';'popups';'closing' NB. remove those in the ? menu

NB. validate tools:
NB. ;".each(<'_jijx_'),~each(<'tool_'),each tools_jijx_

toollist=: 3 : 0
echo'run 1 of the following:',LF,;LF,~each'''',~each (<'   tool_jhs_ '''),each tools
)