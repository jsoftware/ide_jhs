NB. create page with jhjcanvas widget

require'~addons/ide/jhs/widget/jhjcanvas.ijs'

coclass'jcanvasplay'
coinsert'jhs'
coinsert'jhjcanvas'

default=: 0 : 0
jsxnew''
jscbeginPath''        NB. start path that will be painted
jsclineWidth 4        NB. pen width
jscstrokeStyle jsxucp'red' NB. red pen
jscmoveTo 0 0         NB. upper left 
jsclineTo jsxwh       NB. lower right
jscstroke''           NB. draw line
jscrect 10 10 300 300
jscstroke''
)

HBS=: 0 : 0
jhclose'canvas... playground'
'cmds'    jhtextarea default;12;30
jhbr
'runcmds' jhb 'runcmds'
'clear'   jhb 'clear canvas'
'default' jhb 'default commands'
'</div>' NB. enable flex
'can'jhiframe (;'can'~);'';'flex:auto;' 
'<div>'  NB. restart main div
)

CSS=: 0 : 0
#cmds{width:100vw;resize:none;}
#can{width:100vw;height:100vh;border: 4px solid red;}
)

ev_create=: 3 : 0
can=: 'jhjcanvas;_'jpage ''
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

NB. all canvas events come here - fan out to handler
NB. see gl2.ijs for jdata values
NB. see dissect for examples
ev_can_canvas=: 3 : 0
select. ;14{<;._1 ' ',getv'jdata'
case. 'down'   do. markmouse 255 0 0
case. 'up'     do. markmouse 0 255 0
case.          do. jhrcmds''
end.
)

ev_runcmds_click=: 3 : 0
c=. getv'cmds'
c=. c,(LF~:{:c)#LF
".each <;._2 c
paint''
)

ev_clear_click=: 3 : 0
glclear''
paint''
)

ev_default_click=: 3 : 0
jhrcmds 'set cmds *',default
)

paint=: 3 : 0
jhrcmds 'canvasjs ','can',' *',jsxarg jsxnew''
)

markmouse=: 3 : 0
ab=. 2{.0".getv'jdata'
glpen 1 0 [ glrgb y
glbrush '' [ glrgb y
r=. 1 1
glellipse (ab-r),2*r
paint''
)

