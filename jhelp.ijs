NB. J HTTP Server - jhelp app
coclass'jhelp'
coinsert'jhs'

HBS=: 0 : 0
jhma''
 jhjmlink''
jhmz''
text rplc '<PAREN>';')'
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
run J sentences (ctrl+shift+&uarr;&darr; recall)<br>
<a href="#action">action menu</a>
<a href="#project">project manager</a>
<a href="#debug">debug menu</a>

<br><br><span class="h">file</span>
browse files for opening, editing, etc.

<br><br><span class="h">ijs</span>
edit file (ctrl+z/y for undo/redo)

<br><br><span class="h">fif</span>
find in files utility

<br><br><span class="h">pacman</span>
addons package manager (downloadable software packages)

<br><br><span class="h">plot</span>
<pre>   jgc'help'  NB. plot info
   jgcx''     NB. examples
   plot 10?10 NB. default line plot
</pre>

<span class="h">viewmat</span>
<pre>
   jvm ?20 20$2
   jvm */~ i:9
</pre>

<span class="h">utils</span>
<pre>   jbd 1 NB. boxdraw +|-
   jlog y NB. 0 clears and _ restores log
   jfe_jhs_ y NB. toggle console/browser
   jhtml'&lt;font style="color:red;"&gt;A&lt;/font&gt;'
</pre>

<a name="action">
<span class="h">ijx action menu</span><br>
A script defines action menu items and the verbs to run
when clicked. The following is a sample file you can
define and then modify:<br><br>
<tt>
*** script ~user/projects/ja/ja.ijs ***<br>
coclass'z'<br><br>
ja_menu=: 0 : 0<br>
aaa<br>
bbb<br>
<PAREN><br><br>

ja_aaa=: 3 : 0<br>
'aaa clicked'<br>
<PAREN><br><br>

ja_bbb=: 3 : 0<br>
'bbb clicked'<br>
<PAREN><br>
***<br><br>
</tt>

<a name="project">
<span class="h">ijx project manager</span><br>
An ijx action menu item can provide a simple project manager.
A menu click can load/reload the project files.
This can be especially helpful if an external editor
is used.<br><br>

<a name="debug">
<span class="h">ijx debug menu</span><br>
With debug on (ijx menu debug), execution suspends at an error or a stop.
<pre>
   dbsm'name'      - display numbered definition lines
   dbsm'name ...'  - add stops
   dbsm'name :...' - add dyadic stops
   dbsm'~...'      - remove stops starting with ...
   dbsm''          - display stops
</pre>

Try the following:
<pre>
   dbsm'calendar'   NB. numbered explicit defn
   dbsm'calendar 0' NB. stop monadic line 0
menu debug|on
   calendar 1
study stack display - note 6 blank prompt
   y
menu debug|step in
stepped into dyadic call of calendar
   x,y
menu debug|step - step to line 1
   a
menu debug|run - run to error or stop
(runs to end as no error or stops)
</pre>

<span class="h">configuration</span><br>
JHS initializes based on configuration files. See file<br>
&nbsp;&nbsp;<CONFIG><br>
for info on changing JHS configuration

</div>
)

CSS=: 0 : 0
span.h{color:red;}
*{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
)

