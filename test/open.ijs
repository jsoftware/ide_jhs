NB. test open/jpage tab/window/jterm

uqs=: uqs_jhs_

opentest=: 3 : 0
'tab'         open_jhs_ 'jfile',uqs''
10 10 200 200 open_jhs_ 'jfile',uqs''
'jterm'       open_jhs_ 'jfile',uqs''
echo'should have opened jfile page as window/tab/jterm'
)

load'~addons/ide/jhs/app/app07.ijs'

jpagetest=: 3 : 0
t=. #conl 1
'app07;tab'   jpage''
'app07;jterm' jpage''
'app07;10 10' jpage''
'did not create 3 objects'assert 3=t-~#conl 1
echo'should have opened app07 3 times'
)