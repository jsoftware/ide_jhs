NB. j to jhs server

0 : 0

JHS task
   load'~addons/ide/jhs/jjserver.ijs'
   OKURL_jhs_=:     'jjserver'
   PASS_jjserver_=: 'fubar'
   
Other J task
   load'~addons/ide/jhs/jj.ijs'
   PASS_jj_=: 'fubar'
   'i.y'jhsdo 5
)   

require'tar'

coclass'jjserver'
coinsert'jhs'

PASS=: ''

jev_post_raw=: 3 : 0

try.
 d=. NV
 i=. d i. {.a.
 p=. i{.d
 'bad password'assert (0~:#PASS)*.p-:PASS
 d=. (>:i)}.d
 i=. d i. {.a.
 s=. i{.d
 d=. (>:i)}.d
 erase'y' NB. so do will see the global
 y__=: 3!:2 d
echo 'try';s;y__
 r=. 3!:1 do__ s
catch.
 r=. 13!:12''
end. 
'jbin' gsrcf r
erase'y__'
)
