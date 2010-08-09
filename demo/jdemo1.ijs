coclass'jdemo1'
coinsert'jhs'
demo=: 'jdemo1.ijs'

B=:  0 : 0
jdemo
'<h1>Roll with submit<h1>'
roll result
-
openijs     ^^
Ndesc
)

BIS=: 0 : 0
jdemo   href'jdemo'
result  '<span>&nbsp;<RESULT></div>'
roll    hb'rollem'
openijs hopenijs'Open script: ';(PATH,'demo/',demo);demo;''
)

create=: 3 : 0 NB. create - y replaces <RESULT> in body
hr 'jdemo1';(css'');(js'');(B getbody BIS) hrplc'RESULT';y
)

NB. runs when default javascript action submits page
ev_roll_click=: 3 : 0 NB. roll button event handler
create >:6?49 NB. post data value from name value pair 
)

jev_get=: create

Ndesc=: 0 : 0
Pressing rollem button calls ev_roll_click J handler.
The handler creates a new page and sends it to the browser.<br><br>

The browser sends all form data with the submit request
to the server. The server creates a complete new page and
sends it to the browser. There is no form data in this example
and the page is small so there is not much data sloshing.
But in a real app it could be lots and the app would be sluggish,
especially over a network.<br><br>

If your browser has a request progress bar, note how it indicates
the transmission of the request and the new page result. 
)

