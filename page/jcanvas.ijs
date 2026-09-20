NB. create page with jhjcanvas widget

require'~addons/ide/jhs/widget/jhjcanvas.ijs'

coclass'jcanvas'
coinsert'jgl2'
coinsert'jhs'
NB. coinsert'jhjcanvas'

drawverb=: 3 : 0
)

addlines=: 3 : 0
t=. <;._2 LF,~5!:5 <'drawverb'
a=. <;._2 y
t=. q__=: (}.}:t),a
echo t
drawverb=: 3 : t
i.0 0
)

draw=: 3 : 0
formset 'canvasjs can *',jsxarg__can buffer__can
)

help=: 0 : 0 
jsc... - map directly to javascipt canvas commands
jsx... - jsc extensions - e.g. jsxtext xy;text;ratio
gl...  - gl cmds implemented with jsc commands

   jhshelp'canvas' NB. more info
   jhstour'canvas' NB. drawing to canvas from term
)

gldefault=: 0 : 0
glclear''
glfont 'arial 22'
glpen 4 0 [ glrgb 255 0 0
gllines 0 0,glqwh''
glbrush '' [ glrgb 0 0 255
glrect 100 30 40 40
gltextcolor'' [ glrgb 0 0 0
gltext 'iiiwww click the mouse' [ gltextxy 10 100
)

jscdefault=: 0 : 0
jscbeginPath''
jscclearRect 0 0,glqwh''
jscbeginPath''        NB. start path that will be painted
jsclineWidth 4        NB. pen width
jscstrokeStyle jsxucp'red' NB. red pen
jscmoveTo 0 0         NB. upper left 
jsclineTo glqwh''     NB. lower right
jscstroke''           NB. draw line
jscrect 10 10 300 300
jscstroke''
)

run_last=: ''

HBS=: 0 : 0
jhclose'gl... playground'
'cmds'    jhtextarea gldefault;12;30
jhbr
'runcmds'    jhb 'run'
'gldefault'  jhb 'gl cmds'
'jscdefault' jhb 'jsc cmds'
'help'       jhb 'help'
jhflexa
'can'        jhcanvas ''
jhflexz
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
case. 'resize' do.
 drawverb__can drawarg__can
 paint''
case.          do. jhrcmds''
end.
)

ev_runcmds_click=: 3 : 0
drawverb__can=: 3 : (getv'cmds')
drawarg__can=: ''
drawverb__can drawarg__can
paint''
)

ev_gldefault_click=: 3 : 0
jhrcmds 'set cmds *',gldefault
)

ev_jscdefault_click=: 3 : 0
jhrcmds 'set cmds *',jscdefault
)

ev_help_click=: 3 : 0
glclear''
glfont 'arial 11'
h=. 1.4*0".(GLFONT i.'p'){.GLFONT
jsxtext 10 20;h;help
paint''
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
