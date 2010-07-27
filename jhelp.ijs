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
(B getbody BIS)hrplc'ENGINE CONFIG';(9!:14'');jpath'~addons/ide/jhs/jhs_default.ijs'
)

B=: 0 : 0 NB. body template
jma jmlink jmz
text
)

BIS=: 0 : 0 NB. body template id-sentence pairs
tool hmg'tool'
text text
)

JS=: hjs 0 : 0
function evload(){;} // body onload -> jevload -> evload

function ev_jmlink_click(){menuclick();}
)

text=: 0 : 0
<div>
<a href="http://www.jsoftware.com/help">www.jsoftware.com/help</a>
 <a href="http://www.jsoftware.com">www.jsoftware.com</a><br><br>
<span class="h">J Http Server</span>
<br><br><span class="h">about</span><br>
J701 - Copyright 1994-2010 Jsoftware Inc.
<br>Engine: <ENGINE>
<br><br><span class="h">keyboard shortcuts</span><br>
ctrl+/ treats next character as a shortcut.
On jijx page, pressing ctrl+/ and then lowercase o
links to jfile (open) page.
Shortcuts are documented on the right in a menu item.

<br><br><span class="h">jijx page</span><br>
enter J sentences (&uarr;&darr; recall)<br>
jlog 0 NB. clear log<br>
jlog _ NB. restore complete log

<br><br><span class="h">jfile page</span><br>
browse files for opening, editing, etc.

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

<br><br><span class="h">utils</span><br>
jbd 1 NB. boxdraw +|-<br>
jlog y NB. 0 clears and _ restores log<br>
jfe_jhs_ y NB. toggle console/browser<br> 
jhtml'&lt;font style="color:red;"&gt;A&lt;/font&gt;'

<br><br><span class="h">configuration</span><br>
JHS initializes based on configuration files.<br><br>

Configuration includes port to serve,
localhost password rules, remote host password,
and username for multiple users on the same server.<br><br>

See file<br>
&nbsp;&nbsp;<CONFIG><br>
for info on changing JHS configuration
</div>
)


