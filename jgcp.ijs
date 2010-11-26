NB. JHS Google Charts
coclass'jgcp'

GC=: 'chart.apis.google.com'

NB. z defines - user api
jgc_z_=:      gc_jgcp_      NB. edit chart state
jgcimg_z_=:   gcimg_jgcp_   NB. get html img tag
jgcchart_z_=: gcchart_jgcp_ NB. get chart?&cht...
jgcfile_z_=:  gcfile_jgcp_  NB. get png file 
jgcx_z_=:     gcx_jgcp_     NB. run examples

gc=: 3 : 0
'' jgc y
:
gcd y
gcc each <;._2 x,' '
i.0 0
)

NB. x... nouns
xline=:  '&cht=lc&chs=300x100&chds=<MIN>,<MAX>&chxt=x,y&chxr=1,<MIN>,<MAX>'
xlinexy=:'&cht=lxy&chs=300x100&chds=<MIN>,<MAX>&chxt=x,y&chxr=0,<YMIN>,<YMAX>|1,<MIN>,<MAX>'
xpie=:   '&cht=p&chs=300x100&chds=0,<MAX>'
xpie3=:  '&cht=p3&chs=300x100&chds=0,<MAX>'

NB. process blank delimited commands
gcc=: 3 : 0 
if. 'reset'-:y do.
   gcurl=: ''
elseif. 'help'-:y do.
   smoutput help
elseif. 'lc'-:y do.
   gcurl=: '&cht=lc&chs=400x200&chds=<MIN>,<MAX>&chxt=x,y&chxr=1,<MIN>,<MAX>'
elseif. ('p'-:y)+.'p3'-:y do.
   gcurl=: '&cht=',y,'&chs=400x200&chds=0,<MAX>'
elseif. 'show'-:y do.
   jhtml gcimg''
elseif. '&ch'-:3{.y do.
   gcurl=: gcurl,y   NB. might be nice to remove duplicates
elseif. 'x'={.y do.
   (y,' is not a noun') assert 0=nc<y
   gcurl=: gcurl,".y
elseif. ''-:y do.
elseif. 1 do.
   ('unknown command: ',y)assert 0
end.
i.0 0
)

NB. format data - uses least space efficient t format
gcd=: 3 : 0
if. ''-:y do.
elseif. 2=3!:0 y do.
 smoutput help
elseif. 32=3!:0 y do.
 NB. assume dead simple 1 2 3;4 5 6
 gcdata=: y
 GCFDATA=: }:'t:',' ,_-'charsub ;'|',~each":each <"1 >gcdata
 GCMIN=: '_-'charsub":<./,>{.y
 GCMAX=: '_-'charsub":>./,>{.y
 GCYMIN=: '_-'charsub":<./,>{:y
 GCYMAX=: '_-'charsub":>./,>{:y
elseif. 1 do.
 gcdata=: >(1=$$y){y;,:y
 GCFDATA=: }:'t:',' ,_-'charsub ;'|',~each":each <"1 gcdata
 GCMIN=: '_-'charsub":<./,y
 GCMAX=: '_-'charsub":>./,y
 GCYMIN=: GCYMAX=: 0
end.
i.0 0
)

NB. get last y command arg
gca=: 3 : 0
c=. <;.1 gcurl
ch=. }.each(c i.each'='){.each c
i=. ch i:<y
if. i=#c do. '' else. (2+#>i{ch)}.>i{c end.
)

NB. return html img tag
gcimg=: 3 : 0
t=. 'http://',GC,'/',gcchart''
'<img width=',(":GCW),'px height=',(":GCH),'px src="',t,'"></img>'
)

NB. return chart?....
gcchart=: 3 : 0
'GCW GCH'=: wh=. 2{.0".'x 'charsub gca'chs'
'chs error' assert (wh>:25),(wh<:1000),300000>:*/wh
'cht missing' assert #gca'cht'
t=. 'chart?',gcurl,'&chd=',GCFDATA
t hrplc_jhs_ 'MIN MAX YMIN YMAX COLORS RED BLUE';GCMIN;GCMAX;GCYMIN;GCYMAX;COLORS;RED;BLUE
)

NB. return chart file data (png)
gcfile=: 3 : 0
>{:jwget GC;gcchart''
)

