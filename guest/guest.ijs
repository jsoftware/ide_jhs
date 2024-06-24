NB. start jhs guest on port
load'~addons/ide/jhs/core.ijs'
setbreak'node'
configdefault_jhs_''
PORT_jhs_=:0".;2{ARGV
AUTO_jhs_=:0
TIPX_jhs_=: 'g'
QRULES_jhs_=: 2 NB. exit without jhrajax
GUEST_jhs_=: 1

t=.  ":each <.each 60 60 1e6%~each 0".each <;._1 ' ',}:fread'/jguest/args'

tool_guest_rules_jijx_=: 0 : 0 hrplc_jhs_ 'LIMIT IDLE DULIM';t
A guest session runs JHS in your browser as front end to a J task on a linux server.

A good way to learn about J. Run tutorials and experiment before you take the step of
installing on your own machine.

A guest session ends when it:
•has run for <LIMIT> minutes
•is idle for <IDLE> minutes
•more disk than <DULIM> MB
•uses excessive resources
)

tool_guest_files_jijx_=: 0 : 0
☰.file >jcopy moves files between server and your machine.

All files created are deleted when the session ends.

~temp files can be carried forward to a new guest session.

Run sentence (... is your private choice of savedname):
   jgp'...'

If savedname exists, then its files are copied to the ~temp folder.

When the session ends, ~temp files are copied to savedname.
)

jgp_jhs_=: 3 : 0
name=. fread'jpersist.txt'
if. (8>#y)+.0~:#y-.AlphaNum_j_ do. NB. enforced in guest.js
 ferase'jpersist.txt'
 echo'must be at least 8 alphanumerics'
 echo LF,'no files copied when this session ends'
 return.
end.

if. 1~:ftype'jpersist.tgz' do.
  echo'no files to restore'
else.
 r=. shell'tar -xzvf jpersist.tgz'
 ferase'jpersist.tgz'
 r=. <;.2 r 
 s=. -/;#each jpath each'~temp';'~home'
 echo ;/:~(<'~temp/'),each s}.each r
end. 
echo LF,'~temp copied to ',name,' when session ends'
echo name,' required to restore in new session!'
)

jgp__=: jgp_jhs_

init_jhs_''
