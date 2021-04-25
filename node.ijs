NB. JHS node server

coclass'jhs'
require'~addons/ide/jhs/port.ijs'

node_man=: 0 : 0
*** summary - best read it all - but here are the steps
1. if not installed, download and install node: https://nodejs.org
2. start JHS
   load'~addons/ide/jhs/node.ijs'
   node_config_jhs_'?' 
   node_jhs_'start'
   node_std_jhs_'' NB. node stdout/stderr
3. browse to url in start report   

*** node - commercial server - https://nodejs.org
node https proxy server sits between JHS and client
securely access your JHS server from any device on lan or remote
 
*** https server requires certificate
self-signed certificate is provided for a quick start
this requires exception permission when you first browse the page
self-signed certificate built with:
 https://nodejs.org/en/knowledge/HTTP/servers/how-to-create-a-HTTPS-server/

*** jijx menu ide>break signals break to J from node proxy client

*** static ip - port forwarding - externalip
your machine ip address changes occasionaly if configured as dynamic
search www for how to set a static ip

access from a remote location requires router port forwarding
e.g., forward 65101 -> 65101 192.168.0.123
search www for how to configure port forwarding on your router

your router ip (used by remote users) will change occasionaly
make note of the remote address before you leave home

*** security - remote access to J on your machine!
1. have a good logonkey and protect it
2. don't leave a machine connected to your JHS server unattended
3. always logofff (jijx menu ide>logoff) when finished
3. self-signed certificate is OK for casual, private use
)


pjhsnode=: '~temp/jhs/node'
mkdir_j_ pjhsnode

3 : 0''
if. _1=nc<'NODEPORT' do. NODEPORT=: 0 end.
)

config_validate=: 3 : 0
'node pem nodeport key'=. y
node=. jpath node
pem=. jpath pem
(' is not node binary',~node)assert 1=ftype node
(' is not pem folder',~pem)assert 1=ftype pem,'/cert.pem'
(' is not valid nodeport',~":nodeport) assert (3000<:nodeport)*.nodeport<:65536
'key too short' assert 5<#key
)

node_config_man=: 0 : 0
for initial config or for changes run one of the following:
   node_config_jhs_ node ; pem ; nodeport ; logonkey
   node_config_jhs_ node ; logonkey
   
where:   
 node     - node executable  - e.g. C:/Program Files/nodejs/node.exe
 pem      - folder with cert.pem file - default ~addons/ide/jhs/node
 nodeport - port served by node proxy server - default 1+PORT_jhs_
 logonkey - key required to logon

to just change the logonkey run:
   node_config_jhs_ logonkey
)

node_config=: 3 : 0
if. '?'={.y do. echo node_config_man return. end.
mkdir_j_ pjhsnode
if. 1=#boxopen y do. y=. (fread pjhsnode,'/argbin');y end.
if. 2=#y do. y=. ({.y),'~addons/ide/jhs/node';(100+PORT);{:y end.
config_validate y
'bin pem nodeport key'=: y
(hostpathsep jpath bin)fwrite pjhsnode,'/argbin'
(hostpathsep jpath pem)fwrite pjhsnode,'/argpem'
((":nodeport),' ',key)fwrite pjhsnode,'/arg'
i.0 0
)

NB. start node server for current JHS server
NB. kills node server if already running
node=: 3 : 0
'arg must be ''?'' or ''start'' or ''stop''' assert (<,y)e.;:'? start stop'
if. '?'={.y do. echo node_man return. end.
mkdir_j_ pjhsnode
if. 'stop'-:y do. i.0 0[NODEPORT=: 0[killport_jport_ NODEPORT return. end.
'config_node_jhs_ must be run first' assert fexist pjhsnode,'/argbin'
arg=. fread pjhsnode,'/arg'
NODEPORT=: 0".(arg i.' '){.arg
killport_jport_ NODEPORT
'killport NODEPORT failed'assert _1=pidfromport_jport_ NODEPORT
breakfile=. hostpathsep setbreak'node'
pem=. fread pjhsnode,'/argpem'
arg=. arg,' ',(":PORT),' "',breakfile,'" "',pem,'"'
t=. '"<BIN>" "<FILE>" <ARG> > "<OUT>" 2>&1'
bin=. hostpathsep fread pjhsnode,'/argbin'
file=. jpath'~addons/ide/jhs/node/server'
nodeout=: hostpathsep jpath pjhsnode,'/std.log'
t=. t rplc '<BIN>';bin;'<FILE>';file;'<ARG>';arg;'<OUT>';nodeout
fork_jtask_ t
6!:3[0.2 NB. give task a chance to get started
'server failed to start' assert _1~:pidfromport_jport_ NODEPORT
node_status''
)

nodetemplate=: 0 : 0
node port <NODEPORT> is proxy server for JHS port <PORT>

local:  https://localhost:<NODEPORT>/jijx'
lan:    https://<LAN>:<NODEPORT>/jijx'
remote: https://<REMOTE>:<NODEPORT>/jijx'

set static ip address to avoid <LAN> last field changing
remote requires router port forwarding: <NODEPORT> -> <NODEPORT> <LAN>

   node_std_jhs_'' NB. node stdout/stderr
)

NB. report how to access node JHS proxy server
node_status=: 3 : 0
if. _1=pidfromport_jport_ NODEPORT do. 'node server is not running'[NODEPORT=: 0 return. end.
r=. nodetemplate rplc '<NODEPORT>';(":NODEPORT);'<PORT>';(":PORT);'<LAN>';(getlanip_jhs_'');'<REMOTE>';getexternalip_jhs_''

)

node_std=: 3 : 'fread nodeout'

NB. under construction
NB. start JHS server and node server
startJHS=: 3 : 0
assert y=65101
nodeport=. y
if. _1~:pidfromport_jport_ y do. 'server already running' return. end.
mkdir_j_ '~temp/jhsnode'
t=. '"<BIN>" "<FILE>" > "<OUT>" 2>&1'
jhsout=: '/home/eric/j902-user/temp/jhsnode/jhs.log'
a=. t rplc '<BIN>';(hostpathsep jpath'~bin/jconsole');'<FILE>';'~addons/ide/jhs/config/jhs.cfg';'<OUT>';jhsout
echo a
fork_jtask_ a
nodeout=: '/home/eric/j902-user/temp/jhsnode/node.log'
a=. t rplc '<BIN>';(hostpathsep jpath'~NODE/node');'<FILE>';'node_jhs/server';'<OUT>';nodeout
echo a
fork_jtask_ a
node_status nodeport
)
