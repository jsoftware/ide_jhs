coclass'app6'
coinsert'jhs'

0 : 0
app6 shows how jev_get gets arg for setting initial state of page

global vars in app6 locale have arg for corresponding window id

for example,
   jev_get_data_NEW_app6_ - jev_get or F5 refresh window with id NEW
   jev_get_data_abc_app6_ - arg for window with id abc

in jijx - create new app6 page to display load verb:
   'NEW' app6 'load' NB. display in app6 window with id NEW

study app6__ use of gd_set_app6_ to set global that jev_get will use

study jev_get use of gd_get to get that arg for page customization

study ev_run_click use of gd_set to set new value for F5 refresh 
)

HBS=: 0 : 0
jhh1'explicit verb display - debug line numbers'
'run'jhb''
'name'jhtext'<NAME>';30
'<div id="data" class="jcode"><TEXT></div>'
)

CSS=: 0 : 0
form{margin:20px;}
)

jev_get_data_app6=: 'calendar' NB. default for jwid of app6

NB. browser reuested this page - execution of app6 verb or F5 refresh or url
NB. needs arg to replace <NAME> in name text box
NB. arg comes from app6 locale global of form: jev_get_data_JWID
NB. JWID is the window id set by windowopen
NB. gd_get gets the global arg
jev_get=: 3 : 0
s=. gd_get''
(getv'jwid') jhrx (getcss''),(getjs''),gethbs'NAME TEXT';s;jhtmlfroma dbsd s
)

NB. gd_set s - sets global to new value - F5 refresh will use new value
ev_run_click=: 3 : 0
s=. getv'name'
gd_set s
jhrajax jhtmlfroma dbsd s
)

NB. launch app6 from j
NB. jwid app6 name
NB. name is the jev_get arg - name of the verb to display
NB. jwid is the window id
NB. 'W'  app6 'load'
NB. gd_set sets app6 locale global as name to display
app6__=: 4 : 0
x gd_set_app6_ y
'app6'windowopen_jhs_ x
)

JS=: 0 : 0
function ev_run_click(){jdoajax(["name"]);}
function ev_run_click_ajax(ts){jbyid("data").innerHTML=ts[0];}
function ev_name_enter(){jscdo("run");}
)
