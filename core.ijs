

NB. JHS - core services
require 'socket'
coclass'jhs'
VERSION=: '3.1'

0 : 0
*** Cache-Control: no-cache
Browser caching can be confusing and is quite different
from a desktop application.

Back/forward, switching tabs, switching browser apps, are
showing cached pages. A get (typed into the URL box or from
favorites) shows a cached page if possible. And exactly when
it shows a cached page and when it gets a fresh page varies
from browser to browser and the phase of the moon. This can
be confusing if you have the expectation of a new page with
current information.

Ajax requests (in particular JIJX) have no-cache as old
pages in this area are more confusing and than useful.

All other pages allow cache as the efficiency of mucking
around pages without dealing with the server is significant.
Sometimes this means that when you want a fresh page with
latest info you are in getting a cached version.

Some browsers have a transmission progress bar indicator.
No flash means you are getting a cached page and a flash
means you getting a new page.

Refresh (F5 on some browsers) gets a fresh page and is a
useful stab poke if confused.

*** login/bind/cookie/security overview

Listening socket can bind localhost or any. What about lan?

Localhost is relatively secure.
Firewalls provide some any protection.

Localhost is relatively secure and gains little from login.

Non-localhost should require a login.

Login is provided by a cookie.
The cookie is set in the response to providing a password.
That cookie is then included in the header of all requests
and is validated by the server.

The cookie is non-persistent and is deleted when browser closes.
New tabs do not need to login, but a new browser does.

*** app overview
URL == APP == LOCALE

Browser request runs first available sentence from:
 post          - jdo
 get URL has . - jev_getsrcfile_jfilesrc_ URL_jhs_
 get           - jev_get_URL_''

Post can be submit (html for new page) or ajax (for page upates).

The sentence can send a response (closing SKSERVER).

urlresponse_URL_ run if response has not been sent
when new input required. jijx does this as the response
requires J output/prompt that are not available until then.

Use XMLHttpRequest() for AJAX style single page app.
Post request for new data to update page. jijx app does
this for significant benefit (faster and no flicker).

Form has hidden:
 button to absorb enter not in input text (required in FF)
 jdo="" submit sentence

Enter in input text field caught by element keydown event handler.

*** event overview
Html element id has main part and optional sub part mid[*sid].

<... id="mid[*sid]" ... ontype="return jev('mid[*sid]','type',event)"

jev(mid*sid,type,event)
{
 sets evid,evtype,evmid,evsid,evev
 try eval ev_mid_type()
 returns true or false
}

If ev_mid_type returns value, it is returned to the onevent caller,
otherwise a calculated value is returned.

ev_mid_type can ajax or submit J sentence.
Ajax has explicit nv pairs in post data and result.
Submit has normal form nv pairs in post data and result is new page

*** gotchas

Form elements use name="...". Submit of hidden element requires
name and the element will not be included in post data with just id.

Javascript works with id. In general a form input element should have
the same value for both id and name. The exception is radio where id
is unigue and name is the same across a set of radio buttons. 

***
1. depends on cross platform javascript and styles

2. 127.0.0.1 seems faster than localhost
   wonder if dot ip name is faster than www.jsoftware.com

3. Enter with only text has no button.
   Enter with buttons submits as if first button pressed.

4. DOCTPTE etc. - google main page and jsoftware
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gmail/Jsoftware</title>

5. perhaps should move to DOCTYPE xhtml strict

6. html pattern (modified from google mail, jsoftware)
<DOCTYPE...>
<html>
 <head>
  <meta...>
  <title>...</title>
  [<style type="text/css">...</style>...]
 </head>
 <body>
  ...
 </body>
 [<script>...</script>...]
</html>

9. autocomplete and wrap fail validator - but are necessary
)

