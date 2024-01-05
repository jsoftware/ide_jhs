jhs guest server

*** setup lan guest
firewall must allow nodeport!

$ start jconsole
   load'~addons/ide/jhs/guest/guest_util.ijs'
   man
   default''
   start'key' NB. does create_jguest

*** setup aws guest

build aws system if not already done - see below

create aws guest stuff
$ cd j9.x/addons/ide/jhs/aws
$ ./aws-sh putr $HOME/git/addons/ide/jhs j9.x/addons/ide # only if local jhs has changes
$ ./aws-sh ssh
$ec2-user ./jc 
   load'~addons/ide/jhs/guest/guest_util.ijs'
   man
   default''
   start'key' NB. does create_jguest

*** pkexec
$ pkexec visudo can recover from damaged sudo

*** node debug
$ node inspect localhost:9229
desktop version 10.19.0 seems to be buggy with display of names
debug> scripts
       sb('guest',xx)
       exec('jhsport')
       watch('postdata')

*** sudo
lan guest requires edit to allow guest-sudo-sh to run - use visudo to add line:
eric     ALL=(ALL:ALL) NOPASSWD: /jguest/j/addons/ide/jhs/guest/guest-sudo-sh

aws guest - does not require edit as it already has /etc/sudoers.d/90-cloud-init-users
ec2-user ALL=(ALL) NOPASSWD:ALL

possibly automate - following works but chmod 440 fails
$ echo "$USER ALL=(ALL:ALL) NOPASSWD: /jguest/j/addons/ide/jhs/guest/guest-sudo-sh" | sudo tee /etc/sudoers.d/jguest

*** p65002 ... users created as required by guest-sudo-sh
$ sudo userdel -r p65002

*** build aws system
aws already has "$USER ALL=(ALL:ALL) NOPASSWD: ALL" in sudoers.d to avoid guest-sudo-sh password 

create aws machine
$ cd j9.x/addons/ide/jhs/aws
$ ./aws-sh clr
$ ./aws-sh bld frown

$ ./aws-sh run cloud-run-sh frown  # run node with server mods
# consider change cloud-bld-sh to not do run if parameter is elided
