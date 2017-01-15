NB. J HTTP Server - jhelp app
coclass'jhelp'
coinsert'jhs'

HBS=: 0 : 0
jumps
jhresize''
text hrplc 'PAREN CONFIG JVERSION';')';'~addons/ide/jhs/config/jhs_default.ijs';JVERSION
)

jev_get=: 3 : 0
'jhelp'jhr''
)

jumps=: 0 : 0
<a href="#pop-up">pop-up</a>&nbsp;
<a href="#quickstart">quick-start</a>&nbsp;
<a href="#highlights">highlights</a>&nbsp;
<a href="#jhs">JHS</a>&nbsp;
<a href="#ide">IDE</a>&nbsp;
<a href="#gui">GUI</a>&nbsp;
<a href="#console">console</a>&nbsp;
)

text=: 0 : 0
<div>
<p>This document links to lots of information, but is itself quite short.
A bit of time here will pay off down the road.</p>
<a name="pop-up"><h1>pop-up</h1></a>
<p>Pop-up windows can be a plague when browsing ill-behaved sites.
However, they can be very useful in an app like JHS that
tries to combine the best of the browser interface with some
features of classic desktop applications.
JHS facilities like jd3 (plots), jtable (spreadsheet), and demos
work best if they can create pop-ups.</p>

<p>If your browser is set to block pop-ups, then you will get
an alert message when JHS tries to create a pop-up. You can
adjust the browser settings to allow the pop-ups.</p>

<p>You may not want to enable all pop-ups, and instead only allow JHS pop-ups.
More recent versions of most browsers (Firefox/Chrome/Edge/IE)
allow you to configure pop-up blocking to allow pop-ups based
on the site address. In this case you want to enable pop-ups
from localhost:65001/jijx. Safari does not allow this kind of
configuration and you may want to simply allow all pop-ups.</p>

<p>If you don't want to enable pop-ups, you can get by with
the NOPOPUP option. With this option, instead of a pop-up,
a link is created in your jijx page. Click the link to see
the page. This work-around is not supported in all cases.
<div class="jcode">   NOPOPUP_jhs_=: 1</div></p>

<p>Default target is _blank so new pages appear in new tabs
(for example, menu link>jal).
Change this if you want new pages to replace the current page.
<div class="jcode">   TARGET_jhs_=: '_self'</div></p>

<a name="quickstart"><h1>quick-start</h1></a>
Get started with the tour menu. Take the J 1 tour to learn a bit about J
and be sure to take the plot tour. Play with the studio menu to learn more
about JHS.

<a name="highlights"><h1>highlights</h1>

<p>Important changes over the last few updates that might
catch your interest.</p>

<p><a href="#pop-up">Pop-up</a> windows are used more.
For example <span class=jcode> open '~temp/1.ijs' </span>opens
an jijs tab. Previously
it would have displayed a link that you clicked (a click is not a pop-up).</p>

<p>Window ids are used to avoid opening duplicate tabs. For example, opening a script 
from a file or files page reopens in a tab if it already exists.

<p>Learn about the various ways to visualize data. See studio>plot tour.</p>

<p>Learn how to build your own GUI apps. See studio>app building.</p>

<p>Take a look at studio>demos and run the new demo 13.</p>

<p>Learn how to use powerful debug tools with reworked example and
utilities. See studio>debug.</p>

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

<a name="config"><h1>config</h1>
Detailed information at
<a href="http://code.jsoftware.com/wiki/Guides/JHS/Server" target="_blank">wiki/Guides/JHS/Server</a>.<br><br>

<a name="ide"><h1>IDE (Interactive Development Environment)</h1></a>
<span class="h">keyboard shortcuts</span><br>
esc key escapes next key to be a shortcut.<br/>
For example, esc j links to jijx page.<br/>
Menu items document shortcuts on the right.<br/>
esc 1 sets focus on menu.<br/>
esc 2 sets focus to page default.

<p>Mobile device may not have an esc key.
Touch: s and slide to ß. Wireless: hold down option and press s.</p>

Control shortcuts are supported for ,./<>? as they
less likely conflict with the browser.<br/><br/>

jijx ctrl+. is lab/spx advance.<br/><br/>

Example of a custom jijx handler:
<pre>   ev_comma_ctrl_jijx_=: 3 : 'i.5'</pre>

Other pages require J and Javascript handlers. For example,
<pre>
ev_comma_ctrl=: 3 : 'i.5'
function ev_comma_ctrl(){jdoajax([]);}
</pre>

<span class="h">jijx</span>
Run J sentences (ctrl+shift+&uarr;&darr; recall)

<br><br><span class="h">jfile</span>
Browse files for editing, etc.
Adequate for simple IDE use and for a remote server.
For more complicated requirements use host facilities such
as Windows Explorer or OSX Finder.

<br><br><span class="h">jfiles</span>
Recent file list - click to open.

<br><br><span class="h">jijs</span>
CodeMirror (www.codemirror.net) editor. See menu action|search/ctrl for ctrl/search/replace info.
<a href="#codemirror">CodeMirror Copyright</a>

<br><br><span class="h">jfif</span>
find in files

<br><br><span class="h">jal</span>
addons package manager (pacman) - download/install software packages

<br><br><span class="h">utils</span>
<pre class="jcode">
   jbd 1      NB. boxdraw +|-
   jfe_jhs_ y NB. toggle console/browser
   jhtml'&lt;font style="color:red;"&gt;A&lt;/font&gt;'

   t=. '~addons/docs/help/index.htm'jhref_jhs_'help'
   jhtml'&lt;div contenteditable="false"&gt;',t,'&lt;/div&gt;'

   open'~temp/f.ijs' NB. open file in jijs tab
</pre>

<span class="h">jijx action menu</span>
A script defines action menu items and the verbs to run
when clicked. Shortcuts wqe are hardwired to the first
3 added menu items. The following is a sample file you can
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

<a name="gui"><h1>GUI</h1></a>
<p>See jijx studio->app building for information on building GUI apps.</p>

<p>See jijx studio->demos for app examples.</p>


<p>The IDE is built with the same facilities. See
~addons/ide/jhs/jfile.ijs to see how the jfile page is
implemented.</p>

<p>GUI apps are built with J, JHS framework, html, DOM (document object model), javascript, and css.</p>

<p>There are great web resources on these topics.
You may prefer more structured
presentation and there are many books to choose from. None
stand out, but 'The Definitive Guide' series from O'Reilly
on HTML, Javascript, and CSS are adequate.</p>

<p>There is a lot to learn to cover everything. Fortunately
the learning curve, though long, is not terribly steep
and there are significant rewards along the way.
Everything you learn is applicable not just to J,
but to every aspect of the incredible world of web programming.</p>

<a name="console"><h1>console</h1></a>
The JHS jconsole window diplays useful information.<br><br>
It can be used (ctrl+c) to signal break to the J task and
it can kill the J task in the event of problems.<br><br> 

In windows you can edit the icon properties to run minimized.
You can hide the window if you wish:
<pre class="jcode">   jshowconsole_j_ 0 NB. hide/show 0/1</pre>

</div>
)

CSS=: 0 : 0
span.h{color:red;}
)

JS=: 0 : 0
function ev_body_load(){jresize();}
)
