NB. utils for aws instance
coclass'jaws'

NB. kill JHS/nodejs servers and restart
NB. key rerun key - logon key repeated to try to avoid typos
restart=: 4 : 0
'x and y must be same'assert x-:y
'key must not contain blank'assert -.' 'e. y
echo 'JHS/nodejs servers killed and restarted'
shell'./cloud-run.sh ',y,' &'
)

NB. see jijx menu jfile>jcopy for put/get services
NB. download 'a.tgz';'~user/temp/1.ijs'
NB. download 'b.tgz';'~user/config'
NB. tar file created on server in ~/uploads
NB.  and then downloaded to browser downloads folder
download=: 3 : 0
'name source'=. y
s=. jpath source
i=. s i: '/'
if. i=#s do.
 p=. ''
 s=. source
else.
 p=. dquote i{.s
 s=. }.i}.s
end. 
mkdir_j_'~/uploads'
file=. '~/uploads/',name
shell 'cd ',p,' && tar czf ',file,' ',dquote s
jhtml_jhs_ '<div contenteditable="false"><a href="<file>" download>download: <name></a>'rplc'<file>';file;'<name>';name
)

NB. shutdown args same as for terminal command shutdown
NB. shutdown 'now' or '+30' or '-c'
NB. terminate/stop instance - depending on instance shutdown behavior
shutdown=: 3 : 0
shell'sudo shutdown ',y
)

NB. hibernate instance - easy to restart with saved state
NB. eip costs start and it might be better to keep smaller machines running
hibernate=: 3 : 0
shell'sudo /etc/acpi/actions/sleep.sh button/sleep SBTN 00000080 00000000'
)

NB. install pip3/pandas/pyarrow - python3 already installed
NB. required for jdrt'pandas'
install_pandas=: 3 : 0
run'sudo yum -y install python3-pip'
run'pip3 install pandas'
run'pip3 install pyarrow'
)

install_git=: 3 : 0
run'sudo yum -y install git'
)

NB. create_swap '1G'
NB. swap 1G required for jdrt'pandas'
NB. https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-22-04
create_swap=: 3 : 0
er=. 'arg must be of form: nG for n GiB swap file'
er assert 2=#y
er assert 'G'={:y
er assert ({.y)e.'123456789'
'swap already exists'assert ''-:shell'swapon --show'
shell'sudo fallocate -l ',y,' /swapfile'
shell'sudo chmod 600 /swapfile'
shell'sudo mkswap /swapfile'
shell'sudo swapon /swapfile'
shell'swapon --show'
)

run=: 3 : 0
echo y
echo shell y
echo LF
)
