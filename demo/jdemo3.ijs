coclass'jdemo3'
coinsert'jhs'

HBS=:  0 : 0
jhh1'Flip - ajax args and results'
'flip'   jhb'flipem'    
't1'     jht'some text';10
't2'     jht'more text';10
desc  
jhdemo''
)

create=: 3 : 0
'jdemo3'jhr''
)

NB. NV_jhs_ has request name/value pairs
NB. getv'name' returns the value for a name
NB. smoutput seebox NV can help debugging
NB. JASEP separates ajax results
ev_flip_click=: 3 : 0
smoutput seebox NV
jhrajax (8 u:|.7 u: getv't1'),JASEP,(8 u:|.7 u: getv't2')
)

jev_get=: create NB. browser get request

JS=: 0 : 0
// send t1 and t2 values to J handler
function ev_flip_click(){jdoh(["t1","t2"]);}

// response is string of delimited strings
// ts is list of string results
function ajax(ts)
{
 if(2!=ts.length) alert("wrong number of ajax results");
 jbyid("t1").value=jtfromh(ts[0]);
 jbyid("t2").value=jtfromh(ts[1]);
}
)

desc=: 0 : 0
<br/>An ajax request sends only required data to the server.
This could be in any form, but the JHS framework has the
convention of sending the value data of html form elements
that have been listed in the jdoh argument. Hidden text
elements are useful for data that should not be visible to
the user.<br><br>

An ajax result can be any string of bytes. The JHS framework
convention is to send strings of data delimited by the byte
value JASEP.
)

