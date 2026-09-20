NB. jhcanvas creates jpage and uses as src in iframe
require'~addons/ide/jhs/gl2.ijs'
coclass'jhjcanvas'
coinsert'jhs'
coinsert'jgl2'

drawverb=: 3 : 'i.0 0'
drawarg=: ''
buffer=: ''

draw=: 3 : 0
drawarg=: y NB. used by resize
drawverb y
formset__PARENT 'canvasjs can *',jsxarg buffer
)

ev_create=: 3 : 0
PARENT=: COCREATOR
buffer=: ''
JHSCANVAS__PARENT=: coname''  NB. default gl target
JHSCANVAS=: coname''          NB. point at ourselves
canvaspixels=: 0 NB. length of pixels buffer for qpixels and pixels  
JS=: (fread'~addons/ide/jhs/widget/jhjcanvas.js')hrplc'BUFFER';''
)

destroy=: 3 : 0
if. shown do. close ;coname'' end.
codestroy''
)

NB. all events come here and are passed to form ev_id_canvas
jev_canvas=: 3 : 0
d=. getv'jdata'
jdata=: d
d=. <;._2 d,' '
eventdata=: ;0".each 12{.d
'canvaswidth canvasheight canvasfontwidth canvasfontheight'=: ,0".each 2 3 12 13{d
'eventtype eventid'=: 14 15{d
eventlostcount=: 0".;16{d
('ev_',eventid,'_canvas__PARENT')~ 0 NB. call handler for id in form
)

HBS=: 0 : 0
'<canvas id="canvas" </canvas>'
)

CSS=: '' NB. can width,height cause scaling

fixcmds=: 3 : 0
a=. (<': '),~each (<'case '),each   ":each<"0 i.#y
;LF,~each a,each (<'(d);break;'),~each   (<'jsc'),each y
)

findx=:'findwindowbyJWID("jcanvasplay?jlocale=<LOC>").jbyid("can").contentDocument.defaultView.doit("<CMDS>");'

find=: 'findwindowbyJWID("jglplay?jlocale=<LOC>").jbyid("can").contentDocument.defaultView.doit("<CMDS>");'

run=: 3 : 0
'loc id data'=: y
jjs_jhs_ find rplc '<LOC>';(;loc);'<CMDS>';jsxarg data
)
