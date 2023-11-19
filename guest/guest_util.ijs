NB. utils for JHS guest server

man=: 0 : 0
   default'' NB. set default args
   seeargs''
   setarg 'guests';10
   seeargs''
   getargs''
   start getargs''[lan''
   start getargs''[aws''

   ports'' NB. ports in use

   data=: get''
   heads,'type guest'sel data

$ node inspect localhost:9229
)

NB. start of log utils
heads=: ;:'ts type port ip count wait bad'

get=: 3 : 0
t=. <;.2 rawlog''
b=. (<'jhs ')=4{.each t
echo ;(-.b)#t
t=. deb each }.b#t
t=. <;._1 each ' ',each t
c=. >./;#each t
t=. ":each 8{."1 >c{.each t
t=. }."1 t
i=. <a:;getcol'bad'
q=. i{t
c=. 23 <. each #each q
q=. c{.each q
t=. q i}t
i=. <a:;getcol'ts'
q=. i{t
t=. (gts each 0".each q) i}t
)

getcol=: 3 : 'heads i.<y'

NB. sel data;'type';'guest'
sel=: 4 : 0
'col val'=: ;:x
b=. (<val)=(getcol col){"1 y
b#data
)

gts=: 3 : 0
t=. efs_jd_ '1970-01-01'
', t'sfe_jd_ t+1000000*y-5*60*60*1000
)

NB. end of log utils

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
A2_key      =: '' 
A3_flags    =: '--inspect'
A4_server   =: '/jguest/j/addons/ide/jhs/guest/guest'
A5_guests   =: 3
A6_limit    =: 60*60
A7_maxage   =: 1*60
A8_idle     =: 20*60
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

NB. startlan key
startlan=: 3 : 0
shell_jtask_'sudo git/addons/ide/jhs/guest/setup-sh j9.4'
start (<y) 2}getargs''[lan''
)

NB. startaws key
startaws=: 3 : 0
shell_jtask_'sudo git/addons/ide/jhs/guest/setup-sh j9.4'
start (<y) 2}getargs''[aws''
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
'idle<:limit'assert idle<:limit
 
shell_jtask_'echo `which node` > nodebin'

NB. verify setup-sh has been run to create /jguest folder
'/jguest/j j install folder does not exist'assert 2=ftype'/jguest/j'
'/jquest/j/jcert' assert 1=ftype'/jguest/jcert'
'/jguest/j/jkey'  assert 1=ftype'/jguest/jkey'

PORTS=: nodeport,jhsport,jhsport+i.guests
shell_jtask_ :: [ 'sudo fuser --kill -n tcp ',":PORTS

arg=. (":nodeport),' ',key,' ',(":jhsport),' "unused" "unused" ',(":guests),' ',(":limit),' ',(":maxage),' ',(":idle)
echo arg
bin=. LF-.~fread'nodebin'

shell_jtask_ 'sudo echo "',(":limit,maxage,idle),'" | sudo tee /jguest/args' NB. menu>tool>guest

t=. '"<BIN>" "<FLAGS>" "<SERVER>" <ARG> > "<OUT>" 2>&1' 
a=. t rplc '<BIN>';bin;'<FLAGS>';flags;'<SERVER>';server;'<ARG>';arg;'<OUT>';nodeout
echo a
lastlog=: ''
fork_jtask_ a
)