NB. J needs input - y is prompt - '' '   ' '      '
input=: 3 : 0
logjhs 'prompt'
logapp 'jhs input prompt: ',":#y
LOGN=: LOGN,markprompt,y,') -->'
try.
if. _1~:SKSERVER do. try. ".'urlresponse_',URL,'_ y' catch. end. end. NB. jijx
if. _1~:SKSERVER do. jbad'' end.
getdata'' NB. get and parse http request
if. 1=NVDEBUG do. smoutput seebox NV end. NB. HNV,NV
if. (0~:#PASS)*.(-.cookie-:gethv'Cookie:')*.-.LHOK*.PEER-:LOCALHOST 
                       do. r=. 'jev_get_jlogin_ 0'
elseif. 'post'-:METHOD do. r=. getv'jdo'
elseif. '.'e.URL       do. r=. 'jev_getsrcfile_jfilesrc_ URL_jhs_'
elseif. 1              do. r=. 'jev_get_',URL,'_'''''
end.
logjhs'sentence'
logapp 'jhs sentence: ',r

NB.! what about jfilesrc? security! 
NB. enforce app restrictions - must be event in allowedurls
if. #allowedurls do.
 try.
  'v n'=. ;:r         NB. 2 tokens
  assert 3=nc<v       NB. v must be verb
  assert 'jev_'-:4{.v NB. must have handler prefix
  smoutput v
  smoutput     ((}:v)i:'_')}.v
  smoutput (<}.}:((}:v)i:'_')}.v)
  assert   (<}.}:((}:v)i:'_')}.v) e. allowedurls 
 catch.
  smoutput 'sentence not allowed: ',r
  r=. 'jbad_jhs_ 0'
 end.
end.
r NB. J sentence to run

catch.
 logappx 'input error'
 exit'' NB. 2!:55[11 crashes
end.
)

NB. J has output - x is type, y is string
NB. MTYOFM		1	formatted result array
NB. MTYOER		2	error
NB. MTYOLOG		3	log
NB. MTYOSYS		4	system assertion failure
NB. MTYOEXIT	5	exit - not used
NB. MTYOFILE	6	output 1!:2[2
NB. x is type, y is string
output=: 4 : 0
logapp 'output type : ',":x
try.
 s=. y NB. output string
 type=. x NB. MTYO type
 class=. >type{'';'fm';'er';'log';'sys';'';'file'
 if. (3~:type)+.-.'jev_'-:4{.s do. NB. jev_... lines not logged
  LOGN=: LOGN,'<div class="',class,'">',(htmlfroma s),'</div>'
 end.
 if. (3=type)*.(0~:#s-.' ')*.(-.s-:>{.INPUT)*.(-.'jev_'-:4{.s)*.0=+/'</script'E.tolower s do.  
  INPUT=: INPUT,~<s -. LF NB. labs (0!:noun) has LF???
  INPUT=: (PC_RECALL_LIMIT<.#INPUT){.INPUT
 end.

catch.
 logappx'output'
 exit''
end.
)

NB. event handler called by js event
jev=: 3 : 0
try.
 ".t=. 'ev_',(getv'jmid'),'_',(getv'jtype'),' 0'
catch.
 smoutput LF,'*** event handler error',LF,t,LF,(13!:12''),seebox NV
end.
)

NB.! clean up droplog and use it!
droplog=: 3 : 0
 drop=. ''
 while. PC_LOG_LIMIT<#LOG do. NB. limit log size
  t=. markinput E. LOG
  if. 5>+/t do. break. end.   NB. keep some divs
  drop=. '<div class="er">...</div>'
  LOG=: (1{t#i.#t)}.LOG NB. drop up to next div
 end.
 LOG=: drop,LOG
)

NB. get/post data - headers end with LF,LF
NB. post has Content-Length: bytes after the header
NB. listen and read until a complete request is ready
getdata=: 3 : 0
while. 1 do.
 logapp 'getdata loop'
 SKSERVER_jhs_=: 0 pick sdcheck_jsocket_ sdaccept_jsocket_ SKLISTEN
 try.
  PEER=: >2{sdgetpeername_jsocket_ SKSERVER
  t=. LF,LF
  h=. ''
  while. 1 do.
   h=. h,srecv''
   i=. (t E. h)i.1
   if. i<#h do. break. end.
  end.
  d=. (i+2)}.h
  h=. (>:i){.h
  parseheader h
  if. 'POST '-:5{.h do.
   len=.".gethv'Content-Length:'
   while. len~:#d do.
    d=. d,srecv''
   end.
   METHOD=: 'post'
   seturl'POST'
   parse d
  else.
   METHOD=: 'get'
   seturl'GET'
   t=. (t i.' '){.t=. gethv 'GET'
   parse (>:t i.'?')}.t
  end.
  return.

 catch.
  smoutput '*** getdata error: ',13!:12''
  logapp 'getdata error: ',13!:12''
 end.
end.
)

seturl=: 3 : 0
URL=: urldecode}.(<./t i.' ?'){.t=. gethv y
)

serror=: 4 : 0
if. y do.
 sdclose_jsocket_ SKSERVER
 logapp x
 'socket error'13!:8[3 
end.
)

NB. return SKSERVER data (toJ)
NB. serror on 
NB.  timeout, socket error, or no data (disconnect)
NB. PC_RECVSLOW 1 gets small chunks with time delay 
srecv=: 3 : 0
z=. sdselect_jsocket_ SKSERVER;'';'';PC_RECVTIMEOUT

NB.! debug info
if. SKSERVER~:>1{z do.
 smoutput 'please report following output to beta'
 smoutput 'srecv select failure'
 smoutput z
 smoutput SKSERVER,SKLISTEN,PC_RECVTIMEOUT
end.

'recv not ready' serror SKSERVER~:>1{z
if. PC_RECVSLOW do.
 6!:3[1
 bs=. 100 NB. 100 byte chunks with 1 second delay
else.
 bs=. PC_RECVBUFSIZE
end.
'c r'=. sdrecv_jsocket_ SKSERVER,bs,0
('recv error: ',":c) serror 0~:c
'recv no data' serror 0=#r
toJ r
)

NB. return count of bytes sent to SKSERVER
NB. serror on
NB.  timeout, socket error, no data sent (disconnect)
NB. PC_SENDSLOW 1 simulates slow connection
ssend=: 3 : 0
z=. sdselect_jsocket_ '';SKSERVER;'';PC_SENDTIMEOUT
'send not ready' serror SKSERVER~:>2{z
if. PC_SENDSLOW do.
 6!:3[0.2
 y=. (100<.#y){.y NB. 100 byte chunks with delay
end.
'c r'=. y sdsend_jsocket_ SKSERVER,0
('send error: ',":c) serror 0~:c
'send no data' serror 0=r
r NB. bytes sent
)

putdata=: 3 : 0
logapp'putdata'
try. 
 while. #y do. y=. (ssend y)}.y end. 
catch.
 logapp 'putdata error: ',13!:12''
end.
)

NB. set HNV from request headers
parseheader=: 3 : 0
a=. <;._2 y
i=. (y i.' '),>:}.>a i. each ':'
HNV=: (i{.each a),.dlb each i}.each a
)

NB. global NV set from get/post data
NB. name/values delimited by & but no trailing &
NB. namevalue is name[=[value]]
NB. name0value[&name1value1[&name2...]]
parse=: 3 : 0
try.
 d=. <;._2 y,'&'#~0~:#y
 d=. ;d,each('='e.each d){'=&';'&'
 d=. <;._2 d rplc '&';'='
 NV=: urldecodeplus each (2,~(2%~#d))$d
catch.
 smoutput '*** parse failed: ',y
 NV=: 0 2$''
end.
)

gethv=: 3 : 0
i=. (0{"1 HNV)i.<y
>1{i{HNV,0;0
)

NB. get value for name y - '' for no value 
getv=: 3 : 0
i=. (0{"1 NV)i.<,y
>1{i{NV,0;''
)

NB. 0 if name not in NV and 1 if it is
getvq=: 3 : 0
i=. (0{"1 NV)i.<y
i<#NV
)

logclear=: 3 : ''''' 1!:2 logappfile'

NB. log timestamp
lts=: 3 : 0
20{.4 3 3 3 3 3":<.6!:0''
)

logjhs=: 3 : 0
if. #USERNAME do. ((lts''),y,LF)1!:3 logjhsfile end.
)

