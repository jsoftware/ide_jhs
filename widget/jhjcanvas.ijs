NB. jhcanvas creates jpage and uses as src in iframe

0 : 0
usage:
can=: 'jhjcanvas;_'jpage ''
setrefresh__can jsxnew jscfont jsxucp '12pt ',PC_FONTFIXED
)

require'~addons/ide/jhs/gl2.ijs'

coclass'jhjcanvas'
coinsert'jhs'
coinsert'jgl2'

ev_create=: 3 : 0
PARENT=: COCREATOR
buffer=: ''
JHSCANVAS_z_=: coname'' 
canvaspixels=: 0 NB. length of pixels buffer for qpixels and pixels  
refresh=: ''
JS=: (fread'~addons/ide/jhs/widget/jhjcanvas.js')hrplc'BUFFER';jsxarg refresh
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

NB. set initial state and reset after resize
setrefresh=: 3 : 0
JS=: JS,LF,'buffer="',(jsxarg y),'"',LF
)


   