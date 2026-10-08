NB. validate app/page/demo scripts
validate=: 3 : 0
'ev_create not found'assert   'ev_create'vsub'app'
'create found'       assert -.'create'vsub'app'

'ev_create not found'assert   'ev_create'vsub'page'
'create found'       assert -.'create'vsub'page'

'ev_create found'assert -.'ev_create'vsub'demo'
NB. 'create not found'       assert   'create'vsub'demo'

a=. geth1_jijx_'~addons/ide/jhs/demo/jdemo*.ijs'
if. 0~:+/'no header'E.;{."1 a do.
 echo 'demo folder has files without jhh1'
end.
if. -.demo_order_jijx_-:/:~{:"1 a do.
 echo 'demo folder mistatch with order_demo'
end.
a=. geth1_jijx_'~addons/ide/jhs/app/app*.ijs'
if. 0~:+/'no header'E.;{."1 a do.
 echo 'app folder has files without jhh1'
end.
if. -.app_order_jijx_-:/:~{:"1 a do.
 echo 'app folder mistatch with order_app'
end.
i.0 0
)

vsub=: 4 : 0
d=. 1 dir '~addons/ide/jhs/',y
t=. <;.2 fread each d
(#d)=+/;+/each(<LF,x,'=:')E.each t
)

NB. display all menu shortcuts

msub=: 3 : 0
d=. 1 dir '~addons/ide/jhs'
for_a. d do.
 t=. <;.2 LF,~fread a
 b=. (;+/each(<'jhmenuitem')E.each t)*.(;+/each(<';')E.each t)
 if. +/b do.
  echo a
  echo ;b#t
 end. 
end.
)
