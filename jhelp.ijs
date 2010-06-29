NB. J HTTP Server - jhelp app
coclass'jhelp'
coinsert'jhs'

CSS=: 0 : 0
span.h{color:red;}
)

jev_get=: 3 : 0
hr 'jhelp';(css CSS);(JSCORE,JS);createbody''
)

createbody=: 3 : 0
(B getbody BIS)hrplc'VERSION ENGINE';VERSION;9!:14''
)

B=: 0 : 0 NB. body template
jide
text
)

BIS=: 0 : 0 NB. body template id-sentence pairs
text text
)

JS=: hjs 0 : 0
function evload(){;} // body onload -> jevload -> evload
)

text=: 0 : 0
<div>
<a href="http://www.jsoftware.com/help">www.jsoftware.com/help</a>
 <a href="http://www.jsoftware.com">www.jsoftware.com</a><br><br>
<span class="h">J Http Server</span>
<br><br><span class="h">about</span><br>
J701 - Copyright 1994-2010 Jsoftware Inc.
<br>JHS: <VERSION>
<br>Engine: <ENGINE>
<br><br><span class="h">keyboard shortcuts</span><br>
JHS IDE has 3 standard ctrl shortcuts:<br>
[ jijx<br>] jfile<br>\ jhelp<br>
<br>
JHS IDE has 3 page specific ctrl shortcuts:<br>
, 1st button before &diams;<br>
. 2nd<br>
/ 3rd<br>

<br>JHS apps can use []\,./ with ctrl and ctrl+shift.
<br>Others likely conflict with browser shortcuts. 

<br><br><span class="h">jijx page</span><br>
enter J sentences (&uarr;&darr; recall)<br>
jlog 0 NB. clear log<br>
jlog _ NB. restore complete log

<br><br><span class="h">jfile page</span><br>
browse files and open or edit files

<br><br><span class="h">jijs page</span><br>
edit file

<br><br><span class="h">Viewmat</span><br>
jvm ?20 20$2<br>
jvm */~ i:9

<br><br><span class="h">Plot</span><br>
jpdfplot 10?10 NB. pdf plot<br>
jsvgplot 10?10 NB. svg - xml scalable vector graphics<br><br>

click jijx window link or open in jfile<br><br>

(svg only draws line - not integrated into plot yet)

<br><br><span class="h">config</span><br>
jconfig 0     NB. default<br>
jconfig 1     NB. iPhone (or similar)<br>

<br>iPhone log works top down<br>
(perhaps handy with screen keyboard)

<br><br><span class="h">utils</span><br>
jbd 1 NB. boxdraw +|-<br>
jconfig y NB. 0 default, 1 iPhone<br>
jlog y NB. 0 clears and _ restores log<br>
jfe_jhs_ y NB. toggle console/browser<br> 
jhtml'&lt;font style="color:red;"&gt;A&lt;/font&gt;'

<br><br><span class="h">jhs start</span><br>
load'~addons/ide/jhs/start.ijs'
</div>
)


