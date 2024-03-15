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
$ ./aws-sh clr  # required if a new instance to clear known hosts
$ ./aws-sh set a.b.c.d # done once - copied from aws console
$ ./aws-sh bld j9.5 # continue connecting? - yes if this is new instance

$ # following required if local git changes are required on server
$ ./aws-sh putr $HOME/git/addons/ide/jhs j9.5/addons/ide

$ # following required if new instance needs letsencrypt
$ ./aws-sh lets-restore # restore local backup tar to remote /etc/letsencrypt

$ ./aws-sh ssh
$ec2-user ./jc 
   load'guest_util.ijs'
   create_swap'2G' NB. create swap file if not already done
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
         cpus ram G                usd per/month
t2.micro 	1     1   6	   $0.011 	        8.34
t2.small 	1 	   2 	12 	$0.023 	       16.56
t2.medium 	2 	   4 	24 	$0.046 	       33.40
t2.large 	2 	   8 	36 	$0.0938 	       66.82
t2.xlarge 	4 	  16 	54 	$0.186 	      133.63
t3.xlarge 	4 	  16 	40% 	$0.167         120.24
m5zn.xlarge 4    16        $0.330         237.00

t2 are all the same processor (not very fast)
 .xxx are cpus and ram

currently have 8G EBS with 2G swap
should increate this signifcanly (32Gib) and increase swap and --as= as well

*** performance
JKT:   10 timespacex '%. 1000 1000 ?@$0'
requires: prlimit --as=500000000

0.116 mint-avx2
0.277 mint-no-avx
0.212 t2.micro-avx2
0.515 t2.micro-no-avx
0.260 ipad 701
0.872 iphone 701

0.149 m5zn-avx2
0.296 m5zn-no-avx2
0.355 m5-no-avx2

*** guest server big
m5zn.xlarge 4vcpu 16G ram
64G disk
32G swap

jhs2-template launch template
 amazon linux
 t2.xlarge
 jhs1-kp
 jhs1-sg
 64G storage gp3
 create swap 32G

