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
   plotdef 'link';400 200 NB. jhslink
   plotdemos 25
   plotdef 'none';600 300 NB. create ~temp/plot.html without show or link
   plotdef 'show';600 300 NB. jhsshow
   plotdemos 54
)

require '~addons/graphics/plot/plot.ijs'
require 'numeric trig'

load '~Demos/plot/plotdemos.ijs'

NB. kludge to adjust plot
coclass'jzplot'

canvas_show=: 3 : 0
'size file ctx'=. canvas_getparms y
res=. canvas_make size;file;ctx
res canvas_write file;ctx
if. IFJHS do.
 select. CANVAS_DEFSHOW 
 case. 'show' do. smoutput 'plot' jhsshow '~temp/plot.html'
 case. 'link' do. smoutput 'plot' jhslink '~temp/plot.html'
 end.
end.
)

plotdef_z_=: 3 : 0
'CANVAS_DEFSHOW_jzplot_ CANVAS_DEFSIZE_jzplot_'=: y
i.0 0
)

jhsplotdef 'show';400 200

