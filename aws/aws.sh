#!/bin/bash
how="commands: 
 ?           - how to use this script
 clr         - remove old entry from known_hosts for new instance
 set a.b.c.d - write ip address to file - persistence - elastic ip!
 ssh
 get remote-file local-file
 put local-file  remote-file
 run command-to-run-on-remote
 bld logon-key
 pem path-to-cert-key-pem-files
"

pem=~/.ssh/jhs1-kp.pem

IFS=''
ip=`cat ~/.ssh/jhs_aws_ip.txt`

case $1 in

clr)
ssh-keygen -f ~/.ssh/known_hosts -R $ip # new instance will not match known_hosts - remove entry - security!
;;

set)
ip=$2
re='^(0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))\.){3}'
re+='0*(1?[0-9]{1,2}|2([‌​0-4][0-9]|5[0-5]))$'
if [[ ! $ip =~ $re ]]; then echo "invalid ip" ; exit 2 ; fi
echo $2 > ~/.ssh/jhs_aws_ip.txt 
;;

ssh)
ssh -i $pem ec2-user@$ip
;;

get)
scp -i $pem ec2-user@$ip:$2 $3
;;

put)
scp -i $pem $2  ec2-user@$ip:$3
;;

run)
ssh -i $pem ec2-user@$ip $2
;;

bld)
[ "$#" -ne 2 ] && echo "missing logon key parameter" && exit 1
./aws.sh put cloud-bld.sh
./aws.sh put cloud-run.sh
./aws.sh run ./cloud-bld.sh # build j and nodejs
./aws.sh run "./cloud-run.sh $2" # start JHS and nodejs
echo "starting JHS and nodejs..."
echo "browse to:"
echo "https://$ip:65101/jijx"
;;

# $2 is path to folder with key.pem and cert.pem files
pem)
[ "$#" -ne 2 ] && echo "missing path to key/cert .pem files" && exit 1
./aws.sh run "rm .ssh/key.pem"
./aws.sh run "rm .ssh/cert.pem"
./aws.sh put $2/key.pem  .ssh/key.pem
./aws.sh put $2/cert.pem .ssh/cert.pem
;;

cloud)
# install j
rm j9.4_linux64.tar.gz
wget -nv www.jsoftware.com/download/j9.4/install/j9.4_linux64.tar.gz
tar -zxf j9.4_linux64.tar.gz

# update j
rm jc
ln -s j9.4/bin/jconsole jc
./jc -js "load'pacman'" "'update'jpkg''" "'install'jpkg'all'" "exit''"

# put default self-signed certificates in .ssh
sudo cp j9.4/addons/ide/jhs/node/key.pem  .ssh
sudo cp j9.4/addons/ide/jhs/node/cert.pem .ssh
sudo chmod 644 .ssh/key.pem
sudo chmod 644 .ssh/cert.pem

# install nodejs
sudo yum -y install nodejs
echo `which node` > nodebin
;;

cloud_start)
./jc -js "load'~addons/ide/jhs/node.ijs'" "startJHS_jhs_''" "startNODE_jhs_ 65101 ; '.ssh' ; 'hownow'" "exit''"
;;

*)
echo "$how"
;;
esac
