NB.! should be merged into ide/jhs/node.ijs (guest/node.ijs)

NB. utils for JHS guest server

nodeout=: '~temp/jhsnode/node.log'

rawlog=: 3 : 'fread nodeout'

guest_base=: 65002
guest_count=: 3
guest_ports=: guest_base+i.guest_count

start_jplay=: 3 : 0
shell_jtask_ :: [ 'sudo fuser --kill -n tcp ',":guest_ports
shell_jtask_'rm jc ; ln -s j9.4/bin/jconsole jc'

load'~addons/ide/jhs/guest/node.ijs' NB.! load'~addons/ide/jhs/node.ijs'
shell_jtask_'echo `which node` > nodebin'
startJHS_jhs_''

NB. startNODE_jhs_ 65101;'/home/eric/git/addons/ide/jhs/node';'frown';'--inspect';'/home/eric/git/jplay/guest'
    startNODE_jhs_ 65101;'/home/eric/git/addons/ide/jhs/node';'frown';'--inspect';'/home/eric/git/addons/ide/jhs/guest/server'
)
