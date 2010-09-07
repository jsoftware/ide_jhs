coclass'jdemo2'
coinsert'jhs'

HBS=: 0 : 0
jhh1'Roll with ajax'
'roll'   jhb'rollem'
'result' jhspan''
desc
jhdemo''
)

create=: 3 : 0
'jdemo2'jhr''
)

ev_roll_click=: 3 : 'jhrajax ":>:6?49'

jev_get=: create

desc=: 0 : 0
<br/>Ajax stands for 'asynchronous javascript and xml'.<br><br>

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
transmission ajax apps can rival desktop apps.
)

NB. javascript code - event handlers etc.
JS=: 0 : 0
// event handler - send ajax request to J
// ([]) indicates empty list argument is sent
function ev_roll_click(){jdoh([]);}

// framework calls with the jhrajax argument
// sets "result" element innerHTML with the 6 numbers
function ajax(ts){jbyid("result").innerHTML=ts[0];}
)
