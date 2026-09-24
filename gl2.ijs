0 : 0
   jhshelp'canvas'

mouse event sysdata
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
NB. decho y;(;coname'');JHSCANVAS
i.0 0
)

NB. css hex colors - transparency is first
gethex=: 3 : 0
assert 4=#y
'#',(,16 16 #: y){'0123456789abcdef'
)

NB. jsc state info - GL... names suggest GL values, but they are jsc values
GLCOLOR=:  gethex 0 0 0 255
GLTEXTXY=: 100 100
GLTEXTCOLOR=: GLCOLOR
GLBRUSHNULL=: 0
GLFONT=: '12px arial'

NB. draw 0 or more lines (4 values for each)
gllines=: 3 : 0
jsxlines y
)

glrgb=: 3 : 0
glrgba y,255
)

glrgba=: 3 : 0
assert (4=#y)*.(_1<y)*256>y
GLCOLOR=: gethex y
)

glbrush=: 3 : 0
GLBRUSHNULL=: 0
jscfillStyle jsxucp GLCOLOR
)

glbrushnull=: 3 : 0
GLBRUSHNULL=: 1
i.0 0
)

NB. glpen has min width of 1 - all styles treated as PS_SOLID
glpen=: 3 : 0
assert 2=#y
jsclineWidth 2>.0{y NB. min 1,but 2 shows
jscstrokeStyle jsxucp GLCOLOR
)

NB. 0 or more rectangles
glrect=: 3 : 0
y=. ,y
jscbeginPath''        NB. start path that will be painted
while. #y do.
 jscrect 4{.y
 if. -.GLBRUSHNULL do. jscfill'' end.
 jscstroke''
 y=. 4}.y
end.
i.0 0
)

NB. gl: x,y,w,h
NB.canvas: x, y, radiusX, radiusY, rotation, startAngle, endAngle, anticlockwise
glellipse=: 3 : 0
wh=. 2 3{y
xy=. (0.5*wh)+2{.y
wh=. 2*wh
jscbeginPath''
jscellipse xy,wh,0 0 ,(jsxradian 2*o.1), 0
jscfillStyle   jsxucp GLCOLOR
if. -.GLBRUSHNULL do. jscfill'' end.
jscstroke''
)

NB. glfont: 'name pt'
NB. canvas: 'px name'
glfont=: 3 : 0
gl2log'glfont'
if. (<'dissect') e. copath coname'' do. y=. '11pt ',PC_FONTFIXED_jhs_ end. NB. dissect forced fixed for qglqextent
t=. deb y
i=. t i: ' '
s=. ":1.33*0".}.i}.t NB. points to pixels
GLFONT=: s,'px ',i{.t
jscfont jsxucp GLFONT
i.0 0
)

gltextcolor=: 3 : 0
assert 0=#y
GLTEXTCOLOR=: GLCOLOR
)

NB. gl and jsc use textBaseline='top' as set by jscrestore and jscreset
gltextxy=: 3 : 0
assert 2=#y
NB.! kludge add 3 for dissect
GLTEXTXY=: y + 0,3
)

gltext=: 3 : 0
jscbeginPath''
jscfillStyle   jsxucp GLTEXTCOLOR
jscfillText GLTEXTXY, jsxucp y
)

NB. dissect gl commands

NB. dissect has dissectisi as id of isigraph - map to mcan
glsel=: 3 : 0
if. 'dissectisi'-:y do.
 c=. JHSFORM_dissectisi_
 JHSCANVAS=: mcan__c return.
end.
'invalid locale'assert y e. conl 1
JHSCANVAS=: y
)

glpixels=: 3 : 0
jscpixels y
i.0 0
)

glclear=: 3 : 0
jscreset''
)

glclipreset=: 3 : 0
jscrestore''
i.0 0
)

glclip=: 3 : 0
jscsave''
jscbeginPath''
jscrect y
jscclip''
i.0 0
)

glpaint=: 3 : 0
i.0 0
)

NB. glq... return result - do not add to buffer

