coclass'jdemo17'
coinsert'jhs'
NB. play with hamburger menu

jhmenu_jhs_=: 3 : 0
('menuburger'jhb'☰';'menuburger'),'menuclear'jhb'';'menuclear'
)

jhmenugroup_jhs_=: 4 : 0
'value back'=. y
more=. '<span class="menuspanleft" >',(jhfroma'<          '),'</span>'
t=. '<a href="#" class="menuitem" onclick="return menushow(''<BACK>'')" ><VALUE></a>'
t=. t hrplc 'BACK VALUE';back;more,jhfroma value
t,~'<div id="<ID>" class="menugroup">'rplc '<ID>';x
)

jhmenugroupz_jhs_=: 3 : '''</div>'''

NB. id jhmenuitem 'test';[more;esc] - more is '' or '>' ; esc is '' or single alphanumeric
jhmenuitem_jhs_=: 4 : 0
'text more esc'=: 3{.(boxopen y),'';''
'more parameter must be '''' or ''>'''assert (<more) e. '';'>'
more=. '<span class="menuspanleft" >',(;(more-:'>'){'&nbsp&nbsp;';'&gt&nbsp;'),'</span>'
esc=.  '<span class="menuspanright">',(;(#esc){'';'esc+',esc),'</span>'
t=. '<a id="<ID>" href="#" class="menuitem" onclick="return jev(event)" ><VALUE></a>'
t hrplc 'ID VALUE';x;more,(jhfroma text),esc
)

NB. id jhmenuitemto 'test';esc;tp - esc is '' or single alphanumeric - to is menu group id
jhmenuitemto_jhs_=: 3 : 0
'text esc to'=: 3{.(boxopen y),'';''
more=. '<span class="menuspanleft" >&gt&nbsp;</span>'
esc=.  '<span class="menuspanright">',(;(#esc){'';'esc+',esc),'</span>'
t=. '<a href="#" class="menuitem" onclick="return menushow(''<TO>'')" ><VALUE></a>'
t hrplc 'VALUE TO';(more,(jhfroma text),esc);to
)


NB. sentences that define html elements

HBS=: 0 : 0
jhmenu''

'menu0' jhmenugroup  'top';''
        jhmenuitemto 'apps';'w';'apps'
'tools' jhmenuitem   'tools'
        jhmenuitemto 'view';'';'view'
        jhmenuitemto 'tour';'';'tour'
        jhmenuitemto 'help';'?';'help'
'quit'  jhmenuitem   'quit'
jhmenugroupz''

'apps'  jhmenugroup'apps';'menu0'
'file'  jhmenuitem'file'
jhmenugroupz''

'view'  jhmenugroup'view';'menu0'
'wclear'jhmenuitem'clear window'
'rclear'jhmenuitem'clear refresh'
jhmenugroupz''

'foo'jhb'adsf'
jhbr
'goo'jhtextarea(,LF,.~100 10$'asdf adsf qrew qew rdasf a');40;80
)

CSS=: 0 : 0
)

NB. J code - initialize and handle events
create=: 3 : 0 NB. called by page or browser to initialize locale
t=. y jpagedefault 'this is default data'
'must be text'assert 2=3!:0 t
jsdata=: 'ta';t
)

jev_get=: jpageget NB. called by browser to load page


NB. javascript code
JS=: 0 : 0

mmshowing='';

function mmhide(e){jbyid(e).style.visibility= 'hidden';}
function mmshow(e){jbyid(e).style.visibility= 'visible';}

function ev_menuburger_click(){
 if(''==mmshowing)
 {
  mmshowing= 'menu0';
  mmshow(mmshowing);
  jbyid('menuclear').style.visibility= 'visible';
 }
 else
 {
  mmhide(mmshowing);
  mmshowing= '';
  jbyid('menuclear').style.visibility= 'hidden';
 }
}

function showmenu(m){
 jbyid(mmshowing).style.visibility= 'hidden';
 jbyid(m).style.visibility= 'visible';
 mmshowing= m;
}

function ev_to_apps_click(){showmenu('apps');}

function ev_menuclear_click(){ev_menuburger_click();}

function ev_w_shortcut(){alert('esc+w');}
 
function menushow(id){
 if(id=='') ev_menuburger_click(); else showmenu(id);
}

)
