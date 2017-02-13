coclass'jijx'
coinsert'jhs'

tool=: 3 : 0
jhtml'<hr>'
echo y
jhtml'<hr>'
)

ev_table_click=: 3 : 'tool tool_table'
ev_jd3_click=:   3 : 'tool tool_jd3'
ev_app_click=:   3 : 'tool tool_app'
ev_print_click=: 3 : 'tool tool_print'
ev_doc_click=:   3 : 'tool tool_doc'
ev_demo_click=:  3 : 'tool tool_demos'
ev_watch_click=: 3 : 'tool tool_watch'
ev_debug_click=: 3 : 'tool tool_debug'
ev_sp_click=:    3 : 'tool sphelp'
ev_labs_click=:  3 : 'tool tool_labs 0'


NB. jhslinkurl'www.d3js.org' NB. link to D3 home page
tool_jd3=: 0 : 0
plot d3 uses D3 javascript library
see menu help>JHS help>libraries for more info

   jd3''
)

tool_table=: 0 : 0
table (spreadsheet) uses Handsontable javascript library
see menu help>JHS help>libraries for more info

   'jtable;0 0'cojhs'n' [ n=. i.3 4

n immediately reflects any changes

edit cells and add new rows/cols
initial data was numeric, so non-numeric is red

   'jtable;20 20'cojhs's' [ s=: 2 2$'aa';'b';'c';'dd'

ctrl+\ or red button in corner to properly close app
)

tool_app=: 0 : 0
how to build an app

apps are built with J, JHS framework, html, css,
DOM (document object model), and javascript

learning curve is long, but not steep
significant rewards along the way
what you learn is applicable not just to J,
but to every aspect of web programming

JHS IDE is built with the same facilities

run and study each script/app in order

   runapp_jhs_ N
    - copies appN.ijs to ~temp/app
    - runs and opens script in a tab
    - opens the app in a tab
move the 2 new tabs so you can easily study them

 1 HBS - html
 2 JS - javascript event handlers
 3 J event handlers
 4 CSS - cascading style sheets
 5 INC - include css/js libraries
 6 state info
 
   runapp_jhs_ 1
)

tool_doc=: 0 : 0
brief utilities summary

   doc_jhs_''     NB. general
   doc_jhs_'html' NB. app building - html
   doc_jhs_'js'   NB. app building - javascript
)

tool_print=: 0 : 0
simple printing
     print_jhs_       'abc';i.2 3 4
   0 print_jhs_       'display without print dialog'
     printscript_jhs_ '~addons/ide/jhs/config/jhs.cfg'
   0 printscript_jhs_ '~addons/ide/jhs/config/jhs.cfg'

   printwidth_jhs_=: 80 NB. truncate longer lines with ... 
   printstyle_jhs_=: 'font-family"courier new";font-size:16px;'
)

tool_demos=: 0 : 0
simple apps showing JHS gui programming
run demos to see some of the possibilities

study the source to see how it is done
study menu tour>app first as the source
will make more sense after that

1  Roll submit
2  Roll ajax
3  Flip ajax
4  Controls/JS/CSS
5  Plot
6  Grid editor
7  Table layout
8  Dynamic resize
9  frames
10 Ajax chunks
11 Ajax interval timer
12 WebGL 3d graphics
13 D3 line and bar plots
14 iframes - spreadsheet/graph

   rundemo_jhs_ 1
)

tool_watch=: 0 : 0
   'jwatch;0 0'cojhs '?4 6$100' NB. watch an expression
)

tool_labs_txt=: 0 : 0
labs - interactive tutorials - a good way to learn J
labs are installed by jal (menu ide>jal)
labs are not always current and may run with errors
labs are organized into categories
run one of the following sentences:
)

tool_labs=:3 : 0
getlabs''
if. 0=#LABCATS do.
 t=. 'No labs installed.',LF,'Do jal (pacman) labs/labs install and try again.'
else.
 t=. tool_labs_txt
 d=. ~.LABCATS
 t=. t,;LF,~each(<'   lab '),each'''',~each'''',each d
end.
t
)

lab=: 3 : 0
t=. dltb y
alltitles=. dltb each (>:;LABTITLES i.each ':')}.each LABTITLES
if. (#LABCATS)>LABCATS i. <t do. 
 titles=. (LABCATS = <t)#alltitles
 echo'run one of the following sentences:'
 echo ;LF,~each (<'   lab '),each'''',~each'''',each titles
 echo 'to advance, press ctrl+. or click menu > item'
else.
 f=. LABFILES{~alltitles i. <t
 ADVANCE=: 'lab'
 require__'~addons/labs/labs/lab.ijs'
 ADVANCE_jlab_=: 'To advance, press ctrl+. or click menu > item.'
 smselout_jijs_=: smfocus_jijs_=: [ NB. allow introcourse to run
 labinit_jlab_ f
end.
)

lab_z_=: lab_jijx_

labopen=: 3 : 0
'c n'=. y
f=. LABFILES{~<:n+LABCATS i. (<:c){~.LABCATS
ADVANCE=: 'lab'
require__'~addons/labs/labs/lab.ijs'
ADVANCE_jlab_=: 'To advance, press ctrl+. or click menu > item.'
smselout_jijs_=: smfocus_jijs_=: [ NB. allow introcourse to run
labinit_jlab_ f
)

labopen_jhs_=: labopen_jijx_
