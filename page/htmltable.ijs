coclass'htmltable'
coinsert'jhs'

HBS=: 0 : 0
jhclose'' NB. standard menu with close
jhh1'html table'
jhtablea
jhtr 'longer label:';('t*00'jhtext'';10);'a:'   ;'t*01'jhtext'';5
jhtr 'medium:'      ;('t*10'jhtext'';10);'bbbb:';'t*11'jhtext'';5
jhtr 'short:'       ;'t*20'jhtext'';10
jhtr ''             ;''             ;'dd:'  ;'t*31'jhtext'';5           
jhtablez
jhdemo''
)

create=: 3 : 0
'jdemo7'jhr''
)

NB. ev_create not defined - create in class with no object
jev_get=: create

NB. reset the one with the enter
ev_t_enter=: 3 : 0
jhrcmds 'set ',(getv'jmid'),'*',(getv'jsid'),' *reset'
)