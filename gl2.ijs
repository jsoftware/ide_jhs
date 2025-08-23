0 : 0
JHS gl2 definitions
drawing commands are jsc... or gl2...
jsc commands map directly to javascript canvas commands
jsx commands manage the jsc buffer etc
gl2 commands are defined with jsc commands
)

coclass 'jgl2'

NB. gl2 covers for jsc...

gethex=: 3 : 0
'#',(,16 16 #: y){'0123456789abcdef'
)

NB. GL state info for jsc
GLCOLOR=:  gethex 0 0 0 255
GLTEXTXY=: 100 100
GLTEXTCOLOR=: GLCOLOR

gllines=: 3 : 0
assert 0=2|#y
if. 0=#y do. return. end.
 jscbeginPath''        NB. start path that will be painted
 jscmoveTo 0 1{y
 y=. 2}.y
while. #y do.
 jsclineTo 2{.y
 jscstroke''           NB. draw line
 y=. 2}.y
end. 
)

glrgb=: 3 : 0
glrgba y,255
)

glrgba=: 3 : 0
assert (4=#y)*.(_1<y)*256>y
GLCOLOR=: gethex y
)

glbrush=: 3 : 0
jscfillStyle jsxucp GLCOLOR
)

glpen=: 3 : 0
assert 2=#y
jsclineWidth 0{y
jscstrokeStyle jsxucp GLCOLOR
)

glrect=: 3 : 0
jscbeginPath''        NB. start path that will be painted
jscrect y
jscfill''
jscstroke''
)

NB. hardwired font - mono to avoid glqextent
glfont=: 3 : 0
NB. must use default mono font as that has set fontwindt,fontheight for textmetrics
NB. jscfont jsxucp '11pt ',PC_FONTFIXED
i.0 0
)

gltextcolor=: 3 : 0
assert 0=#y
GLTEXTCOLOR=: GLCOLOR
)

gltextxy=: 3 : 0
assert 2=#y
GLTEXTXY=: y
)

gltext=: 3 : 0
jscbeginPath''
jscfillStyle   jsxucp GLTEXTCOLOR
NB. jscfont jsxucp '80px Arial'
jscfillText GLTEXTXY, jsxucp y
)

require'~addons/graphics/color/hues.ijs'

NB. jsc... commands that map directly to javascript and asserts
t=. <;._2 [ 0 : 0
fillStyle     0<#
strokeStyle   0<#
rect          4=#
fillText      2<#
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
)

ncmds=:    (t i.each' '){.each t
nasserts=: (>:each t i:each' ')}.each t

