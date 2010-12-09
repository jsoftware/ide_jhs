NB. J HTTP Server - jhelp app
coclass'jhelp'
coinsert'jhs'

HBS=: 0 : 0
jhma''
 jhjmlink''
jhmz''
jumps
jhresize''
text hrplc 'PAREN CONFIG JVERSION';')';'~addons/ide/jhs/config/jhs_default.ijs';JVERSION
)

jev_get=: 3 : 0
'jhelp'jhr''
)

jumps=: 0 : 0
<a href="#help">Help</a>&nbsp;
<a href="#j7">J701</a>&nbsp;
<a href="#jhs">JHS</a>&nbsp;
<a href="#ide">IDE</a>&nbsp;
<a href="#gui">GUI</a>&nbsp;
<a href="#jum">JUM</a>&nbsp;
<a href="#config">Config</a>&nbsp;
<a href="#gtk">GTK</a>&nbsp;
<a href="#about">About</a>
)

text=: 0 : 0
<div>

<a name="help"><h1>Help</h1>
This document links to lots of information, but is
itself quite short and can be skimmed in a few minutes.
A bit of time here will pay off down the road.<br><br>

For complete documentation see:<br>
<a href="http://www.jsoftware.com/docs/help701/index.htm">www.jsoftware.com/docs/help701/index.htm</a>
<br>or if you have installed local help with pacman see:<br>
<a href="~addons/docs/help/index.htm">~addons/docs/help/index.htm</a>

<a name="j7"><h1>J701</h1></a>
J701 is a release of the J programming language.
The J701 downloadable install is a minimal install that
depends on the web to access a wealth of additional material:
software addons, documentation, examples, wiki,
and discussion forums.<br><br>

The J701 install includes the J engine, a console interface,
a browser interface (JHS), and the J library.

<a name="jhs"><h1>JHS (J HTTP Server)</h1></a>
JHS is a browser interface to J and
is an alternative to a more traditional desktop application
front end. JHS gives you interactive access to J, an IDE, and
a framework for developing and delivering web applications.
<br><br>

JHS is the J engine running as a console task configured with
scripts to run as an HTTP server. A browser gets pages
from JHS.<br><br>

In default configuration, JHS is similar to a
desktop application. It runs on your desktop and
services local requests from your browser.
It can be configured to provide services to browsers
across a local area network or across the web.<br><br>

JHS is a departure from previous desktop application
front ends and is somewhat experimental.
One issue that arises is whether the JHS IDE should
be as much like a desktop frontend as possible or
whether it should be as much like a browser app as
possible.<br><br>

JHS leans strongly towards being a browser app. You may miss
some desktop features and it may take a while to be comfortable
with the browser approach. With a bit a patience and the
adoption of powerful browser paradigms the result might
please. One advantage of this is that developing new browser
apps from a browser app helps focus the mind.<br><br>

JHS reinvents the wheel in the sense that it doesn't make
use of any of the excellent javascript toolkits for browser
applications. This was partly for the fun of it and partly
because it seemed possible to do so in a lean and effective way.
The JHS javascript library is tiny compared to kits like
jquery.js and ext.js. Hopefully this makes it easier to learn
and use for those who aren't proficient javascript programmers.
There was also a feeling that these toolkits have
largely been developed to deal with complex issues of browser
incompatibilies in older browsers. By insisting on
modern browsers JHS avoids many of these issues. And looking
a bit forward to html5 much of the nice packaging of 
services in these toolkits will come for free. And if
appropriate, it is easy to include any additional toolkit
with the JHS framework and have the best of all worlds
in developing your browser app.
 
<a name="ide"><h1>IDE (Interactive Development Environment)</h1></a>
<span class="h">keyboard shortcuts</span><br>
esc key escapes next key to be a shortcut.<br/>
For example, esc j links to ijx page.<br/>
Menu items document shortcuts on the right.<br/>
esc 1 sets focus on menu.<br/>
esc 2 sets focus to page default.<br/>
You can user ctrl+. instead of esc.

<br><br><span class="h">ijx</span>
run J sentences (ctrl+shift+&uarr;&darr; recall)

<br><br><span class="h">file</span>
browse files for editing, etc.<br><br>

Adequate for simple IDE use and for a remote server.
For more complicated requirements use host facilities such
as Windows Explorer or Mac Finder.

<br><br><span class="h">ijs</span>
edit file (ctrl+z/y for undo/redo)

<br><br><span class="h">fif</span>
find in files utility

<br><br><span class="h">pacman</span>
addons package manager (downloadable software packages)

