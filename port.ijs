NB. port utilties - used with Jd/JHS node server
NB. should probably be an addons - for now it can live here
NB. Jd currently loads this script

coclass'jport'

NB. kill pid - shell failure assumed to mean pid not valid
killport=: 3 : 0 "0
'must be single port'assert 1=#y
pid=: getpid y
if. _1~:pid do. 
 select. UNAME
  case. 'Win' do. shell :: ['taskkill /f /pid ',(":pid),' >null 2>&1'
  case. do. shell :: ['kill ',(":pid),' >null 2>&1'
 end.
end. 
i.0 0
)

NB. pid from port - no delay
getpid=: 3 : 0 "0
if. UNAME-:'Win' do.
 d=. CR-.~each deb  each <;._2 shell'netstat -ano -p TCP | findstr LISTENING | findstr :',":y
 if. 0=#d do. _1 return. end.
 'port has more than 1 listener'assert 1=#d
 d=. ;d
 0". (d i:' ')}.d
else.
 NB. lsof - find p line ahead of n*:port lline
 d=. shell_jtask_ :: 0: 'lsof -P -n -F p -s TCP:LISTEN -i TCP:',":y
 if. d-:0 do. _1 return. end.
 'unexpected lsof result'assert (LF={:d)*.'p'={.d
 0".}.}:d
end. 
)

NB. we expect port to become valid so wait for pid to show up
getpidx=: 3 : 0
for. i.10 do. NB. 1 second
 if. 0<d=. getpid y do. d return. end.
 6!:3[0.2
end.
_1
)
