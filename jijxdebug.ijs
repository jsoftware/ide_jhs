NB. jijx debug
coclass'jijx'
coinsert'jhs'

debugmenu=: 3 : 0
t=.   'debug'    jhmg'debug';1;8
t=. t,'dbstep'   jhmab'step     s^'
t=. t,'dbstepin' jhmab'step in  i^'
t=. t,'dbstepout'jhmab'step out o^'
t=. t,'dbcutback'jhmab'cut back'
t=. t,'dbrun'    jhmab'run'
t=. t,'dbon'     jhmab'on'
t=. t,'dboff'    jhmab'off'
)

ev_dbon_click=: 3 : 0
smoutput'debug on'
dbon''
)

ev_dboff_click=:   3 : 0
smoutput'debug off'
dboff''
)

ev_dbstep_click=:    3 : 'try. dbstep''''    catch. end. i.0 0'
ev_dbstepin_click=:  3 : 'try. dbstepin''''  catch. end. i.0 0'
ev_dbstepout_click=: 3 : 'try. dbstepout'''' catch. end. i.0 0'
ev_dbcutback_click=: 3 : 'try. dbcutback'''' catch. end. i.0 0'
ev_dbrun_click=:     3 : 'try. dbrun''''     catch. end. i.0 0'

dbon_z_=: 3 : 0
13!:15 'smoutput dbes dbestack_z_=:13!:18'''''
9!:27 '13!:0[1'
9!:29 [1
i.0 0
)

dboff_z_=: 3 : 0
13!:15 ''
9!:27 '13!:0[0'
9!:29 [1
i.0 0
)

dbcutback_z_=: 13!:19
dbstep_z_=:    13!:20
dbstepin_z_=:  13!:21
dbstepout_z_=: 13!:22

NB. display numbered explicit defn
dbsd_z_=: 3 : 0
if. -.1 2 3 e.~nc<y do. 'not an explicit definition' return. end.
raw=. 5!:5<y
t=.<;.2 LF,~raw
if. 1=#t do. '0 ',raw return. end.
i=.t i.<':',LF
if. ('3'={.raw)*.i~:#t do.
 j=. (_1,i.<:i),_1,(i.<:<:(#t)-i),_1
else.
 j=. _1,(i._2+#t),_1
end.
n=. ":each<"0 j
n=. a: ((n=<'_1')#i.#n)} n
n=. <"1 ' ',.~' ',.~>n
;n,each t
)

NB. debug stop manager
NB. dbsm'name'     - display numbered explicit defn
NB. dbsm'~...'     - remove stops starting with ...
NB. dbsm'name n:n' - add stops 
NB. dbsm''         - display stops
dbsm_z_=: 3 : 0
if. ('~'~:{.y)*.1=#;:y do. dbsd y return. end.
if.'~'={.y do.
 s=. deb each<;._2 (dbsq''),';'
 a=. }.y
 s=. (-.(<a)=(#a){.each s)#s
else.
 s=. deb each<;._2 (dbsq''),y,';'
end.
s=. ~./:~(s~:a:)#s
dbss ;s,each<' ; '
dbsq''
)

NB. show execution stack as set by last supension
dbes_z_=: 3 : 0
len=. >./dbestack i."1 ' '
t=. |."2[dbestack
r=. ''
while. #t do.
 d=. }.dtb{.t
 d=. (len>.#d){.d
 t=. }.t
 if. ' '~:1{d do.
  n=. dltb}.{.t
  if. 2~:#t do. n=. n rplc '    ';'' end.
  r=. r,<d,n
  t=. }.t
 else.
  r=. r,<d rplc '    ';''
 end.
end.
'_',(>coname''),'_',LF,;|.r,each LF
)

jsdebug=: 0 : 0
function ev_dbstep_click()   {jdoajax([]);}
function ev_dbstepin_click() {jdoajax([]);}
function ev_dbstepout_click(){jdoajax([]);}
function ev_dbcutback_click(){jdoajax([]);}
function ev_dbrun_click()    {jdoajax([]);}
function ev_dbon_click()     {jdoajax([]);}
function ev_dboff_click()    {jdoajax([]);}
function ev_s_shortcut(){jscdo("dbstep");}
function ev_i_shortcut(){jscdo("dbstepin");}
function ev_o_shortcut(){jscdo("dbstepout");}
)
