dbr 1
dbxsm each 'f *:*';'g *';'h *';'adv *';'con *';'dyad :*';'nrr *'

dyad=: 3 : 0
:
x+y
)

f=: 3 : 0
a=. 2
a+y
:
a=. 3
a+x+y
)

g=: {{2+x f y}}

h=: {{23+2 f y}}

adv=: {{
a=. 2
;@:(<@u) y
}}

con=: 2 : '(u;.n) y'


nrr=: 3 : 0 NB. noun result was required
+
)

k=: 1 : 0
+
)

k2=: 3 : 0
:
x (2 k) y
)
