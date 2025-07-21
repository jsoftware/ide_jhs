NB. utils for JHS guest server

load'~addons/ide/jhs/aws/aws-utils.ijs' NB. define create_swap_jaws_
create_swap=: create_swap_jaws_
see=: seebox_jhs_

man=: 0 : 0
   default'' NB. set default args
   seeargs''
   setarg 'guests';10

   start'frown' NB. does create_guest to refresh /jguest from base install
NB.browse: https://localhost.or.aws-server:65101/jguest

   manlog NB. log utils
)

manlog=: 0 : 0
   ports''     NB. ports in use
   repmem''    NB. shell'free'
   repspace''  NB. du /home/p*
   logfolder   NB. folder for nodeout and geoout files
   nodeout     NB. log file used for reports - default is logfolder,'guest.log'
   geoout      NB. log file for geo ipdata - logfolder,'geo.txt'
   rawlog''    NB. fread nodeout
   getlog''    NB. LOG=: formatted from rawlog
   repget''    NB. getlog'' and geoupdate''
   rep''       NB. summary
   see ...     NB. seebox_jhs_ - display without boxes
   repposts''  NB. summary of quests with post
   repposts'~' NB. summary of guests with no posts
   repgeo''    NB. ipdata location from ip
   repgeox''   NB. unigue geos
   replog n    NB. last n entries
   replast''   NB. last entry for each snum
   repsnum n   NB. all records for snum n
   repsn       NB. see main records for snum n
   reptype n   NB. all records of type 
   repinbycity'' NB. inputs by city
   getndx'...' NB. col index of 1 or more col names
   getgcol'...' NB. cols from LOG
 g getcol'...'  NB. cols from g
)

require'~addons/data/jd/base/util_epoch_901.ijs' NB. sfe convert javascript ts to string

ufn=: '/etc/security/limits.conf'

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

logfolder=:  jpath'~temp/guest/'
nodeout=:    logfolder,'guest.log' NB. current log file
geoout=:     logfolder,'geo.txt'   NB. ipdata geo info

3 : 0''
if. _1=nc<'repnodeout' do. repnodeout=: nodeout end.
)

dumps=: '/var/lib/systemd/coredump'

NB. rename old guest.log as guest_n.log before starting new one
logroll=: 3 : 0
mkdir_j_ logfolder
('0',TAB,'0.0.0.0',TAB,'admin',LF) fwrite geoout
if. fexist nodeout do. NB. save last log before a new one is started
 d=. ,.(_4)}.each(6+#logfolder)}.each 1 dir logfolder
 d=. _4{.!.'0' ":>:>./0,;0".each d
 (logfolder,'guest_',d,'.log')frename nodeout
end. 
)

rawlog=: 3 : 0
fread repnodeout
)

repnonjhs=: 3 : 0
t=. rawlog''
t=. t,(LF~:{:t)#LF
t=. <;._2 t
b=. (<'jhs ')=4{.each t
;LF,~each(-.b)#t
)

NB. format LOG from nodeout and get ipdata
repget=: 3 : 0
getlog''
geoupdate''
)

