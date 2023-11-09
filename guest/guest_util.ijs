NB. utils for JHS guest server

man=: 0 : 0
   default'' NB. set default args
   seeargs''
   setarg 'guests';10
   seeargs''
   getargs''
   start getargs''[lan''
   start getargs''[aws''
)

reload=: 3 : 'load ''/jguest/j/addons/ide/jhs/guest/guest_util.ijs'''

nodeout=: 'guest.log'

rawlog=: 3 : 'fread nodeout'

newlog=: 3 : 0
t=. lastlog
lastlog=: rawlog''
(#t)}.lastlog
)

ports=: 3 : 0
shell_jtask_ :: [ 'sudo fuser -n tcp ',(":PORTS),' >t.txt 2>&1'
fread't.txt'
)

default=: 3 : 0
erase'A'nl 0
A0_nodeport =: 65101
A1_jhsport  =: 65001
A2_key      =: 'frown' 
A3_flags    =: '--inspect'
A4_server   =: '/jguest/j/addons/ide/jhs/guest/guest'
A5_guests   =: 3
A6_limit    =: 60
A7_maxage   =: 120
A8_idle     =: 10
i.0 0
)

seeargs=: 3 : 0
n=. 'A'nl 0
n,.".each n
)

setarg=: 3 : 0
'name val'=: y
n=. 'A'nl 0
i=. (3}.each n)i.<name
'invalid name'assert i<#n
('A',(":i),'_',name)=: val
i.0 0
)

getargs=: 3 : 0
".each 'A'nl 0
)

lan=: 3 : 0
default''
seeargs''
)

aws=: 3 : 0
default''
setarg'guests';10
setarg'limit' ;60*60
setarg'maxage';70*60
setarg'idle'  ; 5*60
seeargs''
)

start=: 3 : 0
startNODE y
6!:3[1
rawlog''
)

NB. guest version of startNODE_jhs_
NB. nodeport is https port served by node
NB. jhsport is jhs user port
NB. jhsport+1+i.guests are jhs guest ports
startNODE=: 3 : 0
'not from JHS'assert -.IFJHS
'nodeport jhsport key flags server guests limit maxage idle'=. y
'nodeport must be 65101 for local firewall access'assert nodeport-:65101
'maxage>limit'assert maxage>limit
'idle<:limit'assert idle<:limit
 
shell_jtask_'echo `which node` > nodebin'

NB. verify setup-sh has been run to create /jguest folder
'/jguest/j j install folder does not exist'assert 2=ftype'/jguest/j'
'/jquest/j/jcert' assert 1=ftype'/jguest/jcert'
'/jguest/j/jkey'  assert 1=ftype'/jguest/jkey'

PORTS=: nodeport,jhsport+i.guests
shell_jtask_ :: [ 'sudo fuser --kill -n tcp ',":PORTS

arg=. (":nodeport),' ',key,' ',(":jhsport),' "unused" "unused" ',(":guests),' ',(":limit),' ',(":maxage),' ',(":idle)
echo arg
bin=. LF-.~fread'nodebin'

t=. '"<BIN>" "<FLAGS>" "<SERVER>" <ARG> > "<OUT>" 2>&1' 
a=. t rplc '<BIN>';bin;'<FLAGS>';flags;'<SERVER>';server;'<ARG>';arg;'<OUT>';nodeout
echo a
lastlog=: ''
fork_jtask_ a
)
