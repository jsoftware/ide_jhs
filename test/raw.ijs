coclass'raw'
coinsert'jhs'

HBS=: 0 : 0
'get' jhb   'get'
NB. 't1' jhtext 'adsf';20
' style="color:red;" placeholder="comments" ' jhfix 't1'jhtext 'adsf';20
't2' jhtext 'qwer';10
)

NB. ' style="color:red;" placeholder="comments" ' jhfix 't1'jhtext 'adsf';20


create=: 3 : 0
'raw' jhrx (getcss''),(getjs''),gethbs''
)

NB. called when browser gets this page
jev_get=: create

ev_get_click=: 3 : 0
echo NV
't1 t2'=. getvs't1 t2'
jhrcmds ('set t1 value *',8 u:|.7 u: t1);'set t2 value *',8 u:|.7 u: t2
)

ev_t1_enter=: ev_t2_enter=: ev_get_click

jhfix_jhs_=: 4 : 0
i=. y i.'>'
(i{.y),x,i}.y
)

CSS=: ''

JS=: ''
