NB. jplot demos

plotdemo=: 0 : 0
NB. requires JAL graphics/plot and graphics/afm installs
NB. requires JAL general/misc and math/misc installs
NB. plotdemos 0 through jplot 54 create html plot files
   plot 10?10
   plotdemos 1
   plotdemos 10
   plotdef 'show';600 300 NB. jhsshow width height
   plotdemos 10
   plotdef 'link';600 450 NB. 4:3 aspect ratio
   plotdemos 10
   plotdef 'link';400 200 NB. jhslink
   plotdemos 25
   plotdef 'none';600 300 NB. create ~temp/plot.html without show or link
   plotdef 'show';600 300 NB. jhsshow
   plotdemos 54
)

require 'plot'
require 'numeric trig'

load '~Demos/plot/plotdemos.ijs'

plotdef 'show';400 300