NB. limited support
NB.  title option
NB.  xline and xlinexy chart types
NB.  data vector
NB.  data matrix
NB.  xvals;yvals
NB. needs support for
NB.  sin=: 1&o.
NB.  cos=: 2&o.
NB.  x=: 0.1 * i: 21
NB.  plot x;>(sin x);(cos x)
plot_z_=: 3 : 0
''plot y
:
t=. <;._2 x,';'
b=. (<'title ')=6{.each t
if. 0~:#;(-.b)#t do. smoutput 'unsupported plot options: ',x end.
if. (32=3!:0 y)*.2~:#$>y do.
 smoutput 'unsupported data complexity'
 y=. >{:y
end.
t=. 6}.;b#t
type=. >(32=3!:0 y){'xline';'xlinexy'
('reset ',type,' &chtt=',t,' show')jgc y
)

rgb=:3 : 0
(,16 16#:y){'0123456789ABCDEF'
)

AQUA=:    rgb   0 255 255
BLUE=:    rgb   0   0 255
BROWN=:   rgb 192 128   0
FUCHSIA=: rgb 255   0 255
GRAY=:    rgb 128 128 128
GREEN=:   rgb   0 128   0
LIME=:    rgb   0 255   0
MAROON=:  rgb 128   0   0
NAVY=:    rgb   0   0 128
OLIVE=:   rgb 128 128   0
PURPLE=:  rgb 128   0 128
RED=:     rgb 255   0   0
SILVER=:  rgb 192 192 192
TAN=:     rgb 210 180 140
TEAL=:    rgb   0 128 128
YELLOW=:  rgb 255 255   0
BLACK=:   rgb   0   0   0
WHITE=:   rgb 255 255 255

COLORS=: }.;',',._6[\BLUE,RED,GREEN,PURPLE,FUCHSIA,OLIVE,TEAL,YELLOW,TAN,AQUA,BROWN,GRAY

help=: 0 : 0
JHS plots with Google Charts (GC).
See code.google.com/apis/chart for info.

chart?... in a url defines a plot.
The url from GC returns a png file.
   jgcx'' NB. see examples

jgc maganges chart state.
   jgc 10?10  NB. numeric list or table
   jgc ''     NB. leaves data as is
   jgc 'help' NB. displays this help

   '...'jgc y NB. x is blank delimited commands
   'reset xline &chs=400x200 show'jgc 10?1000

jgc x command summary:
 reset  clears chart url (data unchanged)
 show   adds img tag with url to ijx
 x...   noun x... added to url
 xline  line chart
 xpie   pie chart
 xpie3  pie 3d chart
 &ch..  GC commands

Use + instead of blank in &ch.. commands!

   jgcchart'' NB. get chart?...
   jgcimg''   NB. get img tag
   jgcfile''  NB. get png file


)

examples=: 0 : 0
plot ?2 10$1000

'reset xline show'jgc 10?1000

'reset xline &chtt=My+Title show'jgc ?2 10$1000

'show'jgc ?3 10$1000

'&chco=<COLORS>'jgc''      NB. default series colors
'&chdl=mew|bark|hiss'jgc'' NB. data legend
'&chxl=0:|a|b|c|d|e|f|g|h|i|j|1:|lo|med|hi'jgc''
'show'jgc''

'reset xpie3 show'jgc 20+3?100

'&chco=<BLUE>'jgc''
'&chdl=one|two|three'jgc'' NB. data legend
'&chl=one|two|three'jgc''  NB. label
'show'jgc''

'reset &cht=tx&chs=200x50&chl=x=\frac{-b\pm\sqrt{b^2-4ac}}{2a} show'jgc ''

'reset &cht=map:fixed=40,-10,60,10&chs=88x140&chld=GB|GB-LND&chco=676767|FF0000|0000BB&chf=bg,s,c6eff7 show'jgc''

'reset &cht=v&chs=200x100&chco=FF6342,ADDE63,63C6DE&chdl=A|B|C show'jgc 100 80 60 30 30 10

'reset xline &chs=200x50 show'jgc 20?1000

d1=. jgcimg'reset xline &chtt=pie+on+right+if+room'jgc 10?1000
d2=. jgcimg'reset xpie3'jgc 20+4?100
jhtml d1,d2
)

gcx=: 3 : '0!:101 examples'

NB. viewmat stuff - subset borrowed from viewmat addon

viewmat__=: 3 : 0
t=. (<6#16)#: each <"0>1{''getvm_jgcp_ y
t=. '#',each t{each <'0123456789abcdef'
a=. (<'<font ',LF,'style="background-color:'),each t
a=. a,each (<'; color:'),each t
a=. a,each <';">ww</font>'
jhtml ;a,.<'<br>'
)

finite=: x: ^: _1

NB. =========================================================
NB.*gethue v generate color from color set
NB. x is color set
NB. y is values from 0 to 1, selecting color
gethue=: 4 : 0
y=. y*<:#x
b=. x {~ <.y
t=. x {~ >.y
k=. y-<.y
(t*k) + b*-.k
)

NB. =========================================================
NB. getvm
NB.
NB. form: hue getvm data [;title]
NB.
NB. hue may be empty, in which case a default is used
NB. hue may be a N by 3 matrix of colors or a vector
NB.     of RGB integers.
NB.
NB. returns:
NB.   original data
NB.   scaled data matrix
NB.   angle (if any)
NB.   title
getvm=: 4 : 0
'dat tit'=. 2 {. boxopen y
tit=. ": tit
tit=. tit, (0=#tit) # 'viewmat'
'mat ang'=. x getvm1 dat
dat ; mat ; ang ; tit
)

NB. =========================================================
getvm1=: 4 : 0
hue=. x
mat=. y
ang=. ''

NB. ---------------------------------------------------------
if. 2 > #$hue do.
  hue=. |."1 [ 256 256 256 #: ,hue
end.

NB. ---------------------------------------------------------
select. 3!:0 mat
case. 2;32 do.
  mat=. (, i. ]) mat
case. 16 do.
  ang=. * mat
  mat=. delinf | mat
case. do.
  mat=. finite mat
end.

NB. ---------------------------------------------------------
select. #$mat
case. 0 do.
  mat=. 1 1$mat
case. 1 do.
  mat=. citemize mat
case. 3 do.
  'mat ang'=. mat
end.

NB. ---------------------------------------------------------
if. */ (,mat) e. 0 1 do.
  if. #hue do.
    h=. <. 0 _1 { hue
  else.
    h=. 0 ,: 255 255 255
  end.
  mat=. mat { h

else.
  if. #hue do.
    h=. hue
  else.
    h=. 255 * #: 7 | 3^i.6
  end.
  val=. ,mat
  max=. >./ val
  min=. <./ val
  mat=. <. h gethue (mat - min) % max - min
end.

mat=. mat +/ .* 65536 256 1

mat ; ang

)

