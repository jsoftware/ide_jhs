NB. jhcanvas creates jpage and uses as src in iframe

0 : 0
usage:
can=: 'jhjcanvas;_'jpage ''
setrefresh__can jsxnew jscfont jsxucp '12pt ',PC_FONTFIXED

jjs_jhs_'findwindowbyJWID("jcanvasx?jlocale=176").jbyid("can").contentWindow.jbyid("can").width=300'
)

0 : 0
query to browser
when the canvas page is created by ev_body_load
 creates the canvas context, and based on either a default font
 or font set in the initial command buffer
 gets text metrics and calls the server ev_query_event handler
 to set fontwidth,fonthweight

following do not work - would be nice if it did
jjs_jhs_'qdata= "mumble";callj(qdata);'
jjs_jhs_'qdata= "mumble";setTimeout(function(){callj(qdata);},200);
)

NB. dev tools and experiments

NB. JWID run doit_cmds
run=: 4 : 0
jjs_jhs_ 'findwindowbyJWID("',x,'").jbyid("can").contentWindow.doit("',(jsxarg y),'");'
)

NB. y is locale number from page title
getwh=: 3 : 0
t=. 'var w= findwindowbyJWID("dpoc?jlocale=',(":y),'").jbyid("can").contentWindow.jbyid("can");alert(w.width+" "+w.height)'
jjs_jhs_ t
)

getwh=: 3 : 0
t=. 'var el= findwindowbyJWID("dpoc?jlocale=',(;q),'").jbyid("can").contentWindow.jbyid("can");alert(el.clientWidth+" "+el.clientHeight)'
jjs_jhs_ t
)

getwhx=: 3 : 0
t=. 'var el= findwindowbyJWID("dpoc?jlocale=',(;q),'").jbyid("can");alert(el.clientWidth+" "+el.clientHeight)'
jjs_jhs_ t
)

fix=: 3 : 0
t=. 'var el= findwindowbyJWID("dpoc?jlocale=',(;q),'").jbyid("can").contentWindow.jbyid("can");'
t=. t,'el.height=',y,';'
jjs_jhs_ t
)

NB. el.parentElement.clientHeight

require'~addons/ide/jhs/gl2.ijs'

coclass'jhjcanvas'
coinsert'jhs'
coinsert'jgl2'

ev_create=: 3 : 0
PARENT=: COCREATOR
buffer=: ''
JHSCANVAS_z_=: 'buffer_',(;coname''),'_'
gsellocale_jgl2_=: coname'' NB. gsel???
refresh=: ''
JS=: (fread'~addons/ide/jhs/widget/jhjcanvas.js')hrplc'BUFFER';jsxarg refresh
)

NB. pass mouse click to parent
ev_mouse_click=: 3 : 0
ev_mouse_click__PARENT''
)

ev_mouse_down=: 3 : 0
ev_mouse_down__PARENT''
)

ev_mouse_up=: 3 : 0
ev_mouse_up__PARENT''
)

ev_mouse_move=: 3 : 0
ev_mouse_move__PARENT''
)

ev_mouse_resize=: 3 : 0
'canvaswidth canvasheight canvasfontwidth canvasfontheight'=: 0".getv'jdata'
ev_mouse_resize__PARENT''
)

HBS=: 0 : 0
'<canvas id="can" </canvas>'
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


   