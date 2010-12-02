NB. J HTTP Server - jum app
coclass'jum'
coinsert'jhs'

NB. ALLPORTS integer ports used by jum
NB. HOSTNAME localhost or www.jsoftware.com or ...
NB. JUMPASS  jum password
startjum=: 3 : 0
'ALLPORTS HOSTNAME JUMPASS'=:y
OKURL_jhs_=:'jum' NB. jum no login
HOSTIP=: >2{sdgethostbyname_jsocket_ HOSTNAME NB. is 202.67.223.49 faster than www.jsoftware.com ?
JHS=: (>:JHS i:'/'){.JHS=:jpath'~user'
VALIDNAMECHARS=:'-_',((i.26)+a.i.'a'){a.
i.0 0
)

startjum_localhost=: 3 : 0
startjum (65002+i.3);'localhost';'jumjum'
)

startjum_jsoftware=: 3 : 0
startjum (50248+123*i.60);'www.jsoftware.com';'jumjum'
)

HBS=: 0 : 0
jhh1'J User Manager'
'msg'jhdiv' '
jhhr
jhh1'manage your account'
jhtablea
 jhtr 'user: ';'user' jhtext'';15
 jhtr 'pass: ';'pass' jhpassword'';15
jhtablez
'status' jhb'status'
'attn'   jhb'attn'
'kill'   jhb'kill'
'start'  jhb'start'
'go'     jhb'go'
jhhr
jhh1'create your account'
jhtablea
 jhtr 'user: '       ;'usern' jhtext'';15
 jhtr 'pass: '       ;'passn' jhpassword'';15
 jhtr 'repeat pass: ';'repeat'jhpassword'';15
 jhtr 'jum pass:  '  ;'jum'jhpassword'';15
jhtablez
'new'    jhb'new'
)

nopid=: ,'0'
invalid=: 'invalid user/pass'

NB. check user;pass
NB. return 0 invalid, 1 valid user/pass
check=: 3 : 0
'user pass'=. y
try.
 t=. fread jpath JHS,user,'/config/jhs.ijs'
 t=. (1 i.~'PASS=:'E. t)}.t
 t=. (>:t i.'''')}.t
 t=. (t i.''''){.t
 >(pass-:t){0;1
catch.
0
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

validatepids=: 3 : 0
if. IFUNIX do.
 for_n. y do. 
  f=. JHS,(>n),'/.jhspid'
  pid=. fread f
  r=. 1:@(2!:0) :: 0: 'kill -s 18 ',pid NB. SIGCONT
  if. -.r do. nopid fwrite f end.
 end.
else.
 f=. jpath'~temp/tasklist.txt'
 doscmd'tasklist /FI "IMAGENAME eq jconsole.exe">',f
 6!:3[0.25 NB. ugh - give doscmd a chance finish
 t=. <;._2 fread f
 pids=.>1{each 0".each((<'jconsole.exe')=12{.each t)#t
 r=. ;0".each fread each y,each <'/.jhspid'
 ps=. (-.r e. pids,0)#y
 (<nopid)fwrite each ps,each<'/.jhspid' NB. write dead pids
end.
)

getpids=: 3 : 0
fread each y,each<'/.jhspid'
)

NB. y is user
getpid=: 3 : 0
validatepids getupaths''
p=. fread JHS,y,'/.jhspid'
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
2!:0 y
)

jev_get=: create

CSS=: 0 : 0
#msg{color:red;}
)

NB. y is MSG for the html result
create=: 3 : 0
if. -.'jum'-:_3{.jpath'~user' do. y=. '<h1>WARNING: not running as jum!</h1>',y end.
'jum'jhr''
)

ev_status_click=: 3 : 0
'user pass'=. getvs'user pass'
if. check user;pass do.
 r=. report user
else.
 r=. invalid
end.
jhrajax (getv'jmid'),': ',r
)

ev_go_click=: ev_status_click

jhscfg=: 0 : 0
PORT=: <PORT>
LHOK=: 0
BIND=: 'any'
PASS=: '<PASS>'
)

new=: 0 : 0
<div style="color:red"><PASS> is your password and is required to login.</div>
)

