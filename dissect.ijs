0 : 0
   loaddissect_z_'' NB. load bits and pieces
   dissect'0'
)

NB. create page with jhjcanvas widget
run_dissect_=: {{
q__=: p=: 'dpoc;10 10 600 600;Dissect gl2 Proof of Concept'jpage''[y 
caller__p=: coname''
}}

NB.! smaller handle doesn't work so well
RESIZEHANDLEXYWH_dissect_ =: 2 2 $ _6 _6 12 12

coclass'dpoc'
coinsert'jhs'
coinsert'jhjcanvas'

HBS=: 0 : 0
jhclose'Dissect gl2 Proof of Concept'
'reset' jhb'<<'
'undo'  jhb'<' NB. dissect_fmbwd_button
'redo'  jhb'>'
NB. 'redraw' jhb'redraw'
'stat'  jhspan'statline'
'</div>' NB. enable flex
'can'   jhiframe (;'can'~);'';'flex:auto;' 
'<div>'  NB. restart main div
)

CSS=: 0 : 0
#can{width:100vw;height:100vh;border: 2px solid red;}
)

ev_create=: 3 : 0
can=: 'jhjcanvas;_'jpage ''
setrefresh__can jsxnew jscfont jsxucp '16pt ',PC_FONTFIXED
shown=: 1
)

destroy=: 3 : 0
if. shown do. close ;coname'' end.
destroy__can'' NB.! should destroy all widgets
codestroy''
)

ev_close_click=: 3 : 0
destroy__caller'' NB. destroy dissect locales
jhrajax''
shown=: 0 NB. already closed
destroy''
i.0 0
)

0 : 0
wd sysdata
0 cursor x position
1 cursor y position
2 x width of the isigraph control
3 y height of the isigraph control
4 boolean: Left button was down
5 boolean: Middle button was down
6 boolean: CTRL was down
7 boolean: SHIFT was down
8 boolean: Right button was down
9 always 0
10 always 0
11 mouse-wheel movement, in degrees (negative if toward the user) 
)

getsysdata=: 3 : 0
t=. 0".getv'jdata' NB. x y width height down/up
":t,0 0 0 0 0 0 
)

ev_reset_click=: 3 : 0
dissect_fmshowerror_button__caller ''
paint''
)

ev_undo_click=: 3 : 0
dissect_fmbwd_button__caller ''
paint''
)

ev_redo_click=: 3 : 0
dissect_fmfwd_button__caller ''
paint''
)

ev_mouse_click=: 3 : 0
sd=. getsysdata''
NB. echo'mouse click ',sd
jhrcmds''
)

ev_mouse_down=: 3 : 0
sd=. getsysdata''
NB. echo'mouse down ',sd
sysdata__caller=: sd
dissect_dissectisi_mbldown__caller sd
jhrcmds''
)

ev_mouse_up=: 3 : 0
sd=. getsysdata''
NB. echo'mouse up ',sd
sysdata__caller=: sd
dissect_dissectisi_mblup__caller sd
paint''
)

NB. ignore mouse move - too slow 
ev_mouse_move=: 3 : 0
sd=. getsysdata''
NB. echo'mouse move ',sd
sysdata__caller=: sd
dissect_dissectisi_mmove__caller sd

NB. jhrcmds 'set -stat *',status__caller
paint''
)

ev_mouse_resize=: 3 : 0
NB. echo'mouse resize'
firstpaint''
)

NB. called from body load
firstpaint=: 3 : 0
NB. echo'firstpaint'
dissect_dissectisi_paint__caller 1
paint''
)

xxxev_update_click=: 3 : 0
pix__=: getv'jdata'
jhrcmds''
)

ev_redraw_click=: 3 : 0
jhrcmds'set stat *fubar'
)


ev_update_click=: 3 : 0
glclear''
paint''
)

status=: ''

paint=: 3 : 0
c=. <'canvasjs ','can',' *',jsxarg jsxnew''
c=. c,<'set -stat *',status__caller
jhrcmds c
)

markmouse=: 3 : 0
d=.getv'jdata'
xy=. 2{.0".d
drawbox xy;0 0 0;255 255 255;255 0 0;'Mouse: ',d
paint''
)

JS=: 0 : 0
function xxxev_body_load(){
 jbyid('can').contentWindow.init();
}
)