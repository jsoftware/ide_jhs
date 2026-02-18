NB. port utilties - used with Jd/JHS node server
NB. should probably be an addons - for now it can live here
NB. Jd currently loads this script

coclass'jport'

killport=: 3 : 0 
'must be single port'assert 1=#y
pid=: getpid y
if. _1~:pid do. 
 select. UNAME
  case. 'Win' do. shell_jtask_'taskkill /f /pid ',":pid
  case. do. shell_jtask_'kill ',":pid
 end.
end. 
i.0 0
)

osgetpid=: 3 : 0
if. UNAME-:'Win' do.
 d=. CR-.~each deb  each <;._2 shell'netstat -ano -p TCP | findstr LISTENING | findstr :',":y
 if. 0=#d do. _1 return. end.
 'port has more than 1 listener'assert 1=#d
 d=. ;d
 0". (d i:' ')}.d
else.
 d=. shell_jtask_ :: 0: 'lsof -P -n -F pfn -i TCP:',":y
 if. d-:0 do. _1 return. end.
 d=. <;._2 d
 if. 3=#d do. 0".}.;{.d return. end.
 i=. d i. <'n*:',":y
 0".}.;{(i-2){d
end. 
)

NB. may need waits to let new task spin up
getpid=: 3 : 0
for. i.10 do. NB. 1 second
 if. 0<d=. osgetpid y do. d return. end.
 6!:3[0.1
end.
_1
)
