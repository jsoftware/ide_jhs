jhs guest server

*** ajax woes
403 ajax response causes location="jlogin"

confusion between server.html jlogin and jlogon and 403 response

*** guest run/test on local
jconsole
   load'~addons/ide/jhs/guest/guest_util.ijs'
   start nodeargs

browse: https://localhost:65101/

$ node inspect 127.0.0.1:9229
debug> scripts
       sb('guest',xx)
       exec('jhsport')
       watch('postdata')

*** p65002 ... users created as required by guest-sudo-sh
$ sudo userdel -r p65002

*** edit sudoers to allow sudo without password
$ sudo visudo
eric ALL=(ALL:ALL) NOPASSWD: /home/eric/git/addons/ide/jhs/guest-sudo-sh

*** build it
create aws machine
$ cd j9.4/addons/ide/jhs/aws
$ ./aws-sh clr
$ ./aws-sh bld frown
$ ~/git/jplay/put.sh
$ ./aws-sh run cloud-run-sh frown  # run node with server mods

# consider change cloud-bld-sh to not do run if parameter is elided

*** start nodejs server and jhs port servers
.ssh questions

#!./jc
# avoid .suffix so git/pacman preserve eol lf on windows
load'~addons/ide/jhs/node.ijs'
startJHS_jhs_ ''
startNODE_jhs_ 65101 ; '.ssh' ; {:ARGV NB. key
exit''

*** ssh
$ sudo adduser eric
$ sudo passwd eric
$ sudo cp -r * /home/eric
$ sudo cp -r .ssh /home/eric

$ sudo adduser port65002
$ sudo runuser port65002

$ must kill all user processes before userdel will work
$ userdel -r port65002
$ kill processes ; rm /home/port -r * ; rm hidden ; start jhs again

