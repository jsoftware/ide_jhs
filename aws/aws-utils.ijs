coclass'jaws'

NB. utils for aws instance

NB. python3 already installed
install_pandas=: 3 : 0
run'sudo yum -y install python3-pip'
run'pip3 install pandas'
run'pip3 install pyarrow'
)

install_git=: 3 : 0
run'sudo yum -y install git'
)

NB. terminate/stop instance - depending on instance shutdown behavior
NB. would be nice to be able to be able to use time and extend time
shutdown=: 3 : 0
echo 'instance will terminate or stop - depending on instance setting shutdown behavior'
shell'sudo shutdown ',y
)


# hibernates instance
# costs for eip start and it may be more effective to keep smaller machines running
hibernate=: 3 : 0
shell'sudo /etc/acpi/actions/sleep.sh button/sleep SBTN 00000080 00000000'
)

download=: 3 : 0
jhtml_jhs_'<div contenteditable="false"><a href="xxx.txt" download>download: xxx.txt</a>'
)

NB. https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-22-04
NB. swap 1G required for jdrt'pandas'
create_swap=: 3 : 0
)

run=: 3 : 0
echo y
echo shell y
echo LF
)

