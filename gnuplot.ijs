 NB. gnuplot html canvas - based on Fraser Jackson's J601 gnuplot addon

coclass 'jgnuplot'

gpinit=: 3 : 0
t=. '~temp/gnuplot'
1!:5 :: 0:<jpath t
DAT=: t,'/gnu.dat'
PLT=: t,'/gnu.plt'
GNU=: t,'/gnu.html'
GNUX=:t,'/gnux.html'
ferase PLT;DAT;GNU;GNUX
SETBUFFER=: ''
WITH=: ''
SURFACE=: 0
i.0 0
)

isboxed=: 0: < L.
itemize=: ,:^:(2: > #@$)

cutstring=: ','&$: : (4 : 0)
if. 0 = #y do. '' return. end.
if. L. y do. y return. end.
txt=. y, {.x
msk=. txt = ''''
com=. (txt e. x) > ~: /\ msk
msk=. (msk *. ~:/\msk) < msk <: 1 |. msk
deb each (msk # com) <;._2 msk # txt
)

gpflatten=: [: _2&}. [: ; ,&CRLF@, each @ < @ (,"1&CRLF @ ":)"2

NB. getdata - mimics the behaviour of J Plot
getdata=: 4 : 0
dat=. y
p3d=. 's' e. x
if. p3d do.
  if. isboxed dat do.
    select. #dat
    case. 1 do.
      z=. 0 pick dat
      x=. i.#z
      y=. i.{:$z
    case. 2 do.
      'y z'=. dat
      x=. i.#z
    case. 3 do.
      'x y z'=. dat
    end.
  else.
    z=. itemize dat
    y=. i. {:$ z
    x=. i. # z
  end.
  (x ,"0/ y),"1 0 z
else.
  if. isboxed dat do.
    select. #dat
    case. 1 do.
      y=. 0 pick dat
      x=. i.{:$y
    case. 2 do.
      'x y'=. dat
    end.
  else.
    y=. itemize dat
    x=. i. {:$ y
  end.
  x ,. |: y
end.
)

NB. gnuplot      - main plotting function
gpplot=: 3 : 0
dat=. y
cmd=. WITH
gpset 'output "',(jpath GNU),'"'
dat=. (>SURFACE{'';'s') getdata dat
shp=. $dat
dat gpwrite DAT
txt=. gpsetcommand''
txt=. txt, gpcommand cmd;shp;jpath DAT
txt fwrite PLT
t=. '"',EXE,'" "',(jpath PLT),'"'
if. IFWIN do.
   e=: spawn t
   if. #e do. smoutput 'error: ',e assert. 0 end.
else.
   try.
    spawn t
   catch.
    smoutput 'spawn failed - for error info run following in command window'
    smoutput '...$ ',t
    assert. 0
   end.
end.

if. -.fexist GNU do. smoutput 'error: ',GNU,' not created' assert. 0 end.
if. 0=#fread GNU do. smoutput 'error: ',GNU,' empty' assert. 0 end.

NB. massage gnu.htm
d=. fread GNU
d fwrite GNUX NB. unmodified gnuplot output
a=. 1 i.~ '<canvas id="gnuplot_canvas"' E. d
z=. 9+1 i.~ '</canvas>' E. d
n=. 1 i.~ '<table class="mbleft">' E. d
if. *./(#d)>a,z,n do.
 NB. move canvas to top and mousebox to left
 c=. (z-a){.(a}.d) NB. remove canvas
 d=. (n{.d),c,n}.d   NB. insert canvas at front 
 d=. d rplc '<table class="mbleft">';'<table>' NB. remove class so mousebox at left
else.
 d=. d rplc '<table class="plot">';'<table>'   NB. remove class so canvas at left
end.
f=. '~temp/gnuplot','/',TITLE,'.html'
d fwrite f
f
)

NB. returns gplot command
gpcommand=: 3 : 0
'cmd shp file'=. y
file=. '"',file,'"'
cmd=. cutstring cmd
spl=. SURFACE
NB. assume only 1 data set if surface
cls=. spl { (<:{:shp), 1
msk=. #~ -.@(+. ~:/\)@(e.&'''"')
txt=. msk each cmd
if. '[' e. j=. >{.txt do.
  b=. +./\.j=']'
  range=. b#first=. >{.cmd
  cmd=. (<(-.b)#first),}.cmd
else.
  range=. ''
end.
if. #cmd do.
  b=. (1: e. 'title'&E.) &> txt
  cmd=. (b{'notitle ';'') ,each cmd
  cmd=. ' ' ,each cmd
else.
  cmd=. <' notitle'
end.
if. SURFACE do.
  cmd=. ; cmd
  def=. file
else.
  cmd=. cls {. cmd, cls $ {: cmd
  cmd=. cmd ,&> <',\',LF
  def=. (file,"1 ' using 1:')&, &> ": each 2 + i.cls
end.
(>SURFACE{'';'s'),'plot ',range, ' ', _3 }. ,def ,"1 cmd
)

NB. build set arguments in SETBUFFER
NB. if y is empty, return and reset buffer
gpset=: 3 : 0
r=. empty ''
if. #y do.
  y=. y, ';' -. {: y   NB. ensure trailing ;
  SETBUFFER=: SETBUFFER,y
else.
  if. 0=4!:0 <'SETBUFFER' do.
    r=. SETBUFFER
  end.
  SETBUFFER=: ''
end.
r
)

gpsetcanvas=: 3 : 0
'wh mousing title'=. y
assert. (4-:3!:0 wh)*.2=#wh
wh=. (":wh)rplc' ';','
mousing=. (1-:mousing)#'mousing'
NB.! gpset 'term canvas standalone size ',wh,' ',mousing,' title "',title,'" jsdir "/',PATH,'/binary/share/gnuplot/4.4/js/"'
gpset 'term canvas standalone size ',wh,' ',mousing,' title "',title,'" jsdir "/',JSDIR,'"'
TITLE=: title
i.0 0
)

gpsetwith=: 3 : 0
WITH=: y
i.0 0
)

gpsetsurface=: 3 : 0
SURFACE=: y
)

gpsetcommand=: 3 : 0
;< @ ('set '&, @ (,&LF)) ;._2 gpset''
)

NB. gpwrite   - write data to file as text
gpwrite=: 4 : 0
dat=. gpflatten x
dat=. '-' (I. dat='_') } dat
dat fwrite y
)

NB. TARGET gplink ULR
NB. 'plot' gplink gplot 10?10
gplink=: 4 : 0
t=. '<a href="<REF>" target="<TARGET>" class="jhref" ><TEXT></a>'
t=. t rplc'<TARGET>';x;'<REF>';y;'<TEXT>';y
jhtml'<div contenteditable="false">',t,'</div>'
)

gpshow=: 4 : 0
jhtml '<!-- jseval window.open("',y,'","',x,'"); -->'
)

