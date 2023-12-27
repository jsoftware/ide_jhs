NB. utils for JHS guest server

man=: 0 : 0
   default'' NB. set default args
   seeargs''
   setarg 'guests';10
   seeargs''
   getargs''

   start'frown' NB. does create_guest to refresh /jguest from base install
NB.browse: https://localhost.or.aws:65101/jguest

   ports''     NB. ports in use

   rawlog''    NB. show rawlog
   seelog''    NB. get filtered formated log
   filters     NB. heads count refused wait 
   seelog 1 0 0 0 NB. heads, all records, do not remove refused or wait

$ node inspect localhost:9229

users can't read read files of other users
)

NB.! 'should be run from /jguest/j install' assert '/jguest/j'-:jpath'~install'

require'~addons/data/jd/base/util_epoch_901.ijs' NB. sfe convert javascript ts to string

NB. start of log utils

logfolder=:  jpath'~temp/guest/'
nodeout=:    logfolder,'/guest.log'

NB. rename old guest.log as guest_n.log before starting new one
logroll=: 3 : 0
mkdir_j_ logfolder
if. fexist nodeout do. NB. save last log before a new one is started
 d=. ,.(_4)}.each(6+#logfolder)}.each 1 dir logfolder
 d=. _4{.!.'0' ":>:>./0,;0".each d
 (logfolder,'guest_',d,'.log')frename nodeout
end. 
)

rawlog=: 3 : 'fread nodeout'

NB. LOG set from current log or rolled log
getlog=: 3 : 0
if. ''-:y do.
 t=. fread nodeout NB. current log
else. 
 'need to read a rolled log'
end.
t=. <;.2 t
b=. (<'jhs ')=4{.each t
echo ;(-.b)#t
t=. deb each b#t
t=. <;._1 each ' ',each t
c=. >./;#each t
t=. ":each 9{."1 >c{.each t
t=. }."1 t
i=. <a:;getndx'xtra'
q=. i{t
c=. 23 <. each #each q
q=. c{.each q
t=. q i}t
i=. <a:;getndx'ts'
q=. i{t
t=. (gts each 0".each q) i}t
LOG=: t
i.0 0
)

filters=: 1 20 1 1 NB. heads number refused wait

heads=: ;:'ts type port snum ip count wait xtra'

seelog=: 3 : 0
'head count refused wait'=: ;(y-:''){y;filters
t=. LOG
if. refused do. t=. ((1{"1 t)~:<'refused')#t end.
if. wait    do. t=. ((1{"1 t)~:<'wait'   )#t end.
if. count>0 do. t=. (0>.count-~#t)}.t end.
if. head    do. t=. heads,t end.
)

seesummary=: 3 : 0
d=. seelog 0 0 0 0
r=. 0 2$''
r=. r,'jhs records';#LOG
r=. r,'max snum';maxval 'snum'
r=. r,'max guest port';>./A0_nodeport-.~;0".each getcol'port'
r=. r,'limit'; 'type limit'sel LOG
r=. r,'idle' ; 'type idle'sel LOG
)

maxval=: 3 : 0
>./;0".each getcol y
)

getndx=: 3 : 'heads i.<y'

getcol=: 3 : 0
(getndx y){"1 LOG
)

NB. sel data;'type';'guest'
sel=: 4 : 0
'col val'=: ;:x
b=. (<val)=getcol col
b#y
)

gts=: 3 : 0
t=. efs_jd_ '1970-01-01'
', t'sfe_jd_ t+1000000*y-5*60*60*1000
)

NB. end of log utils

reload=: 3 : 'load ''/jguest/j/addons/ide/jhs/guest/guest_util.ijs'''

ports=: 3 : 0
shell_jtask_ :: [ 'sudo fuser -n tcp ',(":getports''),' >t.txt 2>&1'
fread't.txt'
)

default=: 3 : 0
erase'A'nl 0
A0_nodeport =: 65101
A1_jhsport  =: 65001
A2_key      =: '' 
A3_flags    =: '--inspect'
A4_server   =: '/jguest/j/addons/ide/jhs/guest/guest'
A5_guests   =: 10
A6_limit    =: 2*60*60
A7_maxage   =: 1*60
A8_idle     =: 20*60
A9_prlimit =: '"prlimit --cpu=240 --nofile=1000 --fsize=1000000000"'
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
setarg'maxage'; 1*60
setarg'idle'  ;20*60
seeargs''
)

create_jguest=: 3 : 0
t=. jpath '~addons/ide/jhs/guest/setup-sh'
shell_jtask_'sudo ',t,' j9.4'
)

NB. start node guest server
start=: 3 : 0
create_jguest''
if. ''-:getargs'' do. default'' end.
a=. (<y) 2}getargs''
startNODE a
6!:3[1
rawlog''
)

NB. stop node guest server
stop=: 3 : 0
shell_jtask_ :: [ 'sudo fuser --kill -n tcp ',":getports''
)

getports=: 3 : 0
A0_nodeport,A1_jhsport,A1_jhsport+1+i.A5_guests
)

NB. guest version of startNODE_jhs_
NB. nodeport is https port served by node
NB. jhsport is jhs user port
NB. jhsport+1+i.guests are jhs guest ports
startNODE=: 3 : 0
'not from JHS'assert -.IFJHS
'nodeport jhsport key flags server guests limit maxage idle prlimit'=. y
'nodeport must be 65101 for local firewall access'assert nodeport-:65101
'key must be at least 5 chars'assert 4<#key
'idle<:limit'assert idle<:limit
 
shell_jtask_'echo `which node` > nodebin'

NB. verify setup-sh has been run to create /jguest folder
'/jguest/j j install folder does not exist'assert 2=ftype'/jguest/j'
'/jquest/j/jcert' assert 1=ftype'/jguest/jcert'
'/jguest/j/jkey'  assert 1=ftype'/jguest/jkey'

shell_jtask_ :: [ 'sudo fuser --kill -n tcp ',":getports''

arg=. (":nodeport),' ',key,' ',(":jhsport),' "unused" "unused" ',(":guests),' ',(":limit),' ',(":maxage),' ',(":idle),' ',prlimit
echo arg
bin=. LF-.~fread'nodebin'

shell_jtask_ 'sudo echo "',(":limit,maxage,idle),'" | sudo tee /jguest/args' NB. menu>tool>guest

t=. '"<BIN>" "<FLAGS>" "<SERVER>" <ARG> > "<OUT>" 2>&1' 
a=. t rplc '<BIN>';bin;'<FLAGS>';flags;'<SERVER>';server;'<ARG>';arg;'<OUT>';nodeout
a=. 'nohup ',a,' &' NB. critical!
echo a
lastlog=: ''
logroll'' NB. start new guest.log - rename old one if necessary
shell_jtask_ a
)
