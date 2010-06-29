NB. jdemo app - gives access to demos
coclass'jdemo'
coinsert'jhs'
demo=: 'jdemo.ijs'

NB. html body template
NB. ids (tokens) replaced by BIS values 
NB. ^ token is <br>
B=:  0 : 0
jide
'<h1>JHS demos</h1>'
jdemo1  ^^
jdemo2  ^^
jdemo3  ^^
jdemo4  ^^
jdemo5  ^^
jdemo6  ^^
jdemo7  ^^
jdemo8  ^^
openijs ^^
Ndesc
)

BIS=: 0 : 0 NB. body id/sentence pairs
jdemo1  ' Roll submit'    ,~href'jdemo1'
jdemo2  ' Roll ajax'      ,~href'jdemo2'
jdemo3  ' Flip ajax'      ,~href'jdemo3'
jdemo4  ' Controls/JS/CSS',~href'jdemo4'
jdemo5  ' Plot'           ,~href'jdemo5'
jdemo6  ' Grid editor'    ,~href'jdemo6'
jdemo7  ' Table layout'   ,~href'jdemo7'
jdemo8  ' Dynamic resize' ,~href'jdemo8'
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
hr 'jdemo';(css'');(js'');B getbody BIS
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

B=: 0 : 0
 page layout in ids
 ids from ;: (J word formation)
  'abc' adds abc to html body
  Nabc  adds noun Nabc
  Vabc  adds result of Vabc''
  id    adds result of id sentence from BIS,BISCORE
&#41;
 
BIS=: ... NB. id/sentence pairs for B ids
CSS=: ... NB. styles
JS=:  ... NB. javascript (event handlers)

NB. BISCORE_jhs_ - framework id/sentence pairs
NB. CSSCORE_jhs_ - framework css
NB. JSCORE_jhs_  - framework js

create=: 3 : 0 NB. create page and send to browser
 ...
 hr title;styles,javascript,B getbody BIS
&#41;

jev_get=: create NB. browser get request

NB. event handlers
...
</div>
)