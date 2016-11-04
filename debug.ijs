NB. JHS - debug
coclass'jhs'

studio_debug=: 0 : 0
debug facilities:
 suspend execution at stop or error
 examine/modify locals
 step/stepin/stepout/etc
 
practice with simple test cases before you need it for real!

   dbwatch'calendar'     NB. show definition with line numbers in tab
   dbsm'calendar 0 : 3'  NB. stop on lines monadic 0 and dyadic 3
   dbr 1             NB. debug enabled
   calendar 1        NB. suspend at line 0 - note 6 space prompt
   dbstepin''        NB. step into call of dyadic calendar
   dbrun''            NB. run to stop or error - note stop on line 3
   a                 NB. local value a
   dbstep''          NB. step to next line
   dbes''            NB. formatted stack display
   dbrun''           NB. run - to end as there are no stops and no error
   dbr 0             NB. debug disabled
   dbsm'~calendar'   NB. remove all calendar stops
   dbsm'help'        NB. documentation for db stop manager utility
)

dbsmhelp=: 0 : 0
   dbsm'name ... : ...'  - add monadic : dyadic stops
   dbsm'~...'            - remove stops starting with ...
   dbsm''                - display stops
)

dbcutback_z_=: 13!:19
dbstep_z_=:    13!:20
dbstepin_z_=:  13!:21
dbstepout_z_=: 13!:22

dbwatch_z_=: 3 : 0
('db_',y)jwatch'dbsd''',y,''''
)

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

NB. stop manager
NB. dbsm'~...'     - remove stops starting with ...
NB. dbsm'name n:n' - add stops
NB. dbsm''         - display stops
dbsm_z_=: 3 : 0
if. 'help'-:dltb y do. dbsmhelp_jhs_ return. end.
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

NB. formatted execution stack
dbes_z_=: 3 : 0
t=. 2}.13!:18'' NB. stack less top entry for dbes
len=. >./t i."1 ' '
t=. |."2[t
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
'locale: _',(>coname''),'_',LF,;|.r,each LF
)
