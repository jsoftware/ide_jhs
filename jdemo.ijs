NB. jdemo app - gives access to demos
coclass'jdemo'
coinsert'jhs'
demo=: 'jdemo.ijs'

NB. html document body built from HBS sentences
HBS=: 0 : 0
jhma''
 'demo'     jhmg'demo';1;12
  'jdemo1'  jhml'Roll submit'
  'jdemo2'  jhml'Roll ajax'
  'jdemo3'  jhml'Flip ajax'
  'jdemo4'  jhml'Controls/JS/CSS'
  'jdemo5'  jhml'Plot'
  'jdemo6'  jhml'Grid editor'
  'jdemo7'  jhml'Table layout'
  'jdemo8'  jhml'Dynamic resize'
 jhjmlink''
jhmz''
jhh1'JHS demos'
'Select demo from demo menu.'
desc
jhdemo''
)

jev_get=: create NB. browser get request

NB. create page and send to browser
NB. response is built from globals CSS JS and HBS
create=: 3 : 0 NB. create page and send to browser
loadall'' NB. ensure demos are loaded
'jdemo'jhr''
)

desc=: 0 : 0
<br/>Demos are simple examples of JHS GUI programming.
Study them to learn how to build your own app.<br><br>

JHS combines J with the power of html, css (styles),
javascript, and the ubiquity of the browser.
J programmers can ride the coattails of www
infrastructure and standards.<br><br>

Apps are built on the JHS framework (locale jhs).<br><br>

Apps have the following general structure.<br>

<div class="jcode">
coclass'appname'
coinsert'jhs'

HBS=: ... NB. J sentences that produce html body
CSS=: ... NB. styles
JS=:  ... NB. javascript (event handlers)

NB. CSSCORE_jhs_ - framework css
NB. JSCORE_jhs_  - framework js

jev_get=: create NB. browser get request

create=: 3 : 0 NB. create page and send to browser
 ...
 'title'jhr ...'IDS';values for body...
 ...
</div>
)

loadall=: 3 : 0
load PATH,'demo/jdemo1.ijs'
load PATH,'demo/jdemo2.ijs'
load PATH,'demo/jdemo3.ijs'
load PATH,'demo/jdemo4.ijs'
load PATH,'demo/jdemo5.ijs'
load PATH,'demo/jdemo6.ijs'
load PATH,'demo/jdemo7.ijs'
load PATH,'demo/jdemo8.ijs'
)
