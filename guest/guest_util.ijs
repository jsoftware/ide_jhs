
NB. utils for JHS guest server

nodeout=: 'guest.log'

rawlog=: 3 : 'fread nodeout'

newlog=: 3 : 0
t=. lastlog
lastlog=: rawlog''
(#t)}.lastlog
)

reload=: 3 : 'load ''/jguest/j/addons/ide/jhs/guest/guest_util.ijs'''

ports=: 3 : 0
shell_jtask_ :: [ 'sudo fuser -n tcp ',(":PORTS),' >t.txt 2>&1'
fread't.txt'
)

start=: 3 : 0
load'~addons/ide/jhs/node.ijs' NB. startJHS
startJHS_jhs_''
startNODE y
6!:3[1
rawlog''
)

NB. asssume /jguest/j soft link to j install
server=:   '/jguest/j/addons/ide/jhs/guest/guest'

NB.        node  ; jhs   ; userkey  ; flags      ; guest.js ; guests ; limit ; maxage ; idle
nodeargs=: 65101 ; 65001 ; 'frown'  ; '--inspect'; server   ; 3      ; 60    ; 120    ; 30

NB. guest version of startNODE_jhs_
NB. nodeport is https port served by node
NB. jhsport is jhs user port
NB. jhsport+i.guests are jhs guest ports

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
if. _1=pidfromport_jport_ nodeport do. NB. pidfromport has delays
 echo a,LF,rawlog''
 'NODE server failed to start' assert 0
end. 
)
