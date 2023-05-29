coclass'jaws'

NB. python3 already installed
install_pandas=: 3 : 0
run'sudo yum -y install python3-pip'
run'pip3 install pandas'
run'pip3 install pyarrow'
)

install_git=: 3 : 0
run'sudo yum -y install git'
)

NB. stops instance if instance setting shutdown behavior is stop
NB. terminates instances if setting is terminate
NB. would be nice to be able to be able to use time and extend time
shutdown=: 3 : 0
shell'sudo shutdown now'
)

hibernate=: 3 : 0
shell'sudo /etc/acpi/actions/sleep.sh button/sleep SBTN 00000080 00000000'
)

download=: 3 : 0
jhtml_jhs_'<div contenteditable="false"><a href="xxx.txt" download>download: xxx.txt</a>'
)

run=: 3 : 0
echo y
echo shell y
echo LF
)

