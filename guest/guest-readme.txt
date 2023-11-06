jhs guest server

*** https and firewall must allow nodeport
browser: https://ip//nodeport/jserver

*** aws guest
normal aws bld and the setup-sh to create /jguest folders
setup-sh could be added to bld
aws bld frown
aws ssh
$ sudo j9.4/addons/ide/jhs/guest/setup-sh j9.4
aws already has "$USER ALL=(ALL:ALL) NOPASSWD: ALL" in sudoers.d file to avoid guest-sudo-sh password 

$ /jguest/j/bin/jconsole
   load'~addons/ide/jhs/guest/guest_util.ijs'
   start nodeargs

*** lan guest 
depends on firewall allowing nodeport!

$ sudo git/addons/ide/jhs/guest/setup-sh j9.4
note: /jguest/j/addons/ide/jhs -> git/addons/ide/jhs

jconsole
   load'~addons/ide/jhs/guest/guest_util.ijs'
   start nodeargs

browse: https://localhost:65101/

$ v
debug> scripts
       sb('guest',xx)
       exec('jhsport')
       watch('postdata')

*** pkexec
$ pkexec visudo can recover from damaged sudo
$ pkexec rm /etc/sudoers.d jguest

*** node debug
desktop version 10.19.0 seems to be buggy with display of names
breakpoint exec('guests')

*** sudo
lan guest requires edit to allow guest-sudo-sh to run - use visudo to add line:
eric     ALL=(ALL:ALL) NOPASSWD: /jguest/j/addons/ide/jhs/guest-sudo-sh

aws guest - does not require edit as it already has /etc/sudoers.d/90-cloud-init-users
ec2-user ALL=(ALL) NOPASSWD:ALL

possibly automate - following works but chmod 440 fails
$ echo "$USER ALL=(ALL:ALL) NOPASSWD: /jguest/j/addons/ide/jhs/guest-sudo-sh" | sudo tee /etc/sudoers.d/jguest

*** p65002 ... users created as required by guest-sudo-sh
$ sudo userdel -r p65002

*** build it
create aws machine
$ cd j9.4/addons/ide/jhs/aws
$ ./aws-sh clr
$ ./aws-sh bld frown
$ ~/git/jplay/put.sh
$ ./aws-sh run cloud-run-sh frown  # run node with server mods

# consider change cloud-bld-sh to not do run if parameter is elided

