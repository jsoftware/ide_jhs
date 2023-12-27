jhs guest server

$ ln -s j9.4/addons/ide/jhs/aws/aws-sh aws-sh

*** setup lan guest
firewall must allow nodeport!

$ start jconsole
   load'~addons/ide/jhs/guest/guest_util.ijs'
   man
   default''
   start'key'

code changes are moved by start'key' to /jguest by create_jguest''

*** aws guest
aws already has "$USER ALL=(ALL:ALL) NOPASSWD: ALL" in sudoers.d file to avoid guest-sudo-sh password 

build aws system if not already done
$ ./aws-sh bld frown

create aws guest stuff
$ ./aws-sh putr $HOME/git/addons/ide/jhs j9.4/addons/ide    - ec2-user jhs to latest
$ ./aws-sh ssh
$ ./jc '~addons/ide/jhs/guest/guest_util.ijs'   - running ec2_user code
   man
   default''
   start'key'   - copies ec2-user j9.4 to /jguest

*** pkexec
$ pkexec visudo can recover from damaged sudo
$ pkexec rm /etc/sudoers.d jguest

*** node debug
$ node inspect localhost:9229
desktop version 10.19.0 seems to be buggy with display of names
breakpoint exec('guests')
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
create aws machine
$ cd j9.4/addons/ide/jhs/aws
$ ./aws-sh clr
$ ./aws-sh bld frown

$ ./aws-sh run cloud-run-sh frown  # run node with server mods
# consider change cloud-bld-sh to not do run if parameter is elided

