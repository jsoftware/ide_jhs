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
'status'jhb'Status'
'update' jhb'Update'
'inst'jhb 'Installed'
'upable'jhb'Upgradeable'
'notin'jhb 'Not Installed'
'<hr>'

jhresize''
'result' jhdiv'<RESULT>'
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

ev_upable_click=: 3 : 0
'update'jpkg'' NB. update to make current
d=. <;._2 seebox_jhs_ 'showupgrade'jpkg''
D__=: d
if. #d do.
 t=. 'upgrade'jhb'upgrade selected'
 t=. t,'<br><br>','select'jhselect d;(#d);0
 create 'Upgradeable<br><br>',t
else.
 create 'Upgradeable<br><br>No upgrades available.'
end.
)

ev_notin_click=: 3 : 0
'update'jpkg'' NB. update to make current
d=. <;._2 seebox_jhs_ 'shownotinstalled'jpkg''
t=. 'install'jhb'install selected'
t=. t,'<br><br>','select'jhselect d;10;0
create 'Not Installed<br><br>',t
)

ev_inst_click=: 3 : 0
'update'jpkg'' NB. update to make current
d=. <;._2 seebox_jhs_ 'showinstalled'jpkg''
t=. 'upgrade'jhb'upgrade selected'
t=. t,'remove'jhb'remove selected'
t=. t,'<br><br>','select'jhselect d;(#d);0
create 'Installed<br><br>',t
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
function evload(){if(jform.select) jform.select.focus();jresize();}
function ev_status_click(){jsubmit();}
function ev_update_click(){jsubmit();}
function ev_notin_click(){jsubmit();}
function ev_inst_click(){jsubmit();}
function ev_upable_click(){jsubmit();}
function ev_install_click(){jsubmit();}
function ev_upgrade_click(){jsubmit();}
function ev_remove_click(){jsubmit();}
)