ev_usern_enter=:  ev_new_click
ev_passn_enter=:  ev_new_click
ev_repeat_enter=: ev_new_click
ev_jum_enter=:    ev_new_click

ev_jum_enter=: ev_new_click

NB. create new user
ev_new_click=: 3 : 0
'usern passn repeat jum'=.getvs'usern passn repeat jum'
ports=. ;_1".each 1{"1 usertable'' NB. ports in use
port=. {.ALLPORTS-.ports           NB. first free port
if. 0=port do. cleanx 1 end.       NB. free 'oldest' port
ports=. ;_1".each 1{"1 usertable''
port=. {.ALLPORTS-.ports
if.     -.jum-:JUMPASS do. r=.'invalid jum pass (check with JUM admin)'
elseif. (4>#usern)+.#usern-.VALIDNAMECHARS do. r=. 'user must be at least 4 chars from ',VALIDNAMECHARS
elseif. (<usern)e.{."1 usertable'' do. r=. 'user already exists'
elseif. 4>#passn do. r=. 'pass must be at least 4 chars'
elseif. -.passn-:repeat do. r=. 'repeat not the same as pass'
elseif. 0=port do. r=. 'no ports available'
elseif. 1 do.
 try.
  p=. JHS,usern
  1!:5 <p NB. create new user folders
  1!:5 <jpath p,'/break'
  1!:5 <jpath p,'/config'
  1!:5 <jpath p,'/projects'
  1!:5 <jpath p,'/temp'
  (jhscfg hrplc 'PASS PORT';passn;":port) fwrite p,'/config/jhs.ijs'
  r=. 'user created'
 catch.
  r=. 'create new user failed'
 end.
end.
jhrajax 'new: ',r
)

signal_attn=: 3 : 0
:
if. IFUNIX do.
 unixshell 'kill -s 2 ',y
else.
 smoutput'not supported in windows: ','kill -s 2 ',y
end.
)

signal_kill=: 3 : 0
:
nopid 1!:2 <JHS,x,'/.jhspid' NB. clear out dead pid
if. IFUNIX do.
 unixshell 'kill -s 9 ',y
else.
 doscmd 'taskkill /f /t /pid ',y
end.
)

signal=: 4 : 0
'user pass'=. getvs'user pass'
r=. check user;pass
if. -.r do. jhrajax x,invalid return. end.
pid=. getpid user
if. nopid-:pid do.
 r=. 'task not running'
else.
 if. y-:'SIGINT' do.
  user signal_attn pid
 else.
  user signal_kill pid
 end.
 r=. user,' ',y,' signaled'
end.
jhrajax x,r
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
if. user-:'jum' do. smoutput'will not delete jum' return. end.
pid=. getpid user
if. nopid-:pid do.
 smoutput'task was not running'
else.
 smoutput'killing task: ',pid 
 user signal_kill pid
end.
6!:3[2 NB. give kill a chance so deletefolder will work
p=. JHS,user
smoutput 'destroying folder: ',p
'suspicious path for delete folder'assert 16<#p
deletefolder p
)

NB. deletefolder y
deletefolder=: 3 : 0
p=. <jpath y
if. 1=#1!:0 p do.
 if. 'd'=4{,>4{"1 (1!:0) p do.
  deleterecursive y
  1!:55 p
 end.
end.
i.0 0
)

NB. deletesub y
deleterecursive=: 3 : 0
assert. 3<+/PATHSEP_j_=jpath y
ns=. 1!:0 <jpath y,'\*'
for_n. ns do.
 s=. jpath y,'\',>{.n
 if. 'd'=4{>4{n do.
  deleterecursive s
 end.
 1!:55<s
end.
)

ev_attn_click=: 3 : 0
'attn: 'signal'SIGINT'
)

ev_kill_click=: 3 : 0
'kill: 'signal'SIGKILL'
)

ev_start_click=: 3 : 0
'user pass'=. getvs'user pass'
if. -.check user;pass do.
 r=. invalid
else.
 pid=. getpid user
 if. nopid-:pid do.
  starttask user
  r=. user,' task started'
 else.
  r=. ' task already running'
 end.
end.
jhrajax 'start: ',r
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
q=. y,each<'/config/jhs.ijs'
c=. ":each fread each q
portline each c
)

getupaths=: 3 : 0
d=. 1!:0 <JHS,'*'
jpath each (<JHS),each('d'=4{"1 >4{"1 d)#,{."1 d
)

getusers=: 3 : '(#JHS)}.each y'

NB. return table of users ports pids starts input busy last
usertable=: 3 : 0
ps=. getupaths''
validatepids ps
ports=. getports ps
pids=. getpids ps
users=. getusers ps
r=. jpath each ps,each<'/.jhslog.txt'
r=. 1!:1 :: ((,LF)&[) each <each r
starts=. +/each (<'start') E.each r
inputs=. +/each (<'prompt') E.each r
last=. ;each{: each <;._2 each r
busy=: +/each(<'sentence')E.each last
users,.ports,.pids,.starts,.inputs,.busy,.last
)

NB. y is col to sort by
show=: 3 : 0
a=. usertable''
a=. ":each a/:y{"1 a
c=. 2+>./ >#each a
;"1 (($a)$c){.each a
)

NB. HOSTNAME used instead of HOSTIP - wonder if HOSTIP would be faster
report=: 3 : 0
t=. usertable''
t=. (({."1 t)i.<y){t
port=. ":>1{t
pid=.  ":>2{t
t=. >(0~:".pid){' task not running';userreport rplc '<HOSTIP>';HOSTNAME;'<PORT>';port
)

userreport=: 0 : 0
<a href="http://<HOSTIP>:<PORT>/jijx">http://<HOSTIP>:<PORT>/jijx</a>
)

NB. create jum multi-user folder
NB. insist on virgin install - that is, jhs folder is empty
NB. y is port to serve and password
createjum=: 3 : 0
'not running as normal j701-user' assert 'j701-user'-:_9{.jpath'~user'
'port pass'=. y
1!:5 :: [ <jpath'~user/jhs'
p=. jpath'~user/jhs/jum'
d=. 1!:0 <jpath'~user/jhs/*'
'jhs folder not empty' assert 0=#d
1!:5 <p NB. create jum folders
1!:5 <jpath p,'/break'
1!:5 <jpath p,'/config'
1!:5 <jpath p,'/projects'
1!:5 <jpath p,'/temp'
(jhscfg hrplc 'PASS PORT';pass;":port) fwrite p,'/config/jhs.ijs'
(":port),' ',pass
)

JS=: 0 : 0
function ev_body_load(){jbyid("user").focus();}
function ev_status_click(){jdoajax(["user","pass"],"");}
function ev_attn_click(){jdoajax(["user","pass"],"");}
function ev_kill_click(){jdoajax(["user","pass"],"");}
function ev_start_click(){jdoajax(["user","pass"],"");}
function ev_go_click(){jdoajax(["user","pass"],"");}

function ev_usern_enter() {ev_new_click();}
function ev_passn_enter() {ev_new_click();}
function ev_repeat_enter(){ev_new_click();}
function ev_jum_enter()   {ev_new_click();}
function ev_new_click(){jdoajax(["usern","passn","jum","repeat"],"");}

function ajax(ts)
{
 var i,t;
 jbyid("msg").innerHTML=ts[0];
 if("new: user created"==ts[0]) // created new user
 {
  jbyid("user").value=jbyid("usern").value;
  jbyid("pass").value=jbyid("passn").value;
  jbyid("usern").value="";
  jbyid("passn").value="";
  jbyid("repeat").value="";
  jbyid("jum").value="";
 }
 if("click"==jform.jtype.value)
 {
  if("go"==jform.jmid.value)
  {
   i=ts[0].indexOf("http://");
   if(-1==i)
    jbyid("user").focus()
   else
   {
    t=ts[0].substr(i);
    location=t.substr(0,t.indexOf("\""));
   }  
  }
  else if("new"==jform.jmid.value)
   jbyid("usern").focus();
  else
   jbyid("user").focus();
 }
}
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
