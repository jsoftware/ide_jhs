NB. utils for JHS guest server

load'~addons/ide/jhs/aws/aws-utils.ijs' NB. define create_swap_jaws_
create_swap=: create_swap_jaws_

man=: 0 : 0
   default'' NB. set default args
   seeargs''
   setarg 'guests';10

   start'frown' NB. does create_guest to refresh /jguest from base install
NB.browse: https://localhost.or.aws-server:65101/jguest

   ports''     NB. ports in use
   rawlog''    NB. show rawlog
   getlog''    NB. LOG=: from rawlog
   getlog ...  NB. LOG=: ... 
   seelog n    NB. see last n LOG rows

users can't read read files of other users
)

require'~addons/data/jd/base/util_epoch_901.ijs' NB. sfe convert javascript ts to string

NB. cpu loop for y seconds
jhsspin=: 3 : 0
n=. y
s=. 6!:1''
while. n>s-~6!:1'' do. end.
i.0 0
)

NB. hardwired ports - a small bit of work required to change
NODEP=: 65101
JHSP=:  65001

NB. start of log utils

3 : 0''
if. _1=nc<'LOG' do. LOG=: '' end.
)

logfolder=:  jpath'~temp/guest/'
nodeout=:    logfolder,'/guest.log'
dumps=: '/var/lib/systemd/coredump/'

NB. rename old guest.log as guest_n.log before starting new one
logroll=: 3 : 0
mkdir_j_ logfolder
if. fexist nodeout do. NB. save last log before a new one is started
 d=. ,.(_4)}.each(6+#logfolder)}.each 1 dir logfolder
 d=. _4{.!.'0' ":>:>./0,;0".each d
 (logfolder,'guest_',d,'.log')frename nodeout
end. 
)

rawlog=: 3 : 0
t=. fread nodeout
)

