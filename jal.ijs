NB. J HTTP Server - jijx app
coclass'jal'
coinsert'jhs'
require'pacman'

jhostpath_j_=: jpath_j_ NB.! required by remove - temp fix

jev_get=: create

B=:  0 : 0
jide
'<h1>J Active Library - pacman - Package Manager<h1>'
wiki                     ^^
status update notin inst ^^
result
index
)

BIS=: 0 : 0
wiki   '<a href="http://www.jsoftware.com/jwiki/addons">www.jsoftware.com/jwiki/addons</a>'
status hb'status'
update hb'update'
notin  hb'not installed'
inst   hb'installed'
result '<span>&nbsp;<RESULT></div>'
index  hh''
)

create=: 3 : 0 NB. create - y replaces <RESULT> in body
hr 'jdemo1';(css'');(js JS);(B getbody BIS) hrplc'RESULT';y
)

newp=: 3 : 0
create (toupper y),'<br><br>',(y jpkg'')rplc LF;'<br>'
)

ev_status_click=: 3 : 'newp''status'''
ev_update_click=: 3 : 'newp''update'''

ev_notin_click=: 3 : 0
'update'jpkg'' NB. update to make current
d=. <;._2 seebox_jhs_ 'shownotinstalled'jpkg''
ID=: 'install'
t=. hb'install selected'
ID=: 'select' NB.! implicit arg not nice in this use
t=. t,'<br><br>',hsel d;(#d);0
create 'NOT INSTALLED<br><br>',t
)

ev_inst_click=: 3 : 0
'update'jpkg'' NB. update to make current
d=. <;._2 seebox_jhs_ 'showinstalled'jpkg''
ID=: 'upgrade'
t=. hb'upgrade selected'
ID=: 'remove'
t=. t,hb'remove selected'
ID=: 'select' NB.! implicit arg not nice in this use
t=. t,'<br><br>',hsel d;(#d);0
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
