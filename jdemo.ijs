NB. jdemo app - gives access to demos
coclass'jdemo'
coinsert'jhs'
demo=: 'jdemo.ijs'

NB. html document body built from HBS sentences
HBS=: 0 : 0
jhma''
 'demo'     jhmg'demo';1;12
  'jdemo1'  jhml'1 Roll submit'
  'jdemo2'  jhml'2 Roll ajax'
  'jdemo3'  jhml'3 Flip ajax'
  'jdemo4'  jhml'4 Controls/JS/CSS'
  'jdemo5'  jhml'5 Plot'
  'jdemo6'  jhml'6 Grid editor'
  'jdemo7'  jhml'7 Table layout'
  'jdemo8'  jhml'8 Dynamic resize'
  'jdemo9'  jhml'9 Multiple frames'
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
d=. (<'.ijs'),~each (<'jdemo'),each ":each >:i.9
d=. (<jpath'~addons/ide/jhs/demo/'),each d
failed=. loader d
if. 0~:#failed do. smoutput 'load failed: ',LF,failed end.
)
