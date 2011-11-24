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

gsrcf=: 4 : 0
htmlresponse y,~gsrchead rplc '<TYPE>';x;'<LENGTH>';":#y
)

NB. serves .htm .js etc pages from anywhere
NB. possible security issues! careful on allowing other suffixes!
NB. ~root kludge to read gnuplot js files from /usr/share/gnuplot/gnuplot/4.4/js/
jev_get=: 3 : 0
if. y-:'favicon.ico' do. favicon 0 return. end.
y=. jpath(5*'~root/'-:6{.y)}.y
d=. fread y
if. ('.htm'-:_4{.y)+.'.html'-:_5{.y do. htmlresponse d return. end.
if. '.js'-:_3{.y do.
 t=. 'application/x-javascript'
elseif. '.css'-:_4{.y do.
 t=. 'text/css'
elseif. '.jpg'-:_4{.y do.
 t=. 'image/jpeg'
elseif. '.gif'-:_4{.y do.
 t=. 'image/gif'
elseif. '.png'-:_4{.y do.
 t=. 'image/png'
elseif. 1 do. smoutput 'will not get file ',y return. end.
t gsrcf d
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

