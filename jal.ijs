NB. J HTTP Server - jal/pacman app
coclass'jal'
coinsert'jhs'
require'pacman'

jhostpath_j_=: jpath_j_ NB.! required by remove - temp fix

HBS=: 0 : 0
jhma''
 jhjmlink''
jhmz''

'<h1>J Active Library - pacman - Package Manager<h1>'
'<a href="http://www.jsoftware.com/jwiki/addons">www.jsoftware.com/jwiki/addons</a>'
'<hr>'
'status' jhb'status'
 'update' jhb'update'
 'notin'  jhb 'notin'
 'inst'   jhb 'inst'
'<hr>'
'result' jhdiv'<RESULT>'

'index' jhh''
)

create=: 3 : 0 NB. create - y replaces <RESULT> in body
'jal'jhr'RESULT';y
)

jev_get=: create

newp=: 3 : 0
create (toupper y),'<br><br>',(y jpkg'')rplc LF;'<br>'
)

ev_status_click=: 3 : 'newp''status'''
ev_update_click=: 3 : 'newp''update'''

ev_notin_click=: 3 : 0
'update'jpkg'' NB. update to make current
d=. <;._2 seebox_jhs_ 'shownotinstalled'jpkg''
t=. 'install'jhb'install selected'
t=. t,'<br><br>','select'jhsel d;(#d);0
create 'NOT INSTALLED<br><br>',t
)

ev_inst_click=: 3 : 0
'update'jpkg'' NB. update to make current
d=. <;._2 seebox_jhs_ 'showinstalled'jpkg''
t=. 'upgrade'jhb'upgrade selected'
t=. t,'remove'jhb'remove selected'
t=. t,'<br><br>','select'jhsel d;(#d);0
create 'INSTALLED<br><br>',t
)

doselect=: 3 : 0
create y jpkg (t i.' '){.t=. getv'select'
)

ev_install_click=: 3 : 0
doselect'install'
)

ev_upgrade_click=: 3 : 0
doselect'upgrade'
)

ev_remove_click=: 3 : 0
doselect'remove'
)

JS=: 0 : 0
function evload(){if(jform.select) jform.select.focus();}
function ev_select_click(){;} //jform.select.selectedIndex;
)