logapp=: 3 : 0
if. -.PC_LOG do. return. end.
((lts''),(>coname''),' : ',y,LF)1!:3 logappfile
)

NB. force log of this and following messages
logappx=: 3 : 0
PC_LOG=: 1
logapp y,' error : ',13!:12''
)

logstdout=: 3 : 'i.0 0[(y,LF) 1!:2[4'

NB. z local utilities

jlog__=: 3 : 0
if. y-:0 do.
 LOGFULL_jhs_=: LOGFULL_jhs_,LOG_jhs_
 LOG_jhs_=:''
elseif. y-:_ do.
 LOG_jhs_=: LOGFULL_jhs_,LOG_jhs_
 LOGFULL_jhs_=: ''
end.
jhtml '<!-- refresh -->'
i.0 0
)

NB. one very long line as LF is <br>
jhtml_z_=: 3 : 0
a=. 9!:36''
9!:37[ 4$0,1000+#y NB. allow lots of html formatted output
smoutput marka_jhs_,y,markz_jhs_
9!:37 a
)

jnv__=: 3 : 'NVDEBUG_jhs_=:y' NB. toggle short NV debug display

jbd__=: 3 : '9!:7[y{Boxes_j_' NB. select boxdraw (PC_BOXDRAW)

NB. toggle jfe behavior
jfe=: 3 : 0
15!:16 y
i.0 0
)

console_welcome=: 0 : 0

J HTTP Server - init OK

