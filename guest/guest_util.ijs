
NB. utils for JHS guest server

nodeout=: '~temp/jhsnode/node.log'

rawlog=: 3 : 'fread nodeout'

lastlog=: ''

newlog=: 3 : 0
t=. lastlog
lastlog=: rawlog''
(#t)}.lastlog
)

reload=: 3 : 'load ''~addons/ide/jhs/guest/guest_util.ijs'''

guest_base=: 65002
guest_count=: 3
guest_ports=: guest_base+i.guest_count

start=: 3 : 0
shell_jtask_ :: [ 'sudo fuser --kill -n tcp ',":guest_ports
shell_jtask_'rm jc ; ln -s j9.4/bin/jconsole jc'
shell_jtask_'echo `which node` > nodebin'
load'~addons/ide/jhs/node.ijs' NB. startJHS
startJHS_jhs_''

startNODE y
6!:3[1
lastlog=: 0
rawlog''
)

NB. asssume /jguest/j soft link to j install
path_server=:   '/jguest/j/addons/ide/jhs/guest/guest'

NB.        node  ;    ; userkey  ; flags      ; guest.js    ; guests ; limit ; maxage
nodeargs=: 65101 ; '' ; 'frown'  ; '--inspect'; path_server ; 3      ; 300    ; 60

NB. guest version of startNODE_jhs_
startNODE=: 3 : 0
'not from JHS'assert -.IFJHS

NB. verify setup-sh has been run to create /jguest folder
'/jguest/j j install folder does not exist'assert 2=ftype'/jguest/j'
'/jquest/j/jcert' assert 1=ftype'/jguest/jcert'
'/jguest/j/jkey'  assert 1=ftype'/jguest/jkey'

'nodeport pem key flags server guests limit maxage'=. y
'nodeport must be 65101'assert nodeport-:65101
mkdir_j_ '~temp/jhsnode'
nodeout=: jpath'~temp/jhsnode/node.log'
killport_jport_ nodeport
port=. nodeport-100

NB. breakfile needs pid from the JHS server
breakfile=. (jpath '~break/'),(":pidfromport_jport_ port),'.node'

pem=. ;(pem-:''){pem;jpath'~addons/ide/jhs/node'

arg=. (":nodeport),' ',key,' ',(":port),' "',breakfile,'" "',pem,'"',' ',(":guests),' ',(":limit),' ',(":maxage)
echo arg
bin=. LF-.~fread'nodebin'

t=. '"<BIN>" "<FLAGS>" "<SERVER>" <ARG> > "<OUT>" 2>&1' 
a=. t rplc '<BIN>';bin;'<FLAGS>';flags;'<SERVER>';server;'<ARG>';arg;'<OUT>';nodeout
echo a
fork_jtask_ a
if. _1=pidfromport_jport_ nodeport do. NB. pidfromport has delays
 echo a,LF,fread nodeout
 'NODE server failed to start' assert 0
end. 
)
