jhs guest server

use -sh instead of .sh so pacman will have LF eol on windows

*** setup lan guest server - firewall must allow nodeport!
$ start jconsole
   load'~addons/ide/jhs/guest/guest_util.ijs'
   man
   start'key' NB. does create_jguest

*** setup aws guest server
https://code.jsoftware.com/wiki/System/Installation/Cloud


$ . bin/aws.sh  # cd j9.x/addons/ide/jhs/aws

$ ./aws-sh set a.b.c.d # done once - copied from aws console

$ ./aws-sh clr
$ ./aws-sh bld j9.5

$ # following required if local git changes are required on server
$ ./aws-sh putr $HOME/git/addons/ide/jhs j9.5/addons/ide
$ ./aws-sh putr $HOME/git/addons/data/jd j9.5/addons/data

$ ./aws-sh ssh
$ec2-user ./jc 
   load'guest_util.ijs'

   create_swap_jaws_'2G' NB. create swap file if not already done

   man
   start'key' NB. does create_jguest

*** https cert
$ ./aws-sh lets-backup  - copy remote /etc/letsenrypt to local .ssh/server tar
$ ./aws-sh lets-restore - restore local backup tar to remote /etc/letsencrypt

certbot creates a cert (/etc/letsencrypt/) for a name (server.jsoftware.com)
 that links with to the certbot with http to port 80

create https certificate create - required for use without dire warnings
aws-sh bld installs letsencrypt certbot
add http 80 to aws sg for certbot - remove it after
$ec3-USER sudo certbot certonly --standalone # create /etc/letsencrypt
   eiverson@jsoftware.com
   server.jsoftware.com

*** node debug
$ node inspect localhost:9229
desktop version 10.19.0 seems to be buggy with display of names
debug> scripts
       sb('guest',xx)
       exec('jhsport')
       watch('postdata')

*** sudo
aws guest - does not require edit as it already has /etc/sudoers.d/90-cloud-init-users
ec2-user ALL=(ALL) NOPASSWD:ALL

lan guest requires edit to allow guest-sudo-sh to run - use visudo to add line:
eric     ALL=(ALL:ALL) NOPASSWD: /jguest/j/addons/ide/jhs/guest/guest-sudo-sh

$ pkexec visudo can recover from damaged sudo

*** p65002 ... users created as required by guest-sudo-sh
$ sudo userdel -r p65002

*** instance configs
t2.micro  1GiB ram
t2.small  1GiG ram           - 2 times the cost
t2.medium 4GiB ram -         - 4 times the cost

currently have 8G EBS with 2G swap
should increate this signifcanly (32Gib) and increase swap and --as= as well

*** performance
JKT:   10 timespacex '%. 1000 1000 ?@$0'
requires: prlimit --as=500000000

mint       0.116
t2.micro   0.515
ipad 701   0.260
iphone 701 0.872 
