man=: 0 : 0
compare jaaa to jbbb timings

nouns j602, j807, j970 used as paths for jconsole binary
test timings are appended to file results

   tests NB. test names
   wha   NB. display test wha

   jrun j602 NB. run j602 to add timings to file results
   jrun j970 NB. run j9.7.0
   report'j602 j970'

   doall'' NB. run tests on all version and report results
)

results=: 'results.txt'

timex=: 6!:2   NB. 602
require'files' NB. 602

j602=: 'j64-602/bin/jconsole'
j807=: 'j64-807/bin/jconsole'
j970=: 'j9.7/bin/jconsole'

NB. script to load in test jconsole
runload=: 'load\''',(jpath'~addons/ide/jhs/nopacman/timex/timex.ijs'),'\'''

doall=: 3 : 0
ferase results
jrun each j602;j807;j970
pyrun''
>report each 'j602 j807';'j602 j970';'j970 py3'
)

jrun=: 3 : 0
(y,' not path to jconsole binary')assert fexist y
t=. y,' -js ',runload,' runall\''\'' exit[0'
echo t
shell t
)

pyrun=: 3 :0
t=. 'python3 ', jpath'~addons/ide/jhs/nopacman/timex/timex.py'
echo t
shell t
)

tests=: ;:'mp wh ex'

NB. similar time in all versions
mp=: 3 : 0
m*m=. 1e8$5
)

NB. while loop
wh=: 3 : 0
a=. 1e7 NB. datatype int
while. a>0 do.
 a=. <:a
end.
)

NB. report 'j602 j970' 
report=: 3 : 0
'a b'=. '_',each ;:y
load results
t=. (tests,each <a),each'%',each tests,each<b
NB. ;LF,~each (6j2":each".each t),each ' ',each tests
(}.a),'%',(}.b),' ',_3}.;(<' ; '),~each tests,each (6j2":each".each t)
)

NB. run all tests
runall=: 3 : 0
run each tests
)

NB. run 'wh'
run=: 3 : 0
t=.  'timex ''',y,' 0'''
b=. ".t NB. run once to clear way for timing run
b=. ".t
a=. LF,~(y,'_',4{.'.'-.~(;{.<;._1 '/',9!:14'')),'=: ',":b
a fappend results
a
)

NB. ec"0 i.1000 with while 
ex=: 3 : 0
r=. ''
c=. 0
while. c<1000 do.
 r=. r, ec c
 c=. >:c
end. 
r
)

NB. collatzcount
ec =: 3 : 0
c =. 0
while. y > 1 do.
 c =. >: c
 if. 2|y do.
  y =. 1 + 3*y 
 else. y =. <. -: y
 end.
end.
c
)
