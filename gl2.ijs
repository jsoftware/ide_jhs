NB. list of gl cmds that echo
gllist=: ;:'' NB. glrect glsel 

0 : 0
gl2 definitions
drawing commands are jsc... or gl2...
jsc commands map directly to javascript canvas commands
jsx commands manage the jsc buffer etc
gl2 commands are defined with jsc commands

gl2 mouse event sysdata
0  cursor x position
1  cursor y position
2  x width of the isigraph control
3  y height of the isigraph control
4  boolean: Left button was down
5  boolean: Middle button was down
6  boolean: CTRL was down
7  boolean: SHIFT was down
8  boolean: Right button was down
9  always 0
10 always 0
11 mouse-wheel movement, in degrees (negative if toward the user)
12 font height - JHS extra
13 font width  - JHS extra
14 type        - up/down/move/resize - JHS extra
15 id          - JHS extra
16 lost        - count of lost events - JHS extra
)

NB. gl2 covers for jsc...
coclass 'jgl2'

gl2log=: 3 : 0
'n d'=: y
if. -.(<n) e. gllist__ do. return. end.
if. 2=3!:0 d do.
 t=. n,' ''',d,''''
else.
 t=. n,' ',":,d
end. 
echo t,' NB. ',;coname''
)

NB. css hex colors - transparency is first
gethex=: 3 : 0
assert 4=#y
'#',(,16 16 #: y){'0123456789abcdef'
)

NB. GL state info for jsc
GLCOLOR=:  gethex 0 0 0 255
GLTEXTXY=: 100 100
GLTEXTCOLOR=: GLCOLOR
GLBRUSHNULL=: 0

NB. draw 0 or more lines (4 values for each)
NB. gl2 docs says 'connected lines'
NB. but that seems to be wrong
NB. y can be matrix 
gllines=: 3 : 0
y=. ,y
gl2log 'gllines';y
while. #y do.
 jscbeginPath''        NB. start path that will be painted
 jscmoveTo 0 1{y
 jsclineTo 2 3{y
 jscstroke''           NB. draw line
 y=. 4}.y
end. 
)

glrgb=: 3 : 0
glrgba y,255
)

glrgba=: 3 : 0
gl2log 'glrgba';y
assert (4=#y)*.(_1<y)*256>y
GLCOLOR=: gethex y
)

glbrush=: 3 : 0
gl2log 'glbrush';y
GLBRUSHNULL=: 0
jscfillStyle jsxucp GLCOLOR
)

glbrushnull=: 3 : 0
gl2log 'glbrushnull';y
GLBRUSHNULL=: 1
i.0 0
)

NB. glpen has min width of 1 - all styles treated as PS_SOLID
glpen=: 3 : 0
gl2log 'glpen';y
assert 2=#y
jsclineWidth 2>.0{y NB. min 1,but 2 shows
jscstrokeStyle jsxucp GLCOLOR
)

NB. 0 or more rectangles
glrect=: 3 : 0
y=. ,y
gl2log 'glrect';y
jscbeginPath''        NB. start path that will be painted
while. #y do.
 jscrect 4{.y
 if. -.GLBRUSHNULL do. jscfill'' end.
 jscstroke''
 y=. 4}.y
end.
i.0 0
)

NB. hardwired font - mono to avoid glqextent
glfont=: 3 : 0
NB. must use default mono font as that has set fontwidth,fontheight for textmetrics
NB. jscfont jsxucp '11pt ',PC_FONTFIXED
i.0 0
)

gltextcolor=: 3 : 0
gl2log'gltextcolor';y
assert 0=#y
GLTEXTCOLOR=: GLCOLOR
)

gltextxy=: 3 : 0
gl2log'gltextxy';y
assert 2=#y
NB.! textBaseline= "top" puts text right at top - kluge add 3
GLTEXTXY=: y + 0,3 NB. canvasfontheight__JHSCANVAS
)

gltext=: 3 : 0
gl2log'gltext';y
jscbeginPath''
jscfillStyle   jsxucp GLTEXTCOLOR
jscfillText GLTEXTXY, jsxucp y
)

NB. dissect gl commands

NB. dissect has dissectisi as id of isigraph - map to mcan
glsel=: 3 : 0
gl2log'glsel';y
JHSCANVAS_z_=: ('mcan','__JHSFORM')~
i.0 0
)

glpixels=: 3 : 0
gl2log'glpixels';y
jscpixels y
i.0 0
)

glclear=: 3 : 0
gl2log'glclear';y
jscbeginPath''
jscclearRect 0 0,glqwh''
)

glclipreset=: 3 : 0
gl2log'glclipreset';y
jscrestore''
i.0 0
)

glclip=: 3 : 0
gl2log'glclip';y
jscsave''
jscbeginPath''
jscrect y
jscclip''
i.0 0
)

glpaint=: 3 : 0
gl2log'glpaint';y
i.0 0
)

gltimer=: 3 : 0
gl2log'gltimer';y
jsctimer y
)

NB. glq... return result - do not add to buffer

NB. fontwidth calc , fontheight
glqextent=: 3 : 0
gl2log'glqextent';y
if. 0~:nc<'canvasfontwidth__JHSCANVAS' do. 200 24 return. end.
(<.0.5+canvasfontwidth__JHSCANVAS*#;y),canvasfontheight__JHSCANVAS
)

glqwh=: 3 : 0
gl2log'glqwh';y
if. 0~:nc<'canvaswidth__JHSCANVAS' do. 592 536 return. end.
canvaswidth__JHSCANVAS,canvasheight__JHSCANVAS
)

NB. partial support - handle instead of pixels
NB. could manage a few handles - dissect is happy with just 2
glqpixels=: 3 : 0
gl2log'glqpixels';y
jscqpixels y
r=. canvaspixels__JHSCANVAS
canvaspixels__JHSCANVAS=: 1+canvaspixels__JHSCANVAS
r
)

require'~addons/graphics/color/hues.ijs'

NB. jsc... commands that map directly to javascript and asserts
t=. <;._2 [ 0 : 0
fillStyle     0<#
strokeStyle   0<#
rect          4=#
fillText      2<:#
font          0<#
lineWidth     1=#
beginPath     0=#
fill          0=#
stroke        0=#
clearRect     4=#
moveTo        2=#
lineTo        2=#
closePath     0=#
ellipse       8=#
strokeText    2<#
arc           6=#
clip          0=#
save          0=#
restore       0=#
qpixels       4=#
pixels        5=#
)

ncmds=:    (t i.each' '){.each t
nasserts=: (>:each t i:each' ')}.each t

bld=: 3 : 0''
for_i. i.#ncmds do.
 a=. ;i{nasserts
 ('jsc',(;i{ncmds),'')=: 3 : ('i.0 0[   buffer__JHSCANVAS=: buffer__JHSCANVAS,',(":i),',(#d),d [''',(;i{ncmds),'''assert ',a,' d=. <. y' )
end.
i.0 0
)

NB. jsx
jsxcommon=: 3 : 0
'a b c'=. y
jscbeginPath''
jsclineWidth a
jscstrokeStyle jsxucp b
jscfillStyle   jsxucp c
)

jsxnew=: 3 : 0
r [ (n)=: '' [ r=. n~ [ n=. CANVAS_ID_z_,'_buffer_',(;CANVAS_PARENT_z_),'_'
)

jsxnew=: 3 : 0
r [ buffer__JHSCANVAS=: '' [ r=. buffer__JHSCANVAS
)


jsxucp=: 3 u: 7 u: ]              NB. int codepoints from utf8 string
jsxradian=: 3 : '<.1e7*y'         NB. ints from fractional radians
jsxarg=: 3 : 0
(":y)rplc' ';',';'_';'-' NB. javascript string from int list
)

NB. y is number of colors required
jsxpalette=: 3 : 0
t=. jsxarg each ":each<"1[255<.<.0.5+hues 5r6*(i.%<:)y
(<'rgb('),each t,each')'
)

jsxlines=: 3 : 0
assert 0=2|#y
jscmoveTo 2{.y
i=. 2 
while. i<#y do.
 jsclineTo (i+0 1){y
 i=. i+2
end.
jscstroke''
)

NB. simple viewmat
jsxvm=: 3 :0
'a b'=. $y
s=. >./jsxwh
d=. >./$y
r=. <.s%d
offset=. <.2%~jsxwh-r*$y
data=.  (~.,y) i. y
pal=. jsxpalette >:>./,data
for_i. i.a do.
 for_j. i.b do.
  jscbeginPath''
  jscfillStyle jsxucp ;(i{j{data){pal
  jscrect (offset+r*i,j),r,r
  jscfill''
 end.
end.
)

NB. gl2 constants
PS_NULL=: 0
PS_SOLID=: 1
PS_DASH=: 2
PS_DOT=: 3
PS_DASHDOT=: 4
PS_DASHDOTDOT=: 5
