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
<a href="#close">close</a>&nbsp;
<a href="#libraries">libraries</a>&nbsp;
<a href="#highlights">highlights</a>&nbsp;
<a href="#jhs">JHS</a>&nbsp;
<a href="#ide">IDE</a>&nbsp;
<a href="#console">console</a>&nbsp;
)

text=: 0 : 0
<div>
<p>This document links to lots of information, but is itself quite short.
A bit of time here will pay off down the road.</p>

<p>Be sure to read pop-up and close sections!</p>

<p>Get started with the tour menu. Take the J 1 tour to learn a bit about J
and be sure to take the plot tour. Play with the tool menu to learn more
about JHS.</p>

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

<a name="close"><h1>close</h1></a>
<p>The preferred way to close a JHS page is to press ctrl+\ or click the
red button in the upper left corner. This lets JHS manage the close and 
save data and free up resources as appropriate.</p>

<p>Only pages opened by other pages can be closed this way. For example, crtl+\
on a jijx page opened by a bookmark is ignored.</p>

<p>The browser accesses the web and it can be a wild out there.
Badly behaved sites try to usurp your control with pages that won't close gracefully.
The browser is in an ongoing battle to keep you
in control. When you click a tab close button, the browser assumes you mean it.
There are mechanisms to give the application some control but they are badly flawed.</p>

<a name="libraries"><h1>libraries</h1></a>
<p>JHS includes several javascript libraries.</p>

<a href="http://codemirror.net/" target="_blank">CodeMirror</a><br>
<a href="http://www.jquery.com" target="_blank">jQuery</a><br>
<a href="http://www.handsontable.com" target="_blank">Handsontable</a><br>
<a href="http://www.d3js.org" target="_blank">D3</a><br>

<a name="highlights"><h1>highlights</h1>

<p><a href="#pop-up">Pop-up</a> windows are used more.

<p>Window ids used to avoid opening duplicate tabs. For example, opening a script 
from a file or files page reopens in a tab if it is already open.

<p>New style of app use locales for state information and use ctrl+\ or red button
in upper left corner for managed close.</p>

<p>Menus are reorganized. In particular see the new tool and tour menus and explore
all the items.</p>

<p>Learn about the various ways to visualize data. See menu tour>plot.</p>

<p>Learn how to build your own GUI apps. See menu tour>app.</p>

<p>Take a look at menu tour>demos and be sure to run the new demos 13 and 14.</p>

<p>Learn how to use powerful debug tools with reworked example and
utilities. See tool>debug.</p>

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
<span class="h">jijx</span> Run J sentences (ctrl+shift+&uarr;&darr; recall)

<br><br><span class="h">jfile</span>
Browse files for editing, etc.
Adequate for simple IDE use and for a remote server.
For more complicated requirements use host facilities such
as Windows Explorer or OSX Finder.

<br><br><span class="h">jfiles</span> recent file list - click to open.

<br><br><span class="h">jijs</span> script editor

<br><br><span class="h">jfif</span> find in files

<br><br><span class="h">jal</span>
addons package manager (pacman) - download/install software packages

<br><br><span class="h">keyboard shortcuts</span><br>
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
