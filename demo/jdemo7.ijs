coclass'jdemo7'
coinsert'jhs'
demo=: 'jdemo7.ijs'

B=:  0 : 0
jdemo
'<h1>Table layout<h1>'

[{'longer label: '   ;t0}
 {'medium: '         ;t1}
 {'short: '          ;t2]
-
openijs     ^^
Ndesc
)

BIS=: 0 : 0
t0 ht'';20
t1 ht'';20
t2 ht'';20
jdemo   href'jdemo'
openijs hopenijs'Open script: ';(PATH,'demo/',demo);demo;''
)

create=: 3 : 0 NB. create - y replaces <RESULT> in body
hr 'jdemo7';(css'');(js'');(B getbody BIS) hrplc'RESULT';y
)

jev_get=: create



Ndesc=: 0 : 0
BISCORE_jhs_ defines [ { ; } ] to allow simple table layouts.
)

