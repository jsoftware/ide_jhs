0 : 0
there are several ways to visual data in JHS
this is a rough draft and needs lot of work
some graphs show inline in jijx
others show in new (or reused) tabs
)

NB. viewmat
load'viewmat'
viewmat ?10 10$100
viewmat */~ i:9

NB. native plot
load'plot'
plotdef 'jijx';'plot';400 200;'canvas'
plot ?10$100
plot ?2 10$100

load '~Demos/wdplot/plotdemos.ijs' NB. more than 50 demos
plotdemos 0
plotdef 'show';'plot';600 400    NB. type;window;size
plotdemos 1
plotdef 'show';'plot';600 300
plotdemos 3                      NB. show in window named plot
plotdemos 4                      NB. window reused
plotdef 'link';'plot';600 450    NB. link to plot
plotdemos 10
plotdef 'jijx';'';400 100        NB. inline in jijx
plotdemos 25
plotdef 'none';'plot';600 300    NB. create ~temp/plot.html - not shown
plotdemos 30
'plot' jhsshow '~temp/plot.html' NB. show plot in window plot
plotdef 'jijx';'';400 200
plotdemos 54

0 : 0
cairo not supported

plotdef 'none';'plot';400 200;'cairo'
plot 10?10                       NB. create ~temp/plot.png
plotdef 'jijx';'plot';400 200;'cairo'
plot 10?10                       NB. inline in jijx
)

plotdef 'jijx';'plot';400 200;'canvas'
plot 10?10   
  
NB. put link to jd3 here
jd3'help'
'abc'jd3 ?3 10$100
   
   
NB. google plots
jhtml'<div contenteditable="false"><a href="http://code.google.com/apis/chart/"  target="_blank">Google Charts</a></div>'
load'~addons/ide/jhs/jgcp.ijs'
jgc'help'  NB. plot info
jgcx''     NB. examples

NB. WebGL 
rundemo_jhs_ 12

NB. gnuplot
0 : 0
gnuplot

gnuplot www.gnuplot.info
Plots can be created with gnuplot and displayed in the browser.

The following is out of date and needs changes in order to make use of the new gnuplot addon.

After gnuplot is installed, try the following:
)

jhtml'<div contenteditable="false"><a href="http://www.gnuplot.info"  target="_blank">gnuplot info</a></div>'
load'~addons/ide/jhs/gnuplot.ijs'
require'numeric trig'
   
term_png             =: 'term png tiny size 400,200 background 0xffffff'
term_canvas          =: gpcanvas 400 200;1;'plot'
term_canvas_mouseless=: gpcanvas 400 200;0;'plot'

gpd0=: 4 : 0
gpinit''
gpset y
gpset 'grid'
gpset 'title "sin(exp) vs cos(exp)"'
gpset 'xlabel "x-axis"'
gpset 'ylabel "y-axis"'
gpsetwith 'with lines title "sin(exp)", with lines title "cos(exp)"'
x gpplot  (;sin@^,:cos@^) steps _1 2 100
)

gpd1=: 4 : 0
wiggle=. 4
points=. 200
X=. (3 % <:points) * i.points
fn=. +/@((0.9&^) * cos@((3&^ * (+/&X))))@i.
XY=. fn wiggle
gpinit''
gpset y
gpsetwith 'with lines'
x gpplot X;XY
)

gpd2=: 4 : 0
xd=. range _3 3 0.2
yd=. range _3 3 0.2
zd=. sin xd +/ sin yd
CP=. xd;yd;zd
gpinit''
gpset y
gpset 'title "sin(x+sin(y))"'
gpset 'parametric'
gpsetwith 'with lines'
gpsetsurface 1
x gpplot CP
)

gpd3=: 4 : 0
xd=. range _3 3 0.1
yd=. range _3 3 0.1
SP=. xd;yd;(sin xd) */ sin yd
gpinit''
gpset y
gpset 'title "sin(x)*sin(y)) contour plot"'
gpset 'parametric;contour;cntrparam levels 20;view 0,0,1;nosurface'
gpsetwith 'with lines'
gpsetsurface 1
x gpplot SP NB. surface plot
)

gpd4=: 4 : 0
gpinit''
gpset y
gpsetwith'with lines'
x gpplot 10?10
)

   
'd0' gpd0 term_png                  NB. create png file
'd0' gpd0 term_canvas               NB. create html file

jhspng  'd0' gpd0 term_png          NB. display in session
jhslink 'd1' gpd1 term_canvas       NB. link to file
jhsshow 'd2' gpd2 term_canvas       NB. show file in popup

'one' jhslink 'd0' gpd0 term_canvas NB. window named one
'one' jhslink 'd1' gpd1 term_canvas

'one' jhsshow 'd2' gpd2 term_canvas
'one' jhsshow 'd3' gpd3 term_canvas

'one' jhsshow 'd4' gpd4 term_canvas
'one' jhsshow 'd4' gpd4 term_canvas