Requires a modern browser (later than 2004) with Javascript.

A : separates ip address from port. Numeric form ip can be faster than name.
<REMOTE>
Start a web browser on this machine and enter URL:
   http://<LOCAL>:<PORT>/jijx
)

remoteaccess=: 0 : 0

Access from another machine:
   http://<IPAD>:<PORT>/jijx
)

console_failed=: 0 : 0

J HTTP Server - init failed 

Port <PORT> already in use by JHS or another service.

If JHS is serving the port, close this task and use the running server.

If JHS server is not working, close it, close this task, and restart.

See file: <CFGFILE>
for information on using another PORT.
)

NB. html config parameters
config=: 3 : 0
PC_FONTFAMILY=:   '"courier new","courier","monospace"'
PC_FONTSIZE=:     '11px'
PC_FONT_COLOR=:   'black'
PC_FM_COLOR=:     'black'  NB. formatted output
PC_ER_COLOR=:     'red'    NB. error
PC_LOG_COLOR=:    'blue'   NB. log user input
PC_SYS_COLOR=:    'purple' NB. system error
PC_FILE_COLOR=:   'green'  NB. 1!:! file output
PC_BOXDRAW=:      0        NB. 0 utf8, 1 +-, 2 oem
PC_RECALL_LIMIT=: 25       NB. limit ijx recall lines
PC_LOG_LIMIT=:    20000    NB. limit ijx log size in bytes
PC_RECVSLOW=:     0        NB. 1 simulates slow recv connection
PC_RECVBUFSIZE=:  10000    NB. size of recv buffer
PC_RECVTIMEOUT=:  5000     NB. seconds for recv timeout
PC_SENDSLOW=:     0        NB. 1 simulates slow send connection
PC_SENDTIMEOUT=:  5000     NB. seconds for send timeout
PC_NOJUMPS=:      0        NB. 1 to avoid jijx jumps
PC_LOG=:          0        NB. 1 to log events
)

NB. fix userfolders for username y
NB. adjust SystemFolders for multi-users in single account
fixuf=: 3 : 0
USERNAME=: y
if. 0=#y do. return. end.
t=. jpath'~user/jhs/',USERNAME,'/config/jhs.cfg'
(t,' does not exist') assert fexist t
t=. SystemFolders_j_
a=. 'break';'config';'temp';'user'
i=. ({."1 t)i.a
p=. <'~user/jhs/',y
n=. a,.jpath each p,each '/break';'/config';'/temp';''
SystemFolders_j_=: n i} t
(":2!:6'') 1!:2 <jpath'~user/.jhspid'
1!:44 jpath'~user' NB. cd
)

NB. similar to startup_console in boot.ijs
startupjhs=: 3 : 0
f=. jpath '~config/startup_jhs.ijs'
if. 1!:4 :: 0: <f do.
  try.
    load__ f
  catch.
    smoutput 'An error occurred when loading startup script: ',f
  end.
end.
)

dobind=: 3 : 0
sdcleanup_jsocket_''
SKLISTEN=: 0 pick sdcheck_jsocket_ sdsocket_jsocket_''
if. UNAME-:'Linux'  do. 'libc.so.6  fcntl i i i i' cd SKLISTEN,F_SETFD_jsocket_,FD_CLOEXEC_jsocket_ end.
if. UNAME-:'Darwin' do. 'libc.dylib fcntl i i i i' cd SKLISTEN,F_SETFD_jsocket_,FD_CLOEXEC_jsocket_ end.
if. -.UNAME-:'Win'  do. sdsetsockopt_jsocket_ SKLISTEN;SOL_SOCKET_jsocket_;SO_REUSEADDR_jsocket_;2-1 end.
sdbind_jsocket_ SKLISTEN;AF_INET_jsocket_;y;PORT
)

nextport=: 3 : 0
while. 
 PORT=: >:PORT
 r=.dobind y
 sdclose_jsocket_ SKLISTEN
 sdcleanup_jsocket_''
 erase'SKLISTEN_jhs_'
 10048=r
do. end.
)

lcfg=: 3 : 0
try. load jpath y catch. ('load failed: ',y) assert 0 end.
)

