NB. J HTTP Server - jum app
coclass'jum'
coinsert'jhs'

NB.! jhs.cfg should be changed to jhs.ijs

NB.! jum login doesn't have logout

NB. configuration
HOSTNAME=: >('alicia'-:>{:sdgethostname_jsocket_''){'localhost';'www.jsoftware.com'
HOSTIP=: >2{sdgethostbyname_jsocket_ HOSTNAME NB. is 202.67.223.49 faster than www.jsoftware.com ?
VALIDNAMECHARS=:'-_',((i.26)+a.i.'a'){a.
JHS=: (>:JHS i:'/'){.JHS=:jpath'~user'

NB.! with password it might be better to use consecutive ports
NB. return all valid ports - private range 49152 to 65535
allports=: 3 : '50248+123*i.60'

NB. validate user
NB. y 0 new user, 1 old user
NB. path or '' (response has been sent for '')
validate=: 3 : 0
user=. getv'name'
if. (0=#user)+.#user-.VALIDNAMECHARS do.
 ''[create user,' must be 1 or more chars from ',VALIDNAMECHARS
else.
 p=. JHS,user
 d=. 'd'e.>4{5{.,1!:0<p NB. 1 if folder
 if. y=d do.
  p
 else.
  ''[create user,>d{' is not a user';' is already a user' 
 end.
end.
)

log=: 3 : 0
s=. y rplc LF;' ';'<br>';'';'&nbsp;';' ';'</a>';''
'a b'=. s i. '<>'
if. (a<b)*.b<#s do. s=. (a{.s),(>:b)}.s end. NB. remove <link>
but=. getv'jbutton'
but=. >(0-:but){(6{._7}.but);'status'
logapp_jhs_ but,' ; ',s
)

NB. return 1 if y is valid pid, else 0
NB. pid is char string of numbers
ispid=: 3 : 0
if. 0=".y do. 0 return. end.
if. IFUNIX do.
 1:@(2!:0) :: 0: 'kill -s 18 ',y NB. SIGCONT
else.
 1 NB. windows testing pretends all pids are valid
end.
)

NB. y is user
NB. return valid pid or '0' (invalid pid reset to '0')
getpid=: 3 : 0
p=. <JHS,y,'/.jhspid'
pid=.  (1!:1) :: ('0'&[) p
if. ispid pid do. pid return. end.
'0'[pid0 y NB. clear out dead pid
)

NB. y is user
pid0=: 3 : 0
'0' 1!:2 <JHS,y,'/.jhspid' NB. clear out dead pid
)

NB. y is user
starttask=: 3 : 0
t=. '-js "load''~addons/ide/jhs/core.ijs''" "jhs''',y,'''"'
if. IFUNIX do.
 2!:1 ('"',jpath'~bin/jconsole'),'" ',t,' &'
else.
 doscmd ('"',jpath'~bin/jconsole.exe'),'"  ',t
end.
)

NB. & at end of command is critical
unixshell=: 3 : 0
smoutput y
if. IFUNIX do. 2!:0 y end.
)

jev_get=: 3 : 0
if. 'ebi'-:getv'escape' do. allowedurls_jhs_=: '' end.
create''
)

Nlogin=: 0 : 0
<h1>J User Manager login<h1>
SECURITY! Logout when you are done (close browser or press logout).<br><br>
)

NB. override of jlogin defaults
startjum=: 3 : 0
'already started' assert 0=#allowedurls
Nlogin_jlogin_=: Nlogin
goto_jlogin_=: 3 : 'create_jum_'''''
LIMIT_jlogin_=: _
allowedurls_jhs_=: 'jum';'jlogin'
i.0 0
)

stopjum=: 3 : 0
'not started' assert 1=#allowedurls
allowedurls_jhs_=: ''
i.0 0
)


B=: 0 : 0
'<h1>J HTTP Server : User Manager</h1>'
'user: ' name ^^
status new attn kill start users ^^
'<MSG>'
)

BIS=: 0 : 0
name   ht'<PROMPT>';15
status hb'status'
new    hb'new'
attn   hb'attn'
kill   hb'kill'
start  hb'start'
users  hb'users'
)

NB. y is MSG for the html result
create=: 3 : 0
if. #y do.
 log y
 prompt=. getv'name'
 else.
 prompt=. ''
end.
if. -.'jum'-:_3{.jpath'~user' do. y=. '<h1>WARNING: not running as jum!</h1>',y end.
hr 'jum';(css'');(js JS);(B getbody BIS)hrplc'PROMPT MSG';prompt;y
)

ev_name_enter=: ev_status_click

ev_status_click=: 3 : 0
user=. getv'name'
p=. validate 1
if. ''-:p do. return. end.
create user report p
)

jhscfg=: 0 : 0
PORT=: <PORT>
LHOK=: 0
BIND=: 'any'
PASS=: '<PASS>'
)

new=: 0 : 0
<div style="color:red"><PASS> is your password and is required to login.</div>
)

NB. validate name, create folder, create task
ev_new_click=: 3 : 0
user=. getv'name'
p=. validate 0
if. ''-:p do. return. end.
ports=. ;_1".each 1{"1 usertable'' NB. user ports 
port=. {.(allports'')-.ports
if. 0=port do. create user,' no ports available' return. end.
1!:5 <p NB. create new user folders
1!:5 <jpath p,'/break'
1!:5 <jpath p,'/config'
1!:5 <jpath p,'/projects'
1!:5 <jpath p,'/temp'
pass=. _4{.'.'-.~0j3":{:6!:0''
(jhscfg hrplc 'PASS PORT';pass;":port) fwrite p,'/config/jhs.cfg'
create new hrplc 'PASS';pass
)

signal=: 3 : 0
user=. getv'name'
p=. validate 1
if. ''-:p do. return. end.
pid=. getpid user
if. '0'-:pid do.
 create user,' task not running'
else.
 if. y-:'SIGINT' do.
  unixshell 'kill -s 2 ',pid
 else.
  unixshell 'kill -s 9 ',pid
  pid0 user
 end.
 create user,' ',y,' signaled'
end.
)

NB. clean_jum_(t i.' '){.t=.{.show_jum_ 6 NB. clean oldest

NB. cleanx y - kill y oldest users
cleanx=: 3 : 0
if. y>10 do. 'max 10 killed at a time' return. end.
while. y do.
 t=.{.show 6
 smoutput t
 clean(t i.' '){.t
 y=. <:y
end.
)

NB. clean user - kill task if any and delete folders
clean=: 3 : 0
user=. y
pid=. getpid user
if. '0'-:pid do.
 smoutput'task was not running'
else.
 smoutput'killing task: ',pid 
 unixshell 'kill -s 9 ',pid
 pid0 user
end.
p=. JHS,user
smoutput 'destroying folder: ',p
unixshell 'rm -r ',p
)

ev_attn_click=: 3 : 0
signal 'SIGINT'
)

ev_kill_click=: 3 : 0
signal 'SIGKILL'
)

ev_start_click=: 3 : 0
user=. getv'name'
p=. validate 1
if. ''-:p do. return. end.
pid=. getpid user
if. '0'-:pid do.
 create user,' task started'
 starttask user NB. must be after browser result - else browser hangs
else.
 create user,' task already running'
end.
)

ev_users_click=: 3 : 0
create  'USERS: ',;(<'<br>&nbsp;'),each a/:a=.{."1 usertable''
)

portline=: 3 : 0
d=. <;._2 ' '-.~y,LF
b=. (<'PORT=:')=6{.each d 
5{.6}.'',;b#d
)

getports=: 3 : 0
q=. y,each<'/config/jhs.cfg'
c=. ":each fread each q
portline each c
)

NB. return table of users ports pids starts input busy last
usertable=: 3 : 0
d=. 1!:0 <JHS,'*'
if. 0=#d do. 0 3$'' return. end. 
f=. ('d'=4{"1 >4{"1 d)#,{."1 d
p=. jpath each (<JHS),each f
port=. getports p
r=. jpath each p,each<'/.jhslog.txt'
r=. 1!:1 :: ((,LF)&[) each <each r
starts=. +/each (<'start') E.each r
inputs=. +/each (<'prompt') E.each r
last=. ;each{: each <;._2 each r
busy=: +/each(<'sentence')E.each last
f,.port,.(getpid each f),.starts,.inputs,.busy,.last
)

NB. y is col to sort by
show=: 3 : 0
a=. usertable''
a=. ":each a/:y{"1 a
c=. 2+>./ >#each a
;"1 (($a)$c){.each a
)

NB. HOSTNAME used instead of HOSTIP - wonder if HOSTIP would be faster
report=: 4 : 0
t=. usertable''
port=. ":>1{(({."1 t)i.<x){t
pid=.  getpid x
t=. >(0~:".pid){' task not running';userreport rplc '<HOSTIP>';HOSTNAME;'<PORT>';port
)

userreport=: 0 : 0
Link to jijx:<br> 
<a href="http://<HOSTIP>:<PORT>/jijx">http://<HOSTIP>:<PORT>/jijx</a>
)

