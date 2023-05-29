#!/bin/bash

pem=~/.ssh/ericaws.pem

IFS=''
ip=`cat ~/.ssh/jhs_aws_ip.txt`

case $1 in

clr)
ssh-keygen -f ~/.ssh/known_hosts -R $ip # new instance will not match known_hosts - remove entry - security!
;;

set)
ip=$1
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
./aws.sh put aws-utils.ijs
./aws.sh run ./cloud-bld.sh # build j and nodejs
./aws.sh run "./cloud-run.sh $2" # start JHS and nodejs
;;

# $2 is path to folder with key.pem and cert.pem files
https)
[ "$#" -ne 2 ] && echo "missing path to key/cert .pem files" && exit 1
./aws.sh run "rm .ssh/key.pem"
./aws.sh run "rm .ssh/cert.pem"
./aws.sh put $2/key.pem  .ssh/key.pem
./aws.sh put $2/cert.pem .ssh/cert.pem
;;

how)
while read line; do echo $line; done < aws-how.txt
;;

*)
while read line; do echo $line; done < aws.txt
;;

esac