NB. config_file jhscfg username
NB. USERNAME not '' adjusts SystemFolders and does cd ~temp
NB. load config files to set PORT LHOK BIND PASS USER
NB. configuration loads
NB.    ~addons/ide/jhs/config/jhs_default.ijs
NB.  then loads first file (if any) that exists from
NB.    config_file (error if not '' and does not exist)
NB.    ~config/jhs.ijs
NB.    ~addons/ide/jhs/config/jhs.ijs
NB. config sets PORT BIND LHOK PASS USER
NB. USER used in jlogin - JUM forces USER=:USERNAME
jhscfg=: 4 : 0
fixuf y
lcfg jpath'~addons/ide/jhs/config/jhs_default.ijs'
if.     -.''-:t=. jpath x                                do. lcfg t
NB.! ugh JUM uses jhs.cfg and we would prefer jhs.ijs
elseif. fexist t=. jpath'~config/jhs.cfg'                do. lcfg t
elseif. fexist t=. jpath'~addons/ide/jhs/config/jhs.ijs' do. lcfg t
end.
'PORT invalid' assert (PORT>49151)*.PORT<2^16
'BIND invalid' assert +./(<BIND)='any';'localhost'
'LHOK invalid' assert +./LHOK=0 1
'PASS invalid' assert 2=3!:0 PASS
if. _1=nc<'USER' do. USER=: '' end. NB.! not in JUM config
'USER invalid' assert 2=3!:0 USER
PASS=: ,PASS
USER=: ,USER
if. #USERNAME do. USER=:USERNAME end.
BIND=: >(BIND-:'any'){'127.0.0.1';''
)

NB. [config_file] init USERNAME
NB. SO_REUSEADDR allows server to kill/exit and restart immediately
NB. FD_CLOEXEC prevents inheritance by new tasks (UM startask)
init=: 3 : 0
''init y
:
if. 2~:3!:0 y do. y=. '' end. NB.! installer jhs.bat has old style call
'already initialized' assert _1=nc<'SKLISTEN'
x jhscfg y
PATH=: (>:t i:'/'){.t=.jpath>(4!:4 <'VERSION_jhs_'){4!:3''
t=. SystemFolders_j_,'labs';jpath'~system/extras/labs'
SystemFolders_j_=: /:~t NB.! should be done in profile
ip=. >2{sdgethostbyname_jsocket_ >1{sdgethostname_jsocket_''
LOCALHOST=: >2{sdgethostbyname_jsocket_'localhost'
logappfile=: <jpath'~user/.applog.txt' NB. username
logjhsfile=: <jpath'~user/.jhslog.txt' NB. username
logjhs'start'
config''
SETCOOKIE=: 0
NVDEBUG=: 0 NB. 1 shows NV on each input
INPUT=: '' NB. <'   '
LOG=: marka,'<font style="font-size:20px; color:red;" >J Http Server<br></font>',markz
LOGN=: ''
LOGFULL=: ''
PDFOUTPUT=: 'output pdf "',(jpath'~temp\pdf\plot.pdf'),'" 480 360;'  
DATAS=: ''
PS=: '/'
cfgfile=. jpath'~addons/ide/jhs/config/jhs_default.ijs'
r=. dobind BIND
if. r=10048 do.
 smoutput console_failed hrplc 'PORT CFGFILE';(":PORT);cfgfile
 'JHS init failed'assert 0
end.
sdcheck_jsocket_ r
sdcheck_jsocket_ sdlisten_jsocket_ SKLISTEN,1
SKSERVER_jhs_=: _1
boxdraw_j_ PC_BOXDRAW
NB.! smoutput console_welcome rplc 'PORT LOCAL';(":PORT);'IPAD';(>(BIND-:''){'NOACCESS';ip);'LOCAL';LOCALHOST
remote=. >(BIND-:''){'';remoteaccess hrplc 'IPAD PORT';ip;":PORT
smoutput console_welcome hrplc 'PORT LOCAL REMOTE';(":PORT);LOCALHOST;remote
startupjhs''
allowedurls=: ''
if. 0~:#PASS do.
 cookie=: 'jcookie=',0j4":{:6!:0''
else.
 cookie=: ''
end.
input_jfe_=: input_jhs_  NB. only use jfe locale to redirect input/output
output_jfe_=: output_jhs_
jfe 1
)

NB. load rest of JHS
t=. (<'.ijs'),~each ;:'core utilh utiljs jlogin jijx jijs jfile jfilesrc jhelp jal jdemo jgcp'
corefiles=: (<jpath'~addons/ide/jhs/'),each t
load__ }.corefiles

NB.! debug stuff
pfiles=:     (<'/users/eric/svn/addons/ide/jhs/'),each t
p__=: 3 : 0
d=. fread each pfiles_jhs_
d fwrite each corefiles_jhs_
load corefiles_jhs_
)                         

NB.! kill off - use init_jhs_ in next installer
jhs_z_=: init_jhs_

