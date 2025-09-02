NB. create page with jhjcanvas widget
NB. jsx... gl... playground
run=: {{ p=: 'jcanvasx;10 10;Dissect gl2 Proof of Concept'jpage''[y }}

require'~addons/ide/jhs/widget/jhjcanvas.ijs'

coclass'jcanvasx'
coinsert'jhs'
coinsert'jhjcanvas'

width=:  height=: 2000 NB. hardwired canvas

default=: 0 : 0
glpen 4 0 [ glrgb 255 0 0
gllines 0 0 50 50
glbrush '' [ glrgb 0 0 255
glrect 100 30 40 40
gltextcolor'' [ glrgb 0 0 0
gltext 'click the mouse' [ gltextxy 10 100
)

HBS=: 0 : 0
jhclose'gl... and jsc... playground'
'cmds'    jhtextarea default;7;30
jhbr
'runcmds' jhb 'runcmds'
'clear'   jhb 'clear canvas'
'default' jhb 'default commands'
'</div>' NB. enable flex
'can'jhiframe (;'can'~);'';'flex:auto;' 
'<div>'  NB. restart main div
)

CSS=: 0 : 0
#cmds{width:100vw;}
#can{width:100vw;height:100vh;border: 4px solid red;}
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

NB. called from canvas iframe

firstpaint=: 3 : 0
jhrcmds''
)

ev_mouse_click=: 3 : 0
markmouse'green'
)

ev_mouse_resize=: 3 : 0
jhrcmds''
)

ev_mouse_down=: ev_mouse_up=: ev_mouse_move=: jhrcmds

ev_runcmds_click=: 3 : 0
c=. getv'cmds'
c=. c,(LF~:{:c)#LF
".each <;._2 c
paint''
)

ev_clear_click=: 3 : 0
jscbeginPath''
jscclearRect 0 0,width,height
paint''
)

ev_default_click=: 3 : 0
jhrcmds 'set cmds *',default
)

paint=: 3 : 0
jhrcmds 'canvasjs ','can',' *',jsxarg jsxnew''
)

markmouse=: 3 : 0
d=.getv'jdata'
xy=. 2{.0".d
drawbox xy;0 0 0;255 255 255;255 0 0;'Mouse: ',d
paint''
)

NB. drawbox x y;border;fill;textcolor;text
drawbox=: 3 : 0
'xy border fill textcolor text'=: y
glrgb border
glpen 2 0
glrgb fill
glbrush''

NB. calc width based on font and text
w=. 40+>.0.5+fontwidth__can*#text

xywh=: xy,w,2*fontheight__can
glrect xywh

gltextxy (20+{.xywh),fontheight__can+1{xywh
glfont''
glrgb textcolor
gltextcolor''
gltext text
)

NB. unused jsc... examples
xxxmarkmouse=: 3 : 0
'a b c'=. 0".getv_jhs_'jdata'
jsxnew''
jscbeginPath''
jscfillStyle jsxucp y
jscarc a,b,5,0,(jsxradian 2*o.1),1
jscfill''
paint''
)