<br><br><span class="h">plot</span> <a href="http://code.google.com/apis/chart/">Google Charts</a>
<pre class="jcode">
   jgc'help'  NB. plot info
   jgcx''     NB. examples
   plot 10?10 NB. default line plot
</pre>

<span class="h">viewmat</span>
<pre class="jcode">
   viewmat ?20 20$2
   viewmat */~ i:9
</pre>

<span class="h">utils</span>
<pre class="jcode">
   jbd 1      NB. boxdraw +|-
   jlog y     NB. 0 clears and _ restores log
   jfe_jhs_ y NB. toggle console/browser
   jhtml'&lt;font style="color:red;"&gt;A&lt;/font&gt;'
</pre>

<span class="h">ijx action menu</span><br>
A script defines action menu items and the verbs to run
when clicked. The following is a sample file you can
define and then modify:
<pre class="jcode">
*** script ~user/projects/ja/ja.ijs ***
coclass'z'
ja_menu=: 0 : 0
aaa
bbb
<PAREN>

ja_aaa=: 3 : 0
'aaa clicked'
<PAREN>

ja_bbb=: 3 : 0
'bbb clicked'
<PAREN>
***
</pre>

<span class="h">ijx project manager</span><br>
An ijx action menu item can provide a simple project manager.
A menu click can load/reload project files.
This can be especially helpful if an external editor
is used.<br><br>

<span class="h">ijx debug menu</span><br>
With debug on (ijx menu debug), execution suspends at an error or a stop.
<pre class="jcode">
   dbsm'name'      - display numbered definition lines
   dbsm'name ...'  - add stops
   dbsm'name :...' - add dyadic stops
   dbsm'~...'      - remove stops starting with ...
   dbsm''          - display stops
</pre>

Try the following:
<pre class="jcode">
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

<a name="gui"><h1>GUI</h1>

GUI applications are built with J, JHS framework, html,
javascript, and css.

See ijx demos for examples of GUI applications.<br><br>

The IDE is built with the same facilities. See
~addons/ide/jhs/jfile.ijs to see how the file page is
implemented.<br><br>

You can create simple applications with just info
from the demos. For more complicated applications you
need to learn about html, DOM (document object model),
javascript, and css (styles).<br><br>

There are great web resources on these topics.
You may prefer more structured
presentation and there are many books to choose from. None
stand out, but 'The Definitive Guide' series from O'Reilly
on HTML, Javascript, and CSS are adequate.<br><br>

There is a lot to learn to cover everything. Fortunately
the learning curve, though long, is not terribly steep
and there are significant rewards along the way.
Everything you learn is applicable not just to J,
but to every aspect of the incredible world of web programming.

<a name="jum"><h1>JUM (J User Manager)</h1>
JUM is a JHS application that runs on a web server
that provides JHS servers to J users. JUM users share
a single user account on the server and your files are
accessible to other users.<br><br>

To provide a JUM service you install J701 on a web server
and run the JHS JUM application. Users can access the JUM
web page and can manage their own JHS server.
The JUM sevice should be provided in a secure environment.
In a Linux server this is done with a jail account.
<br><br>
Jsoftware currently hosts JUM as a courtesy to
users who want a taste of the new.
Jsoftware JUM can be discontinued or 
disrupted at any time without notice. JUM is a shared
service and your files are accessbile to other users.
<br><br>
&nbsp;&nbsp;&nbsp<a href="http://www.jsoftware.com:50001/jum">www.jsoftware.com:50001/jum</a>
 (jum pass to create account is jumjum)<br><br>
Study script ~addons/ide/jhs/jum.ijs to learn how to run your own JUM service.
A rough sketch of the steps are:
<pre class="jcode">
   start jconsole task
   load'~addons/ide/jhs/core.ijs'
   load'~addons/ide/jhs/jum.ijs'
   createjum_jum_ 65002;'1234' NB. only if new PORT or PASS
   init_jhs_'jum'
   browse to jum task /jijx and login 
   startjum_jum_ 65003 65004 65005;'localhost';'buzz'
   browse to jum task /jum and create new account
</pre>

<a name="config"><h1>Config</h1>
For info on changing JHS config see file: <CONFIG>

<a name="gtk"><h1>GTK</h1>

A desktop application front end, built with GTK, is also
available for J. It provides a powerful IDE and allows
development of state of the art GUI desktop applications.

Run jgtk from jconsole with sentence:
<pre class="jcode">   load'gtkide'</pre>

<a name="about"><h1>About</h1></a>
<pre class="jcode">
   JVERSION
<JVERSION>
</pre>
</div>
)

NB. *{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}

CSS=: 0 : 0
span.h{color:red;}
)

JS=: 0 : 0
function ev_body_load(){jresize();}
)