NB. create jum multi-user folder
NB. insist on virgin install - that is, jhs folder is empty
createjum=: 3 : 0
'not running as normal j701-user' assert 'j701-user'-:_9{.jpath'~user'
1!:5 :: [ <jpath'~user/jhs'
p=. jpath'~user/jhs/jum'
d=. 1!:0 <jpath'~user/jhs/*'
'jhs folder not empty' assert 0=#d
port=. 50001
1!:5 <p NB. create jum folders
1!:5 <jpath p,'/break'
1!:5 <jpath p,'/config'
1!:5 <jpath p,'/projects'
1!:5 <jpath p,'/temp'
pass=. 'jumjum'
(jhscfg hrplc 'PASS PORT';pass;":port) fwrite p,'/config/jhs.cfg'
(":port),' ',pass
)

JS=: 0 : 0
function ev_body_load(){jform.name.focus();}
)

NB. windows createprocess stuff for windows testing

NB. && separates multiple commands
NB. use /S with quotes around complete command to preserve quotes
NB. 2>&1 to send stderr to stdout

doscmd=: 3 : 0
WaitForSingleObject=. 'kernel32 WaitForSingleObject i i i'&cd
CloseHandle=. 'kernel32 CloseHandle i i'&cd"0
CreateProcess=. 'kernel32 CreateProcessA i i *c i i i  i i i *c *c'&cd
CREATE_NO_WINDOW=. 16b8000000
CREATE_NEW_CONSOLE=. 16b00000010
f=. CREATE_NO_WINDOW
f=. CREATE_NEW_CONSOLE
NB. /S strips leading " and last " and leaves others alone
c=. 'cmd /S /C "',y,'"'
si=. (68{a.),67${.a.
pi=. 16${.a.
'r i1 c i2 i3 i4 f i5 i6 si pi'=. CreateProcess 0;c;0;0;0;f;0;0;si;pi
ph=. _2 ic 4{.pi
CloseHandle ph
)
