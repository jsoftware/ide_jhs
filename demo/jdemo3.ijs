coclass'jdemo3'
coinsert'jhs'
demo=: 'jdemo3.ijs'

B=:  0 : 0
jdemo jsep jide
'<h1>Flip with ajax args and results<h1>'
t1 t2   ^^
flip
-
openijs ^^
Ndesc  
)

BIS=: 0 : 0
t1      ht'some text';10
t2      ht'more text';10
flip    hb'flipem'    
jdemo    href'jdemo'
openijs hopenijs'Open script: ';(PATH,'demo/',demo);demo;''
)

create=: 3 : 0
hr 'jdemo3';(css'');(js JS);B getbody BIS
)

NB. NV_jhs_ has request name/value pairs
NB. getv'name' returns the value for a name
NB. seebox formats NV for viewing
NB. smoutput seebox NV can help debugging
ev_flip_click=: 3 : 0
NB. smoutput seebox NV
hrajax (8 u:|.7 u: getv't1'),ASEP,(8 u:|.7 u: getv't2')
)

jev_get=: create NB. browser get request

JS=: 0 : 0
// send t1 and t2 values to J handler
function ev_flip_click(){jdoh(["t1","t2"]);}

// response is string of delimited strings
function rqupdate()
{
 var t= rq.responseText.split(ASEP);
 if(2!=t.length) alert("wrong number of ajax results");
 jbyid("t1").value=t[0];
 jbyid("t2").value=t[1];
}
)

Ndesc=: 0 : 0
An ajax request sends only required data to the server.
This could be in any form, but the JHS framework has the
convention of sending the value data of html form elements
that have been listed in the jdoh argument. Hidden text
elements are useful for data that should not be visible to
the user.<br><br>

An ajax result can be any string of bytes. The JHS framework
convention is to send strings of data delimited by the byte
value ASEP.
)