NB. fontwidth calc , fontheight
NB. dissect depends on fixed width font
NB. others use node 
NB. jsxmeasuretext y
glqextent=: 3 : 0
if. 0~:nc<'canvasfontwidth__JHSCANVAS' do. 200 24 return. end.
(<.0.5+canvasfontwidth__JHSCANVAS*#;y),canvasfontheight__JHSCANVAS
)

glqwh=: jsxqwh

NB. partial support - handle instead of pixels
NB. could manage a few handles - dissect is happy with just 2
glqpixels=: 3 : 0
jscqpixels y
r=. canvaspixels__JHSCANVAS
canvaspixels__JHSCANVAS=: 1+canvaspixels__JHSCANVAS
r
)

NB. gl2 constants
PS_NULL=: 0
PS_SOLID=: 1
PS_DASH=: 2
PS_DOT=: 3
PS_DASHDOT=: 4
PS_DASHDOTDOT=: 5

require'~addons/graphics/color/hues.ijs'

NB. jsx

NB. jsc... commands that map directly to canvas commands and asserts
NB. changes  here must be reflected in widget/jhjcanvase.js
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
reset         0=#
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

NB. jscfont needs to set GLFONT
jscfont=: 3 : 0
GLFONT=: y{a.
buffer__JHSCANVAS=: buffer__JHSCANVAS,4,(#d),d ['font'assert 0<# d=. <. y
i.0 0
)


jsxqwh=: 3 : 0
if. 0~:nc<'canvaswidth__JHSCANVAS' do. 100 100 return. end.
canvaswidth__JHSCANVAS,canvasheight__JHSCANVAS
)

node_measureText=: 0 : 0
const { createCanvas } = require('canvas');
const canvas = createCanvas(800, 600);
const ctx = canvas.getContext('2d');
ctx.font = '<FONT>';
const metrics = ctx.measureText('<TEXT>');
console.log(metrics.width+' '+(metrics.actualBoundingBoxAscent+metrics.actualBoundingBoxDescent));
)

NB. server side measure text
NB. glqtextmetrics: Height, Ascent, Descent, InternalLeading, ExternalLeading, AverageCharWidth, MaxCharWidth
NB. jscmeasureText: width, actualBoundingBoxLeft, actualBoundingBoxRight, actualBoundingBoxAscent, actualBoundingBoxDescent, emHeightAscent, emHeightDescent, alphabeticBaseline
jsxtextwh=: 3 : 0
t=. node_measureText rplc '<TEXT>';y;'<FONT>';GLFONT
t fwrite '~temp/node_measuretext'
0".}:shell'node ',jpath'~temp/node_measuretext'
)

NB. * xy;h;text
NB. h px advance to new line - e.g. 1.4*font-size-px
jsxtext=: 3 : 0
'xy h text'=. y
d=. <;._2 text,(LF~:{:text)#LF
GLTEXTXY=: xy
jscbeginPath''
jscfillStyle jsxucp GLTEXTCOLOR
for_t. d do.
 jscfillText GLTEXTXY, jsxucp ;t
 GLTEXTXY=: GLTEXTXY+0,h
end.
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

NB. draw 0 or more lines (4 values for each)
NB. y can be matrix
jsxlines=: 3 : 0
y=. ,y
assert 0=4|#y
while. #y do.
 jscbeginPath''        NB. start path that will be painted
 jscmoveTo 0 1{y
 jsclineTo 2 3{y
 jscstroke''           NB. draw line
 y=. 4}.y
end. 
)

NB. simple viewmat
NB. 20 20 200 200;#:(~:/&.#:@, +:)^:(<32) 1
jsxviewmat=: 3 : 0
'xywh data'=. y
wh=. 2 3{xywh
'a b'=. $data
r=. <.wh%$data
data=.  (~.,data) i. data
pal=. jsxpalette >:>./,data
offset=. 2{.xywh
for_i. i.a do.
 for_j. i.b do.
  jscbeginPath''
  jscfillStyle jsxucp ;(i{j{data){pal
  jscrect (offset+r*i,j),r
  jscfill''
 end.
end.
)
