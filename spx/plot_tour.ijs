0 : 0

there are several ways to visual data in JHS

this is a rough draft and needs lot os work

some graphs show inline in jijx
others show in new (or reused) tabs
)

load'viewmat'
viewmat ?10 10$100
viewmat */~ i:9

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
jhtml'<h3>gcplot <div contenteditable="false"><a href="http://code.google.com/apis/chart/"  target="_blank">Google Charts</a></div></h3>'
load'~addons/ide/jhs/jgcp.ijs'
jgc'help'  NB. plot info
jgcx''     NB. examples

NB. WebGL 
rundemo_jhs_ 12
