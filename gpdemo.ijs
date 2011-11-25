NB. gnuplot demos

gpdemo=: 0 : 0
NB. requires JAL general/misc and math/misc installs
NB. gp0 through gp5 create html plot files
   gp0''               NB. create html plot file
NB. jhslink creates link to file
   'abc' jhslink gp0'' NB. window abc - click link to see plot
NB. jhsshow shows plot in pop up window
NB. pop ups normally blocked - jhsshow requires they are allowed
   'abc' jhsshow gp0''
   'abc' jhsshow gp2'' NB. mouse x y, left click, right zoom area
NB. gp6 has an error
   gp6''
)

require 'numeric trig'

gp0=: 3 : 0
gpinit''
gpsetcanvas 400 200;0;'plot'
gpsetwith'with lines'
gpplot 10?10   NB. create ~temp/gnuplot/gnu as gnuplot canvas output
gpcanvas 'gp0' NB. create ~temp/gnuplot/gp0.html from gnu
)

gp1=: 3 : 0
SC=: (;sin@^,:cos@^) steps _1 2 100
gpinit''
gpset 'grid'
gpset 'title "sin(exp) vs cos(exp)"'
gpset 'xlabel "x-axis"'
gpset 'ylabel "y-axis"'
gpsetcanvas 400 200;0;'gp1' NB. width height;mousing;title
gpsetwith 'with lines title "sin(exp)", with lines title "cos(exp)"'
gpplot SC
gpcanvas 'gp1'
)

gp2=: 3 : 0
SC=: (;sin@^,:cos@^) steps _1 2 100
gpinit''
gpset 'grid'
gpset 'title "sin(exp) vs cos(exp)"'
gpset 'xlabel "x-axis"'
gpset 'ylabel "y-axis"'
gpsetcanvas 400 200;1;'gp2'  NB. width height;mousing;title
gpsetwith 'with lines title "sin(exp)", with lines title "cos(exp)"'
gpplot SC
gpcanvas 'gp2'
)

gp3=: 3 : 0
wiggle=. 4
points=. 200
X=. (3 % <:points) * i.points
fn=. +/@((0.9&^) * cos@((3&^ * (+/&X))))@i.
XY=: fn wiggle
gpinit''
gpsetcanvas 400 200;1;'gp3'
gpsetwith 'with lines'
gpplot X;XY
gpcanvas 'gp3'
)

NB. surface plot
gp4=: 3 : 0
x=. range _3 3 0.2
y=. range _3 3 0.2
z=. sin x +/ sin y
CP=: x;y;z
gpinit''
gpset 'title "sin(x+sin(y))"'
gpset 'parametric'
gpsetcanvas 600 400;0;'gp4'
gpsetwith 'with lines'
gpsetsurface 1
gpplot CP NB. surface plot
gpcanvas 'gp4'
)

gp5=: 3 : 0
x=. range _3 3 0.1
y=. range _3 3 0.1
SP=: x;y;(sin x) */ sin y
gpinit''
gpset 'title "sin(x)*sin(y)) contour plot"'
gpset 'parametric;contour;cntrparam levels 20;view 0,0,1;nosurface'
gpsetcanvas 500 500;0;'gp5'
gpsetwith 'with lines'
gpsetsurface 1
gpplot SP NB. surface plot
gpcanvas 'gp5'
)

NB. an error
gp6=: 3 : 0
SC=: (;sin@^,:cos@^) steps _1 2 100
gpinit''
gpset'badcommand'
gpsetcanvas 400 200;1;'gp6' NB. width height;mousing;title
gpsetwith 'with lines title "sin(exp)", with lines title "cos(exp)"'
gpplot SC
gpcanvas 'gp6'
)
