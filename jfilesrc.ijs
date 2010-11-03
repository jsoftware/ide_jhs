NB. JHS - file source stuff - favicon.ico ...
coclass'jfilesrc'
coinsert'jhs'

gsrchead=: toCRLF 0 : 0
HTTP/1.1 200 OK
Server: JHS
Last-Modified: Mon, 01 Mar 2010 00:23:24 GMT
Accept-Ranges: bytes
Content-Length: <LENGTH>
Keep-Alive: timeout=15, max=100
Connection: Keep-Alive
Content-Type: <TYPE>

)

NB. y is file - x is content-type
gsrcf=: 4 : 0
d=. 1!:1<jpath '~addons/ide/jhs/src/',y
htmlresponse d,~gsrchead rplc '<TYPE>';x;'<LENGTH>';":#d
)

jev_getsrcfile=: 3 : 0
if. y-:'favicon.ico' do.
 favicon 0 
elseif. '.js'-:_3{.y do.
 'application/x-javascript'gsrcf y
elseif. '.css'-:_4{.y do.
 'text/css'gsrcf y
elseif. '.htc'-:_4{.y do.
 'text/x-component'gsrcf y
elseif. '.swf'-:_4{.y do.
 'application/x-shockwave-flash'gsrcf y
elseif. 1 do.
 smoutput 'do not get files of type: ',y
end. 
)

favicon=: 3 : 0
htmlresponse htmlfav,1!:1 <jpath'~bin\icons\favicon.ico'
)

htmlfav=: toCRLF 0 : 0
HTTP/1.1 200 OK
Server: J
Accept-Ranges: bytes
Content-Length: 1150
Keep-Alive: timeout=15, max=100
Connection: Keep-Alive
Content-Type: image/x-icon

)

