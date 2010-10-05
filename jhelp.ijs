NB. J HTTP Server - jhelp app
coclass'jhelp'
coinsert'jhs'

HBS=: 0 : 0
jhma''
 jhjmlink''
jhmz''
text
)

jev_get=: 3 : 0
'jhelp' jhr 'ENGINE CONFIG';(9!:14'');jpath'~addons/ide/jhs/config/jhs_default.ijs'
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
esc key escapes next key to be a shortcut.<br/>
For example, esc j links to ijx page.<br/>
Menu items document shortcuts on the right.<br/><br/>

esc 1 sets focus on menu.<br/>
esc 2 sets focus to page default.<br/><br/>

If esc does not work, use ctrl+. instead.

<br><br><span class="h">ijx</span>
run J sentences (ctrl+shift+&uarr;&darr; recall)

<br><br><span class="h">file</span>
browse files for opening, editing, etc.

<br><br><span class="h">ijs</span>
edit file

<br><br><span class="h">fif</span>
find in files utility

<br><br><span class="h">pacman</span>
addons package manager (downloadable software packages)

<br><br><span class="h">Plot</span><br>
jgc'help'  NB. plot info<br>
jgcx''     NB. examples<br>
plot 10?10 NB. default line plot

<br><br><span class="h">Viewmat</span><br>
jvm ?20 20$2<br>
jvm */~ i:9

<br><br><span class="h">utils</span><br>
jbd 1 NB. boxdraw +|-<br>
jlog y NB. 0 clears and _ restores log<br>
jfe_jhs_ y NB. toggle console/browser<br> 
jhtml'&lt;font style="color:red;"&gt;A&lt;/font&gt;'

<br><br><span class="h">configuration</span><br>
JHS initializes based on configuration files. See file<br>
&nbsp;&nbsp;<CONFIG><br>
for info on changing JHS configuration
</div>
)

CSS=: 0 : 0
span.h{color:red;}
*{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
)

