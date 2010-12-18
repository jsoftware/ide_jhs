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

gfassert=: 4 : 0
('will not get file',x)assert y
)

NB. y is file - x is content-type
gsrcf=: 4 : 0
y gfassert-.'/'e.y
d=. 1!:1<jpath '~addons/ide/jhs/src/',y
htmlresponse d,~gsrchead rplc '<TYPE>';x;'<LENGTH>';":#d
)

jev_get=: 3 : 0
smoutput'get: ',y
y=. jpath y
t=. jpath'~addons/docs/help/'
if. y-:'favicon.ico' do.
 favicon 0 
elseif. '.js'-:_3{.y do.
 'application/x-javascript'gsrcf y
elseif. '.htc'-:_4{.y do.
 'text/x-component'gsrcf y
elseif. '.swf'-:_4{.y do.
 'application/x-shockwave-flash'gsrcf y
elseif. '.htm'-:_4{.y do.
 y gfassert t-:(#t){.y 
 htmlresponse fread y
elseif. '.css'-:_4{.y do.
smoutput 'get css file: ',y
 y gfassert t-:(#t){.y 
 d=. fread y
 htmlresponse d,~gsrchead rplc '<TYPE>';'text/css';'<LENGTH>';":#d
elseif. '.jpg'-:_4{.y do.
 y gfassert t-:(#t){.y 
 d=. fread y
 htmlresponse d,~gsrchead rplc '<TYPE>';'image/jpeg';'<LENGTH>';":#d
elseif. 1 do.
 smoutput 'will not get file ',y
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

