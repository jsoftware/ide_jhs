NB. start jhs guest on port
load'~addons/ide/jhs/core.ijs'
setbreak'node'
configdefault_jhs_''
PORT_jhs_=:0".;2{ARGV
AUTO_jhs_=:0
TIPX_jhs_=: 'g'
QRULES_jhs_=: 2 NB. exit without jhrajax

welcome_jhs_=: 0 : 0
<div>&nbsp;<font style="font-size:2em; color:red;" >JHS - Guest</font><br/>
<font style="color:red;" >
menu>?>guest&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- rules<br/>
menu>tour>overview - intro
</font></div>
)

t=.  ":each <.each 60%~each 0".each <;._1 ' ',}:fread'/jguest/args'

tool_guest_jijx_=: 0 : 0 rplc 'LIMIT';(0{t),'IDLE';2{t
A guest session runs JHS in your
browser as front end to J task
on a linux server.

A good way to learn about J.
Run tutorials and experiment
before you take the step of
installing on your own machine.

A guest session ends when it:
•has run for LIMIT minutes
•is idle for IDLE minutes
•uses excessive resources

All files created are deleted
when the session ends.

jijx menu>jbreak breaks a loop.

jijx menu>file>jcopy moves files
between server and browser.
)

init_jhs_''
