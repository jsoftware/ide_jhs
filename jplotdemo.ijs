NB. jplot demos

jplotdemo=: 0 : 0
NB. requires JAL graphics/plot and graphics/afm installs
NB. requires JAL general/misc and math/misc installs
NB. jplot 0 through jplot 54 create html plot files
   jplot 22               NB. create html plot file
NB. jhslink creates link to file
   'abc' jhslink jplot 22 NB. window abc - click link to see plot
NB. jhsshow shows plot in pop up window
NB. pop ups normally blocked - jhsshow requires they are allowed
   'abc' jhsshow jplot 22
)

require '~addons/graphics/plot/plot.ijs'
require 'numeric trig'

load '~Demos/plot/plotdemos.ijs'

jplot=: 3 : 0
plotdemos y    NB. create ~temp/plot.htm
'~temp/plot.htm'
)
