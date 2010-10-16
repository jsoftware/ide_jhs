coclass'jdemo1'
coinsert'jhs'

NB. sentences to create html body
NB.   jhbshtml_jdemo1_'' NB. run to see the html
HBS=: 0 : 0
jhh1'Roll with submit'
'roll'   jhb'rollem'
'<RESULT>'
desc
jhdemo''
)

NB. create html page from globals HBS CSS JS
NB. this demo has no CSS (styles) or JS (javascript)
NB. HBS body can have TAGS that are replaced
create=: 3 : 0
'jdemo1'jhr'RESULT';y NB. y replaces <RESULT> in body
)

NB. called when browser gets this (jdemo1) page
jev_get=: create

NB. roll click event handler
NB. general framework javascript handler
NB. sees there is no specific javascript handler
NB. so submits (post) the form to run this verb
NB. 6 numbers replace <RESULT> in the result page
ev_roll_click=: 3 : 'create >:6?49'

desc=: 0 : 0
<br>Pressing rollem button calls ev_roll_click J handler.
The handler creates a new page and sends it to the browser.<br><br>

The browser sends all form data with the submit request
to the server. The server creates a complete new page and
sends it to the browser. There is no form data in this example
and the page is small so there is not much data sloshing.
But in a real app it could be lots and the app could be sluggish,
especially over a network.
)

JS=: 0 : 0
function ev_roll_click(){jsubmit();} // submits form - calls J ev_roll_click
)