gpplot_z_      =: gpplot_jgnuplot_
gpinit_z_      =: gpinit_jgnuplot_
gpset_z_       =: gpset_jgnuplot_
gpsetcanvas_z_ =: gpsetcanvas_jgnuplot_
gpsetsurface_z_=: gpsetsurface_jgnuplot_
gpsetwith_z_   =: gpsetwith_jgnuplot_
gplink_z_      =: gplink_jgnuplot_
gpshow_z_      =: gpshow_jgnuplot_

NB. set EXE   as path to gnuplot binary
NB. set JSDIR as path to gnuplot javascript scripts
NB. hardwired OS assumptions that may need tweaking
3 : 0''
select. UNAME 
case. 'Win' do.
 EXE  =: (jpath'~home/gnuplot/binary/gnuplot.exe')rplc'/';'\'
 JSDIR=: '~home/gnuplot/binary/share/gnuplot/4.4/js/'
case. 'Linux' do.
 EXE  =: '/usr/bin/gnuplot'
 JSDIR=: '~root/usr/share/gnuplot/gnuplot/4.4/js/'
case. 'Darwin' do.
 EXE  =: '/usr/local/bin/gnuplot'
 JSDIR=: '~root/usr/local/share/gnuplot/4.4/js/'
case. do. assert. 0['unknown UNAME'
end.
if. -.fexist EXE do.
 smoutput EXE,' not found' assert. 0
end.
t=. 'canvastext.js',~(5*'~root/'-:6{.JSDIR)}.JSDIR
if. -.fexist t do.
 smoutput t,' not found' assert. 0
end.
)