NB. LOG set from log file
getlog=: 3 : 0
t=. rawlog''
t=. t,(LF~:{:t)#LF
t=. <;._2 t
b=. (<'jhs ')=4{.each t
t=. deb each b#t
t=. <;._1 each ' ',each t
c=. >./;#each t
t=. ":each 9{."1 >c{.each t
t=. }."1 t

NB. truncate url or postdata
i=. <a:;getndx'url'
q=. i{t
c=. 50 <. each #each q
q=. c{.each q
t=. q i}t

NB. truncate xtra
i=. <a:;getndx'xtra'
q=. i{t
c=. 40 <. each #each q
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
(-y<.#LOG){.LOG
)

NB. get count of rows for type y
getcount=: 3 : 0
c=. ;0".each(getndx 'count'){"1 ('type ',y)sel LOG
)

rep=: 3 : 0
nonjhs=. repnonjhs''
r=. 0 2$''
a=. efs_jd_ aa=. ;{.{.LOG
b=. efs_jd_ ;{.{:LOG
a=. 3{.365 24 60 60 1000000000 #: b-a
r=. r,'start';aa
r=. r,'days hrs mins';":a
r=. r,'records';#LOG
r=. r,'nonjhs';+/LF=nonjhs
r=. r,'dumps';#1 dir dumps
r=. r,'max port';>./}.;0".each getcol'port'
t=.   (getndx'type'){"1 LOG
c=. +/"1 =t
r=. r,(~.t),.<"0 c

c=. \:~;".each 6{"1 repposts''

if. #c do.
 r=. r,'inputs max mean';(+/c),({.c),(<.2%~#c){c
end.
see ":each r
)

NB. report snums with or without posts
repposts=: 3 : 0
repget''
assert (y-:'')+.y-:'~'
snums=. ,;_1".each ,getcol'snum'
locs=. repgeo''
c=. #locs
r=. 0 6$''
for_i. i.c do.
 t=. (i=snums)#i.#LOG
 h=. 5{.({.t){LOG
 url=. ,(getndx'url'){"1 t{LOG
 cnt=. +/(<'POST/jijx')=url
 n=.  +/(<'POST/jijx')~:url
 b=. ;(y-:'~'){(cnt>0);(cnt=0)*.n~:0
 if. b do.
  r=. r,h,({:i{repgeo''),<":cnt
 end.
end.
r
)

repsnum=: 3 : 0
LOG#~y=;_1".each(getndx'snum'){"1 LOG
)

NB. jurldecode that handles truncated data ending in % or %x
decode=: 3 : 0
n=. (#y)-y i: '%'
if. n e. 1 2 do. y=. (-n)}.y end.
t=. ~.<"1 (1 2 +"1 0 (y='%')#i.#y){y
d=. ".each(<'16b'),each tolower each t
d=. d{each <a.
t=. '%',each t
,t,.d
y rplc ,t,.d
)

repsn=: 3 : 0
repget''
t=. repsnum y
b=. |:t
t=. |:(decode each 6{b) 6} b
t=. see 0 1 6{"1 t#~(6{"1 t)~:<'POST/jijx'
t=. (;' ',~each y{repgeo''),LF,t
t rplc'%20';' ' NB. cheap jurldecode
)

reptype=: 3 : 0
LOG#~(<y)=1{"1 LOG
)

repspace=: 3 : 0
t=. shell  :: '' 'sudo du -s -h /home/p*'
a=. <;._2 t rplc LF;TAB
(2,~-:#a)$a
)

repmem=: 3 : 0
shell'free'
)

NB. last record for each snum
replast=: 3 : 0
t=. ,getcol'snum'
t=. t i: ~.t-.(,'+');,'0'
t{LOG
)

repgeo=: 3 : 0
><;._1 each  TAB,each<;._2 fread geoout
)

NB. unique geos
repgeox=: 3 : 0
d=. repgeo''
a=. 2{"1 d
see   (a i: ~.a){d
)

repinbycity=: {{
 t=. replast''
 ip=. 4{"1 t
 city=. 1{"1  (({."1 LOC)i.ip){LOC,6#<'?'
 c=. ;0".each 5{"1 t
 a=. #each city </. c
 b=. (~.city),.(<"0 city +//. c),.a
 (/:;1{"1 b){b
}}

NB. old way to get geo info - no longer used
xxxgetloc=: 3 : 0
t=. (repips'')-.{."1 LOC NB. ones we still need
for_n. t do.
 a=. shell'curl --no-progress-meter https://ipapi.co/',(;n),'/json/'
 a=. deb each <;._2 a,LF
 if. 1=#a do.
  echo 'too many ip loc requests - more to go: ',":(#repips'')-#LOC
  break.
 end. NB. assume too many requests
 i=. (7{.each a)i.(<'"city":')
 a=. 5{.i}.a
 a=. (>:;a i.each ':')}.each a
 a=. ;a
 a=. a-.LF,'"'
 a=. <;._2 a
 a=. <@>"1 a
 LOC=: LOC,deb each n,a
end.
i.0 0
)

NB. update geoout.txt with ipdata for new snums
geoupdate=: 3 : 0
d=. fread geoout
s=. <:#<;.2 d NB. count of guest locations
c=. #reptype'guest' 
if. 0=c-s do. i.0 0 return. end.
e=. ;LF,~each geofromnewsnum each >:s}.i.c NB. new ones
echo e
(d,e) fwrite geoout
i.0 0
)

getipdata=: 3 : 0
d=. shell'curl "https://api.ipdata.co/',y,'?api-key=',(fread'~temp/guest/ipdata.key'),'"'
q=: dec_json_pjson_ d
)

NB. get geo info for snum
geofromnewsnum=: 3 : 0
ip=. ;((<:y){reptype'guest') getcol 'ip'
d=. getipdata ip
i=. ({.d)i.;:'city region country_name postal'
try. d=. i{{:d
catch. d=. <'no-ipdata'
end.
d=. }:;d,each','
d=. d rplc'json_null';'_';'json_false';'0';'json_true';'1'
(":y),TAB,ip,TAB,d
)

getndx=: 3 : 'heads i.;:y'

getcol=: 3 : 0
LOG getcol y
:
(getndx y){"1 x
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

ports=: 3 : 0
shell :: [ 'sudo fuser -n tcp ',(":getports''),' >t.txt 2>&1'
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
A6_limit    =: 8*60*60
A7_dulim    =: 50e6 NB. limit for du -s -b /home/p?
A8_idle     =: 20*60
A9_ulimit   =: 'cpu=2 nofile=1024 as=4000000000' NB. cpu mins, as 4G lets pandas tut run
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

NB. y is version - '9.6' 
create_jguest=: 3 : 0
echo shell'sudo j',y,'/addons/ide/jhs/guest/create-jguest-sh $USER ',jpath'~install'
y fwrite '/jguest/version.txt'
)

set_limits_conf=: 3 : 0
d=. fread ufn
d=. <;.2 d,(LF~:{:d)#LF
d=. ;d#~(<'@pgroup ')~:8{.each d NB. remove old pgroup lines
t=. LF,~each <;._1' ',deb A9_ulimit
t=. ;(<'@pgroup - '),each t
t=. t rplc '=';' '
echo t
(d,t) fwrite 'limits.conf'
shell'sudo cp limits.conf ',ufn
i.0 0
)

repaccess=: 3 : 0
a=. <;._2 shell :: '' 'sudo ls /etc/letsencrypt/live'
a=. ;{.a-.<'README'
echo a

t=. shell'dig +short myip.opendns.com @resolver1.opendns.com'
echo t
)

NB. start node guest server
start=: 3 : 0
create_jguest '9.6' NB. 9.6 hardwired
'/jguest folder was not created'assert 2=ftype'/jguest'
if. ''-:getargs'' do. default'' end.
'A0_nodeport must have hardwired value'assert NODEP=A0_nodeport
'A1_jhsport must have hardwired value'assert JHSP=A1_jhsport

NB. create pgroup group and limits.conf
shell :: '' 'sudo groupadd pgroup'
set_limits_conf''

startNODE (<y) 2}getargs''
6!:3[1
echo LF,rawlog''

echo '$ node inspect localhost:9229',LF,'debug> help - debug> sb(''guest'',nnn) - debug> exec(''jhsport'')',LF

t=. }:shell'dig +short myip.opendns.com @resolver1.opendns.com'
if. ''-:t do. t=. getlanip'' end.
echo 'https://',t,':65101/jguest'

)

NB. stop node guest server
stop=: 3 : 0
shell :: [ 'sudo fuser --kill -n tcp ',":getports''
i.0 0
)

getports=: 3 : 0
if. ''-:getargs'' do. default'' end.
A0_nodeport,A1_jhsport,A1_jhsport+1+i.A5_guests
)

NB. guest version of startNODE_jhs_
NB. setsid not nohup - always use setsid!
NB. nodeport is https port served by node
NB. jhsport is jhs user port
NB. jhsport+1+i.guests are jhs guest ports
startNODE=: 3 : 0
argy=. y
'not from JHS'assert -.IFJHS
'nodeport jhsport key flags server guests limit dulim idle prlimit'=. y
'nodeport must be 65101 for local firewall access'assert nodeport-:65101
'key must be at least 5 chars'assert 4<#key
'idle<:limit'assert idle<:limit
 
stop'' NB. kill node/user/guest tasks
bin=. }:shell :: '' 'which node'
'node binary not found'assert #bin
(5!:5<'argy')fwrite'nodestartargs' NB. save the start args
shell'sudo echo "',(":limit,idle,dulim),'" | sudo tee /jguest/args' NB. menu>tool>guest
arg=. (":nodeport),' ',key,' ',(":jhsport),' "unused" "unused" ',(":guests),' ',(":limit),' ',(":dulim),' ',(":idle),' ',prlimit

t=. '"<BIN>" "<FLAGS>" "<SERVER>" <ARG> > "<OUT>" 2>&1' 
a=. t rplc '<BIN>';bin;'<FLAGS>';flags;'<SERVER>';server;'<ARG>';arg;'<OUT>';nodeout
a=. 'setsid ',a,' &' NB. critical!
echo a
logroll'' NB. start new guest.log - rename old one if necessary
shell a
)

NB. copied from JHS
getlanip=: 3 : 0
if. IFWIN do.
 r=. deb each<;._2 spawn'ipconfig'
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