NB. build jsc... verbs
bld=: 3 : 0''
for_i. i.#ncmds do.
 a=. ;i{nasserts
 ('jsc',(;i{ncmds),'')=: 3 : ('i.0 0[jsxbuf=: jsxbuf,',(":i),',(#d),d[''',(;i{ncmds),'''assert ',a,' d=. <. y' )
end.
i.0 0
)

NB. override default defn
jscfont=: 3 : 0
assert 2=3!:0 y
jsxbuf=: jsxbuf,4,(#y),jsxucp y
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

jsxnew=: 3 : 'r[jsxbuf=:''''[r=. jsxbuf'

jsxucp=: 3 u: 7 u: ]              NB. int codepoints from utf8 string
jsxradian=: 3 : '<.1e7*y'         NB. ints from fractional radians
jsxarg=: 3 : '(":y)rplc'' '';'',''' NB. javascript string from int list

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

{{)n
following is qt definitions

NB. gl2 init

coclass 'jgl2'

WDCB_jqtide_=: (WDCB_jqtide_"_)^:(0=4!:0<'WDCB_jqtide_') (IFIOS*.IFQT)+.(UNAME-:'Wasm')
3 : 0''
if. 0~: 4!:0 <'PROFONT_z_' do. PROFONT=: (('Linux';'FreeBSD';'OpenBSD';'Darwin';'Android';'Win') i. <UNAME){:: 'Sans 10' ; 'Sans 10' ; 'Sans 10' ; '"Lucida Grande" 10' ; (IFQT{::'Sans 10';'"Droid Sans" 10') ; 'Tahoma 10' ; 'Tahoma 10' else. PROFONT=: PROFONT_z_ end.
if. 0~: 4!:0 <'FIXFONT_z_' do. FIXFONT=: (('Linux';'FreeBSD';'OpenBSD';'Darwin';'Android';'Win') i. <UNAME){:: 'mono 10' ; 'mono 10' ; 'mono 10' ; 'Monaco 10' ; (IFQT{::'monospace 10';'"Droid Sans Mono" 10') ; '"Lucida Console" 10' ; '"Lucida Console" 10' else. FIXFONT=: FIXFONT_z_ end.
)

NB. gl2 constant

PS_NULL=: 0
PS_SOLID=: 1
PS_DASH=: 2
PS_DOT=: 3
PS_DASHDOT=: 4
PS_DASHDOTDOT=: 5

IDC_ARROW=: 0
IDC_UPARROW=: 1
IDC_CROSS=: 2
IDC_WAIT=: 3
IDC_IBEAM=: 4
IDC_SIZEVER=: 5
IDC_SIZEHOR=: 6
IDC_SIZEBDIAG=: 7
IDC_SIZEFDIAG=: 8
IDC_SIZEALL=: 9
IDC_BLANK=: 10
IDC_SPLITV=: 11
IDC_SPLITH=: 12
IDC_POINTINGHAND=: 13
IDC_FORBIDDEN=: 14
IDC_OPENHAND=: 17
IDC_CLOSEDHAND=: 18
IDC_WHATSTHIS=: 15
IDC_BUSY=: 16
IDC_DRAGMOVE=: 20
IDC_DRAGCOPY=: 19
IDC_DRAGLINK=: 21
IDC_UNSET=: _1

NB. numeric constants used in glcmds

glarc_n=: 2001
glbrush_n=: 2004
glbrushnull_n=: 2005
glcapture_n=: 2062
glcaret_n=: 2065
glclear_n=: 2007
glclip_n=: 2078
glclipreset_n=: 2079
glcmds_n=: 2999
glcursor_n=: 2069
glellipse_n=: 2008
glemfopen_n=: 2084
glemfclose_n=: 2085
glemfplay_n=: 2086
glfile_n=: 2066
glfill_n=: 2093
glfont_n=: 2012
glfontextent_n=: 2094
gllines_n=: 2015
glnodblbuf_n=: 2070
glpaint_n=: 2020
glpaintx_n=: 2021
glpen_n=: 2022
glpie_n=: 2023
glpixel_n=: 2024
glpixelsx_n=: 2075
glpixels_n=: 2076
glprint_n=: 2089
glprintmore_n=: 2091
glpolygon_n=: 2029
glqextent_n=: 2057
glqextentw_n=: 2083
glqpixels_n=: 2077
glqpixelm_n=: 2080
glqprintpaper_n=: 2092
glqprintwh_n=: 2088
glqtextmetrics_n=: 2058
glqtype_n=: 2095
glqwh_n=: 2059
glqhandles_n=: 2060
glrect_n=: 2031
glrgb_n=: 2032
glroundr_n=: 2033
glsel_n=: 2035
gltext_n=: 2038
gltextcolor_n=: 2040
gltextxy_n=: 2056
glwindoworg_n=: 2045

glbkmode_n=: 2003
glnoerasebkgnd_n=: 2071
glsetlocale_n=: 2072

glfont2_n=: 2312
glfontangle_n=: 2096
glrgba_n=: 2097
glsel2_n=: 2098

NB. image utility
glgetimg_n=: 3000
glreadimg_n=: 3001
glputimg_n=: 3002
glwriteimg_n=: 3003

NB. keyboard events
kbBS=: Qt_Key_Backspace_jqtide_
kbTAB=: Qt_Key_Tab_jqtide_
kbLF=: Qt_Key_Enter_jqtide_
kbENTER=: Qt_Key_Enter_jqtide_
kbRETURN=: Qt_Key_Return_jqtide_
kbPUP=: Qt_Key_PageUp_jqtide_
kbPDOWN=: Qt_Key_PageDown_jqtide_
kbEND=: Qt_Key_End_jqtide_
kbHOME=: Qt_Key_Home_jqtide_
kbLEFT=: Qt_Key_Left_jqtide_
kbUP=: Qt_Key_Up_jqtide_
kbRIGHT=: Qt_Key_Right_jqtide_
kbDOWN=: Qt_Key_Down_jqtide_
kbESC=: Qt_Key_Escape_jqtide_
kbINS=: Qt_Key_Insert_jqtide_
kbDEL=: Qt_Key_Delete_jqtide_
kbMETA=: Qt_Key_Meta_jqtide_
kbALT=: Qt_Key_Alt_jqtide_
kbSHIFT=: Qt_Key_Shift_jqtide_
kbCTRL=: Qt_Key_Control_jqtide_
NB. qt gl2

chkgl2=: 13!:8@3:^:(0&<)@>@{.

NB. =========================================================
glarc=: chkgl2 @: (('"',libjqt,'" glarc >',(IFWIN#'+'),' i *i') cd <) "1
glbrush=: chkgl2 @: (('"',libjqt,'" glbrush >',(IFWIN#'+'),' i')&cd bind '') "1
glbrushnull=: chkgl2 @: (('"',libjqt,'" glbrushnull >',(IFWIN#'+'),' i')&cd bind '') "1
glcapture=: chkgl2 @: (('"',libjqt,'" glcapture >',(IFWIN#'+'),' i i')&cd) "1
glcaret=: chkgl2 @: (('"',libjqt,'" glcaret >',(IFWIN#'+'),' i *i') cd <) "1
glclear=: (('"',libjqt,'" glclear >',(IFWIN#'+'),' i')&cd bind '') "1
glclip=: chkgl2 @: (('"',libjqt,'" glclip >',(IFWIN#'+'),' i *i') cd <) "1
glclipreset=: chkgl2 @: (('"',libjqt,'" glclipreset >',(IFWIN#'+'),' i')&cd bind '') "1
glcmds=: chkgl2 @: (('"',libjqt,'" glcmds >',(IFWIN#'+'),' i *i i') cd (;#)) "1
glcursor=: chkgl2 @: (('"',libjqt,'" glcursor >',(IFWIN#'+'),' i i')&cd) "1
glellipse=: chkgl2 @: (('"',libjqt,'" glellipse >',(IFWIN#'+'),' i *i') cd <@:<.) "1
glfill=: chkgl2 @: (('"',libjqt,'" glfill >',(IFWIN#'+'),' i *i') cd <@:<.) "1
glfont=: chkgl2 @: (('"',libjqt,'" glfont >',(IFWIN#'+'),' i *c') cd <@,) "1
glfont2=: chkgl2 @: (('"',libjqt,'" glfont2 >',(IFWIN#'+'),' i *i i') cd (;#)@:<.) "1
glfontangle=: chkgl2 @: (('"',libjqt,'" glfontangle >',(IFWIN#'+'),' i i')&cd) "1
glfontextent=: chkgl2 @: (('"',libjqt,'" glfontextent >',(IFWIN#'+'),' i *c') cd <@,) "1
gllines=: chkgl2 @: (('"',libjqt,'" gllines >',(IFWIN#'+'),' i *i i') cd (;#)) "1
glnodblbuf=: chkgl2 @: (('"',libjqt,'" glnodblbuf >',(IFWIN#'+'),' i i') cd {.@(,&0)) "1
glpen=: chkgl2 @: (('"',libjqt,'" glpen >',(IFWIN#'+'),' i *i') cd <@:(2 {. (,&1))) "1
glpie=: chkgl2 @: (('"',libjqt,'" glpie >',(IFWIN#'+'),' i *i') cd <) "1
glpixel=: chkgl2 @: (('"',libjqt,'" glpixel >',(IFWIN#'+'),' i *i') cd <) "1
glpixels=: chkgl2 @: (('"',libjqt,'" glpixels >',(IFWIN#'+'),' i *i i') cd (;#)@:<.) "1
glpixelsx=: chkgl2 @: (('"',libjqt,'" glpixelsx >',(IFWIN#'+'),' i *i') cd <@:<.) "1
glpolygon=: chkgl2 @: (('"',libjqt,'" glpolygon >',(IFWIN#'+'),' i *i i') cd (;#)@:<.) "1
glrect=: chkgl2 @: (('"',libjqt,'" glrect >',(IFWIN#'+'),' i *i') cd <) "1
glrgb=: chkgl2 @: (('"',libjqt,'" glrgb >',(IFWIN#'+'),' i *i') cd <@:<.) "1
glrgba=: chkgl2 @: (('"',libjqt,'" glrgba >',(IFWIN#'+'),' i *i') cd <@:<.) "1
glsel1=: chkgl2 @: (('"',libjqt,'" glsel >',(IFWIN#'+'),' i x')&cd) "1
glsel2=: chkgl2 @: (('"',libjqt,'" glsel2 >',(IFWIN#'+'),' i *c') cd <@,) "1
gltext=: chkgl2 @: (('"',libjqt,'" gltext >',(IFWIN#'+'),' i *c') cd <@,) "1
gltextcolor=: chkgl2 @: (('"',libjqt,'" gltextcolor >',(IFWIN#'+'),' i')&cd bind '') "1
gltextxy=: chkgl2 @: (('"',libjqt,'" gltextxy >',(IFWIN#'+'),' i *i') cd <@:<.) "1
glwaitgl=: chkgl2 @: (('"',libjqt,'" glwaitgl >',(IFWIN#'+'),' i')&cd bind '') "1
glwaitnative=: chkgl2 @: (('"',libjqt,'" glwaitnative >',(IFWIN#'+'),' i')&cd bind '') "1
glwindoworg=: chkgl2 @: (('"',libjqt,'" glwindoworg >',(IFWIN#'+'),' i *i') cd <@:<.) "1

glsetlocale=: chkgl2 @: (('"',libjqt,'" glsetlocale >',(IFWIN#'+'),' i *c') cd <@,@>) "1

NB. =========================================================
NB. immediate paint
glpaint=: 3 : 0 "1
('"',libjqt,'" glpaint >',(IFWIN#'+'),' i')&cd ''
0
)

NB. =========================================================
NB. paint
glpaintx=: 3 : 0 "1
('"',libjqt,'" glpaintx >',(IFWIN#'+'),' i')&cd ''
0
)

NB. =========================================================
glqhandles=: 3 : 0"1
hs=. 3#2-2
chkgl2 cdrc=. ('"',libjqt,'" glqhandles  ',(IFWIN#'+'),' i *x') cd <hs
1{::cdrc
)

NB. =========================================================
glqtype=: 3 : 0"1
type=. 1#2-2
chkgl2 cdrc=. ('"',libjqt,'" glqtype  ',(IFWIN#'+'),' i *i') cd <type
1{::cdrc
)

NB. =========================================================
glqwh=: 3 : 0"1
wh=. 2#2-2
chkgl2 cdrc=. ('"',libjqt,'" glqwh  ',(IFWIN#'+'),' i *i') cd <wh
1{::cdrc
)

NB. =========================================================
NB. return matrix of pixels
NB. wh is limited to pixmap size
NB. -1 in w or h means read to end
glqpixelm=: 3 : 0"1
n=. */ 2{.2}.y
pix=. n#2-2
shape=. 2#2-2
chkgl2 cdrc=. ('"',libjqt,'" glqpixelm  ',(IFWIN#'+'),' i *i *i *i') cd y;shape;pix
(2&{:: $ 3&{::) cdrc
)

NB. =========================================================
NB. result is in opengl form
NB. pixels top to bottom, RGB24
NB. TODO
glqpixels=: 3 : 0"1
n=. */ 2{.2}.y
pix=. n#2-2
chkgl2 cdrc=. ('"',libjqt,'" glqpixels  ',(IFWIN#'+'),' i *i *i') cd y;pix
2{::cdrc
)

NB. =========================================================
NB. TODO
glqextent=: 3 : 0"1
wh=. 2#2-2
chkgl2 cdrc=. ('"',libjqt,'" glqextent  ',(IFWIN#'+'),' i *c *i') cd (,y);wh
2{::cdrc
)

NB. =========================================================
NB. TODO
glqextentw=: 3 : 0"1
y=. y,(LF~:{:y)#LF [ y=. ,y
w=. (+/LF=y)#2-2
chkgl2 cdrc=. ('"',libjqt,'" glqextentw  ',(IFWIN#'+'),' i *c *i') cd y;w
2{::cdrc
)

NB. =========================================================
NB. font information: Height, Ascent, Descent, InternalLeading, ExternalLeading, AverageCharWidth, MaxCharWidth
NB. TODO
glqtextmetrics=: 3 : 0"1
tm=. 7#2-2
chkgl2 cdrc=. ('"',libjqt,'" glqtextmetrics  ',(IFWIN#'+'),' i *i') cd <tm
1{::cdrc
)

NB. =========================================================
glsetbrush=: glbrush @ glrgb
glsetpen=: glpen @ ((1 1 [ glrgb) :((2 {. (,&1)) glrgb))

NB. =========================================================
NB. printer

NB. not implemented
glprint=: [:
glprintmore=: [:
glqprintpaper=: [:
glqprintwh=: [:

NB. not implemented
glemfclose=: [:
glemfopen=: [:
glemfplay=: [:
glfile=: [:
glroundr=: [:

NB. =========================================================
glsel=: glsel2@:(":^:(2~:3!:0))

NB. =========================================================
3 : 0''
if. WDCB_jqtide_ do.
  chkgl2=: ]
  glarc=: 11 !: glarc_n
  glbrush=: 11 !: glbrush_n
  glbrushnull=: 11 !: glbrushnull_n
  glcapture=: 11 !: glcapture_n
  glcaret=: 11 !: glcaret_n
  glclear=: 11 !: glclear_n
  glclip=: 11 !: glclip_n
  glclipreset=: 11 !: glclipreset_n
  glcmds=: 11 !: glcmds_n
  glcursor=: 11 !: glcursor_n
  glellipse=: 11 !: glellipse_n
  glfill=: 11 !: glfill_n
  glfont=: 11 !: glfont_n
  glfont2=: 11 !: glfont2_n
  glfontangle=: 11 !: glfontangle_n
  glfontextent=: 11 !: glfontextent_n
  gllines=: 11 !: gllines_n
  glnodblbuf=: 11 !: glnodblbuf_n
  glpen=: 11 !: glpen_n
  glpie=: 11 !: glpie_n
  glpixel=: 11 !: glpixel_n
  glpixels=: 11 !: glpixels_n
  glpixelsx=: 11 !: glpixelsx_n
  glpolygon=: 11 !: glpolygon_n
  glrect=: 11 !: glrect_n
  glrgb=: 11 !: glrgb_n
  glrgba=: 11 !: glrgba_n
  gltext=: 11 !: gltext_n
  gltextcolor=: 11 !: gltextcolor_n
  gltextxy=: 11 !: gltextxy_n
NB.   glwaitgl=: 11 !: glwaitgl_n
NB.   glwaitnative=: 11 !: glwaitnative_n
  glwindoworg=: 11 !: glwindoworg_n
  glsetlocale=: 11 !: glsetlocale_n
  glpaint=: 11 !: glpaint_n
  glpaintx=: 11 !: glpaintx_n
  glqhandles=: 11 !: glqhandles_n
  glqtype=: 11 !: glqtype_n
  glqwh=: 11 !: glqwh_n
  glqpixelm=: 11 !: glqpixelm_n
  glqpixels=: 11 !: glqpixels_n
  glqextent=: 11 !: glqextent_n
  glqextentw=: 11 !: glqextentw_n
  glqtextmetrics=: 11 !: glqtextmetrics_n
  glsel=: (11 !: glsel_n)`(11 !: glsel2_n)@.(2=3!:0)
NB. image utility
  glgetimg=: 11 !: glgetimg_n
  glreadimg=: 11 !: glreadimg_n
  glputimg=: 11 !: glputimg_n
  glwriteimg=: 11 !: glwriteimg_n
end.
EMPTY
)
NB. util

NB. =========================================================
RGBA=: 3 : 'r (23 b.) 8 (33 b.) g (23 b.) 8 (33 b.) b (23 b.) 8 (33 b.) a [ ''r g b a''=. <.y'
BGRA=: 3 : 'b (23 b.) 8 (33 b.) g (23 b.) 8 (33 b.) r (23 b.) 8 (33 b.) a [ ''r g b a''=. <.y'

NB. =========================================================
NB. pafc v Polar angle from cartesian coords
pafc=: 2p1&|@{:@:(*.@(j./))

rfd=: *&(1p1%180)
dfr=: *&(180%1p1)

NB. calcAngle gives polar angle in radians with zero at 3-o'clock
NB. from rectangular coordiates with origin (0,0) at the top, left
NB. (xctr,yctr) calcAngle xpt,ypt
calcAngle=: ([: pafc _1 1 * -)"1

NB. =========================================================
NB. convert radians to 64ths-of-a-degree
degree64=: 0.5 <.@:+ 64 * dfr

NB. =========================================================
NB. opengl (and normal folk?) are ARGB with A 0
NB. glpixels and glqpixels need to make these adjustments
3 : 0''
if. IF64 do.
  ALPHA=: 0{_3 ic 0 0 0 255 255 255 255 255{a.
else.
  ALPHA=: 0{_2 ic 0 0 0 255{a.
end.
''
)
NOTALPHA=: 0{_2 ic 255 255 255 0{a.
ALPHARGB=: IF64{::_1;16bffffffff

NB. =========================================================
NB. arc drawing - glellipse, glarc, glpie
NB. draw arc on the ellipse defined by rectangle
NB. arc starts at xa,ya and ends at xz,yz (counterclockwise)
NB. points need not lie on the ellipse
NB. they define a line from the center that intersects ellipse
NB. gdk arc has same xywh but args are start and end angles
NB. counterclockwise in 64th degrees

NB. =========================================================
parseFontname=: 3 : 0
font=. ' ',y
b=. (font=' ') > ~:/\font='"'
a: -.~ b <@(-.&'"');._1 font
)

NB.*FontStyle n Regular Bold Italic Underline Strikeout
NB.             0       1    2      4         8
FontStyle=: ;:'regular bold italic underline strikeout'

parseFontSpec=: 3 : 0
'ns styleangle'=. 2 split parseFontname y
'face size'=. ns
size=. 12". size
style=. FontStyle i. tolower each styleangle
style=. <.+/2^<:(style ((> 0) *. <) #FontStyle) # style
if. 1 e. an=. ('angle'-:5&{.)&> styleangle do.
  degree=. 10%~ 0". 5}.>(an i. 1){styleangle
else.
  degree=. 0
end.
face;size;style;degree
)

NB. delete leading white spaces
dlws=: 3 : 0
y }.~ +/ *./\ (y e. ' ')+.(y e. LF)+.(y e. TAB)
)

NB. count leading white spaces
clws=: 3 : 0
+/ *./\ (y e. ' ')+.(y e. LF)+.(y e. TAB)
)

NB. get first argument and remove enclosing dquotes or DEL
NB. update global noun wdglptr on exit
wdglshiftarg=: 3 : 0
if. (#wdglstr) = wdglptr=: wdglptr + clws wdglptr}. wdglstr do. '' return. end.
y=. wdglptr}.wdglstr
b=. y e. ' '
a=. y e. '*'
q=. 2| +/\ y e. '"'
d=. 2| +/\ y e. DEL
b=. b *. -.q+.d
a=. a *. -.q+.d
if. 1={.a do.     NB. *argument
  z=. }.y
  wdglptr=: #wdglstr
elseif. (1={.d)+.(1={.q) do.   NB. enclosed between DEL or "
  p2=. 1+ (}.y) i. {.y
  z=. }.p2{.y
  wdglptr=: wdglptr+ p2+1
elseif. 1 e. b do. NB. space delimited
  p2=. {.I.b
  z=. p2{.y
  wdglptr=: wdglptr+ 1+p2
elseif. do.
  z=. y
  wdglptr=: #wdglstr
end.
<z
)

NB. get all arguments by repeating calling wdglshiftarg
wdglshiftargs=: 3 : 0
wdglptr=: 0 [ wdglstr=: y
z=. 0$<''
while. wdglptr < #wdglstr do. z=. z, wdglshiftarg'' end.
z
)

tors=: 3 : 0
(2{.y),(2{.y)+2}.y
)
}}