NB. LOG set from current log or arg
getlog=: 3 : 0
t=. ;(''-:y){y;rawlog''
t=. t,(LF~:{:t)#LF
t=. <;.2 t
b=. (<'jhs ')=4{.each t
nonjhs=: ;(-.b)#t
t=. deb each b#t
t=. <;._1 each ' ',each t
c=. >./;#each t
t=. ":each 9{."1 >c{.each t
t=. }."1 t

NB. truncate url
i=. <a:;getndx'url'
q=. i{t
c=. 15 <. each #each q
q=. c{.each q
t=. q i}t

NB. truncate xtra
i=. <a:;getndx'xtra'
q=. i{t
c=. 23 <. each #each q
q=. c{.each q
t=. q i}t
i=. <a:;getndx'ts'
q=. i{t
t=. (gts each 0".each q) i}t
LOG=: t
)

heads=: ;:'ts type port snum ip count url xtra'

NB. headers and last y LOG rows
replog=: 3 : 0
y=. ;(''-:y){y;20
getlog''
heads,(-y<.#LOG){.LOG
)

NB. get count of rows for type y
getcount=: 3 : 0
c=. ;0".each(getndx 'count'){"1 ('type ',y)sel LOG
)

rep=: 3 : 0
getlog''
r=. 0 2$''
r=. r,|.2{.{.LOG
r=. r,'records';#LOG
r=. r,'nonjhs';+/LF=nonjhs
r=. r,'dumps';#1 dir dumps
r=. r,'#~.ips';<.#~.getcol'ip'
r=. r,'max port';>./}.;0".each getcol'port'
t=.   (getndx'type'){"1 LOG
c=. +/"1 =t
r=. r,(~.t),.<"0 c

c=. (getcount'idle'),(getcount'limit'),getcount'403'
c=. (c>2)#c NB. ignore sessions with too few inputs
c=. \:~c
if. #c do.
 r=. r,'inputs';+/c
 r=. r,'inputs max';{.c
 r=. r,'inputs mean';(<.2%~#c){c
end.
r
)

repsnum=: 3 : 0
getlog''
(y=;_1".each(getndx'snum'){"1 LOG)#LOG
)

repspace=: 3 : 0
t=. shell_jtask_ 'sudo du -s /home/p*'
a=. <;._2 t rplc LF;TAB
(2,~-:#a)$a
)

repmem=: 3 : 0
shell_jtask_'free'
)

repcount=: 3 : 0
snum=. getcol'snum'
t=. snum i: ~.snum-.(,'+');,'0'
t{LOG
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

reload=: 3 : 0
load'~home/j9.5/addons/ide/jhs/guest/guest_util.ijs'
)

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
A5_guests   =: 50
A6_limit    =: 2*60*60
A7_wait     =: 0 NB. seconds guest must wait before starting new session
A8_idle     =: 20*60
A9_prlimit =: '"prlimit --cpu=60 --nofile=1024 --fsize=1000000000 --as=4000000000"' NB. 4G lets pandas tut runj
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

NB. get args from last start
getsavedastartargs=: 3 : 0
".fread'nodestartargs'
)

create_jguest=: 3 : 0
echo shell_task_'sudo j9.5/addons/ide/jhs/guest/create-jguest-sh $USER ',jpath'~install'
)

repaccess=: 3 : 0
a=. <;._2 shell :: '' 'sudo ls /etc/letsencrypt/live'
a=. ;{.a-.<'README'
echo a

t=. shell_jtask_'dig +short myip.opendns.com @resolver1.opendns.com'
echo t
)

NB. start node guest server
start=: 3 : 0
create_jguest''
'/jguest folder was not created'assert 2=ftype'/jguest'
if. ''-:getargs'' do. default'' end.
'A0_nodeport must have hardwired value'assert NODEP=A0_nodeport
'A1_jhsport must have hardwired value'assert JHSP=A0_jhsport
startNODE (<y) 2}getargs''
6!:3[1
echo LF,rawlog''

t=. }:shell'dig +short myip.opendns.com @resolver1.opendns.com'
if. ''-:t do. t=. getlanip'' end.
echo 'https://',t,':65101/jguest'

)

NB. stop node guest server
stop=: 3 : 0
shell_jtask_ :: [ 'sudo fuser --kill -n tcp ',":getports''
)

getports=: 3 : 0
NODEP,JHSP,JHSP+>:i.#dir'/home/p*'
)

NB. guest version of startNODE_jhs_
NB. nodeport is https port served by node
NB. jhsport is jhs user port
NB. jhsport+1+i.guests are jhs guest ports
startNODE=: 3 : 0
argy=. y
'not from JHS'assert -.IFJHS
'nodeport jhsport key flags server guests limit maxwait idle prlimit'=. y
'nodeport must be 65101 for local firewall access'assert nodeport-:65101
'key must be at least 5 chars'assert 4<#key
'idle<:limit'assert idle<:limit
 
stop'' NB. kill node/user/guest tasks
bin=. }:shell_jtask_ :: '' 'which node'
'node binary not found'assert #bin
 (5!:5<'argy')fwrite'nodestartargs' NB. save the start args
shell_jtask_ 'sudo echo "',(":limit,maxwait,idle),'" | sudo tee /jguest/args' NB. menu>tool>guest

arg=. (":nodeport),' ',key,' ',(":jhsport),' "unused" "unused" ',(":guests),' ',(":limit),' ',(":maxwait),' ',(":idle),' ',prlimit
echo arg

t=. '"<BIN>" "<FLAGS>" "<SERVER>" <ARG> > "<OUT>" 2>&1' 
a=. t rplc '<BIN>';bin;'<FLAGS>';flags;'<SERVER>';server;'<ARG>';arg;'<OUT>';nodeout
a=. 'nohup ',a,' &' NB. critical!
echo a
logroll'' NB. start new guest.log - rename old one if necessary
shell_jtask_ a
)

NB. copied from JHS
getlanip=: 3 : 0
if. IFWIN do.
 r=. deb each<;._2 spawn_jtask_'ipconfig'
 r=. ((<'IPv4 Address')=12{.each r)#r
 r=. (>:;r i.each':')}.each r
else.
 r=. deb each <;._2[2!:0'ip address'
 r=. 5}.each((<'inet ')=5{.each r)#r
 r=. (r i. each '/'){.each r
end.
r=. deb each r
r=. deb each(r i.each' '){.each r
r=. r-.<'127.0.0.1'
'no lan ip' assert 0<#r
if. 1<#r do. echo 'multiple lan ips: ',LF,;LF,~each' ',each r end.
;{.r
)
