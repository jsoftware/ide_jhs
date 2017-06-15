NB. jjhs client code

0 : 0
verbs used on the client

sentence jhsdo  y
target   jhsget source
target   jhsput source

source/target must be 2 files or 2 folders
)

require'socket'
require'tar'

jhsdo=:     jhsdo_jjhs_
jhsget=:    jhsget_jjhs_
jhsput=:    jhsput_jjhs_

coclass'jjhs'

PASS=: ''
SERVER=: 'localhost:65001'
URL=: 'jjhsserver'
TAR=: '~temp/jtoj.tar'

posttemplate=: _2}.toCRLF 0 : 0
POST /<URL> HTTP/1.1 
Connection: Keep-Alive
Content-Length: <COUNT>

<DATA>
)

jhsdo=: 4 : 0
data=. PASS,({.a.),x,({.a.),3!:1 y
i=. SERVER i. ':'
port=. 0".}.i}.SERVER
server=. i{.SERVER
ip=. >2{sdgethostbyname_jsocket_ server

try.
 sk=. >0{sdcheck_jsocket_ sdsocket_jsocket_''
 sdcheck_jsocket_ sdconnect_jsocket_ sk;AF_INET_jsocket_;ip;port
 t=. posttemplate rplc '<URL>';URL;'<DATA>';data;'<COUNT>';":#data
 while. #t do. t=.(>sdcheck_jsocket_ t sdsend_jsocket_ sk,0)}.t end.
 h=. d=. ''
 cl=. 0
 while. (0=#h)+.cl>#d do. NB. read until we have header and all data
  z=. sdselect_jsocket_ sk;'';'';5000
  assert sk e.>1{z NB. timeout
  'c r'=. sdrecv_jsocket_ sk,10000,0
  assert 0=c

  if. (0=#r)*.cl=_ do. break. end. NB. no length and no more data

  d=. d,r
  if. 0=#h do. NB. get headers
   i=. (d E.~ CRLF,CRLF)i.1 NB. headers CRLF delimited with CRLF at end
   if. i<#d do. NB. have headers
    i=. 4+i
    h=. i{.d NB. headers
    d=. i}.d
    i=. ('Content-Length:'E. h)i.1

    if. i<#h do.
     t=. (15+i)}.h
     t=. (t i.CR){.t
     cl=. _1".t
     assert _1~:cl
    else.
     cl=. _
    end.
   end.
  end.
 end.
catch.
 sdclose_jsocket_ sk
 (13!:12'') assert 0
end.
sdclose_jsocket_ sk

if. '|'={.d do. d assert 0 end. NB. error - plain text starting with |
3!:2 d
)

NB. source is there and we are getting it here
jhsget=: 4 : 0
target=. x [ source=. y
select. ftype source
case. 1 do.
 d=. 'fread y' jhsdo source
 mkdir_j_ (target i: '/'){.target NB. ensure path
 'write to target failed'assert (#d)=d fwrite target
case. 2 do.
 'tar y'jhsdo 'c';TAR;source;''
 d=. 'fread y' jhsdo TAR
 d fwrite TAR
 mkdir_j_ target
 tar 'x';TAR;target
case. do.
 'source is not a file or folder'assert 0
end. 
)

NB. source is here and we are putting it there
jhsput=: 4 : 0
target=. x [ source=. y
select. ftype source
case. 1 do.
 d=. fread source
 'mkdir_j_ y' jhsdo (target i: '/'){.target NB. ensure path
 ('y fwrite ''',target,'''') jhsdo d
case. 2 do.
 tar 'c';TAR;source;''
 '(>{.y) fwrite {:y' jhsdo TAR;fread TAR
 'tar y' jhsdo 'x';TAR;target
case. do.
 'source is not a file or folder'assert 0
end. 
)
