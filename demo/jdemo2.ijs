coclass'jdemo2'
coinsert'jhs'
demo=: 'jdemo2.ijs'

B=:  0 : 0
jdemo
'<h1>Roll with ajax<h1>'
roll result
-
openijs ^^
Ndesc  
)

BIS=: 0 : 0
jdemo   href 'jdemo'
result  '&nbsp;<span id="result"></span>'
roll    hb'rollem'
openijs hopenijs'Open script: ';(PATH,'demo/',demo);demo;''
)

create=: 3 : 0
hr 'jdemo2';(css'');(js JS);B getbody BIS
)

rollem=: 3 : '":>:6?49'

ev_roll_click=: 3 : 'hrajax rollem 0' NB. ajax event handler

jev_get=: create

JS=: 0 : 0
// event handler - nothing extra sent with ajax request 
function ev_roll_click(){jdoh([]);}

// innerHTML gives element new html contents
function rqupdate(){ jbyid("result").innerHTML= rq.responseText;}
)

Ndesc=: 0 : 0
Ajax stands for 'asynchronous javascript and xml'.<br><br>

An app transaction without ajax waits for all the form
data to be transmitted to the server, waits for the server
to format an entire new page, waits for the new page to be
transmitted to the browser, and waits for the browser to
format and display the page. In a complicated app
this can be a great deal of data sloshing and unnecessary
processing. Non-trivial apps that use submit are sluggish
compared to desktop apps.<br><br>

An ajax app transaction sends only required data to the
server, gets back only required data, and updates
the page dynamically in place affecting only the parts
of the display that have changed. With reasonably fast
transmission ajax apps can rival desktop apps.<br><br>

If your browser has a request progress bar, note that it
does not indicate an ajax transaction.
)

