NB. jdemo app - gives access to demos
coclass'jdemo'
coinsert'jhs'
demo=: 'jdemo.ijs'

NB. html body template
NB. tokens replaced by BIS values 
NB. jma starts menu
NB. jmz ends menu
NB. ^ token is <br>
NB. _ is <hr>
B=:  0 : 0
jma
 demo jdemo1 jdemo2 jdemo3 jdemo4 jdemo5 jdemo6 jdemo7 jdemo8
 jmlink
jmz
'<h1>JHS demos</h1>'
'Select demo from demo menu.'
-
openijs ^^
Ndesc
)

BIS=: 0 : 0 NB. body token/sentence pairs
demo    hmg'demo'
 jdemo1  hml'Roll submit';''
 jdemo2  hml'Roll ajax';''
 jdemo3  hml'Flip ajax';''
 jdemo4  hml'Controls/JS/CSS';''
 jdemo5  hml'Plot';''
 jdemo6  hml'Grid editor';''
 jdemo7  hml'Table layout';''
 jdemo8  hml'Dynamic resize';''
openijs hopenijs'Open script: ';(PATH,demo);demo;''
)

jev_get=: create NB. browser get request

NB. create page and send to browser
NB. page created from title;css styles;javascript;body
create=: 3 : 0 NB. create page and send to browser
load PATH,'demo/jdemo1.ijs'
load PATH,'demo/jdemo2.ijs'
load PATH,'demo/jdemo3.ijs'
load PATH,'demo/jdemo4.ijs'
load PATH,'demo/jdemo5.ijs'
load PATH,'demo/jdemo6.ijs'
load PATH,'demo/jdemo7.ijs'
load PATH,'demo/jdemo8.ijs'
hr 'jdemo';(css CSS);(js JS);B getbody BIS
)

Ndesc=: 0 : 0
Demos are simple examples of JHS GUI programming.
Study them to learn how to build your own app.<br><br>

JHS combines J with the power of html, css (styles),
javascript, and the ubiquity of the browser.
J programmers can ride the coattails of www
infrastructure and standards.<br><br>

Apps are built on the JHS framework (~addons/ide/jhs/core.ijs)
in the jhs locale.<br><br>

Apps have the following general structure.<br><br>

<div class="jcode">
coclass'appname'
coinsert'jhs'

NB. page layout in tokens (;: J word formation)
NB. 'abc' adds abc to html body
NB. Nabc  adds noun Nabc
NB. token adds result of token sentence from BIS,BISCORE
B=: ...

BIS=: ... NB. id/sentence pairs for B ids 
CSS=: ... NB. styles
JS=:  ... NB. javascript (event handlers)

NB. BISCORE_jhs_ - framework id/sentence pairs
NB. CSSCORE_jhs_ - framework css
NB. JSCORE_jhs_  - framework js

create=: 3 : 0 NB. create page and send to browser
 ...
 hr title;css,js,B getbody BIS
&#41;

jev_get=: create NB. browser get request
</div>
)

CSS=: 0 : 0
)

JS=: 0 : 0
// menu handlers and shortcuts
function ev_demo_click(){menuclick();}
function ev_jmlink_click(){menuclick();}

function doshortcut(c)
{
 switch(c)
 {
  default: dostdshortcut(c); break;
 }
}
)
