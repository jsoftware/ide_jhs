NB. jhs debug page

0 : 0
z locale names
 dbx... prefix indicates JHS db verbs
 dbxx.. prefix indicates JHS db nouns

dbx - utility verb - dbx'' for usage
 
latent expressions update jdebug page
 13!:15 - dblxs - updates on suspension
  9!:27 - updates on return to immex

 dbxclear  - called by latent expression (9!:27)

prior some late 9.7 fix a 13!:13'' could get an error for dbl (foo__dbl)
 that overwrote original error

avoid assert as this stuff runs with debug enabled

9.6 changed 13!:13 to have only the monad or dyad defn - also has new cols
) 

3 :0''
if. 0~:nc<'dbxline_z_' do. dbxline_z_=: '' end.
)

NB. called by 9!:27 as set by dbup
dbxupdate_z_=: 3 : 0
9!:29[0 NB. don't run twice
a=. jurlencode_jhs_ }:;JASEP_jhs_,~each getdata_jdebug_''
jjs_jhs_'var w= findwindowbyname("jdebug"); if(w==null) alert("required: debug page (term menu>system pages>debug)"); else w.update("',a,'");'
)

NB. show locals in term
dbxlocals_z_=: 3 : 0
 try.
  s=. >{:1{dblocals'' NB. first 2 are dbx amd dbxlocals
  ns=. 0{"1 s
  ds=. 1{"1 s

  t=. ''
  for_i. i.#ds do.
   a=. 4 100 corner_jhs_>i{ds
   if. 1=+/LF=a do.
    t=. t,jhdiv_jhs_ (8{.;i{ns),' ',(jhfroma_jhs_ a)
   else.
    t=. t,jhdiv_jhs_ ;i{ns
    t=. t,jhdiv_jhs_ (jhfroma_jhs_ a)
   end. 
   t=. t,jhhr_jhs_
  end.
  jhtml_jhs_ jhdiv_jhs_ t;'transient'
 catch. 
  echo 'error in jdebug',LF,13!:12''
 end.
i.0 0
)

dbxup_z_=: 3 : 0
9!:27'dbxupdate'''''
9!:29[1
''
)

NB. move > to line
dbxgoto_z_=: 3 : 0
n=. 0{::1{::13!:13''
dbss (n,' * : * ;'),dbsq''
JMP_jdebug_=: 1 NB. get rid of all stops after jmp
dbjmp y
)

NB. clear stack
dbxreset_z_=: 3 : 0
if. 1<#13!:13'' do.
 9!:27'dbxreset'''''
 9!:29[1
 dbcut''
else.
 dbxup''
end. 
)

NB. display error stack
dbxstack_z_=: 3 : 0
s=. 2}.13!:13'' NB. first 2 are dbx amd dbxstack
'name en ln nc defn args'=. <"1 [ 0 1 2 3 4 6{|:s
fem=. en{'';9!:8''
fem=. (_6*(_6{.each fem)=<' error')}.each fem
args=. ;#each args

NB. class can be wrong for anonymous derived verb - fnc not included in display
fnc=. <"0 (nc+each (nc=<3)*args=2){'nacmd'
fln=. '[',each ((args=2){'';':'),        each(":each ln),each']'
d=. <;._2 each LF,~each defn
i=. ;>:each ln
i=. i<.<:;#each d NB. tacit verb has only 1 line
fld=. ;each i{each d
seebox_jhs_ fem,.name,.fln,.fld
)

coclass'jdebug'
coinsert'jhs'

HBS=: 0 : 0
jhmenu'debug'
'menu0'       jhmenugroup ''
'help'        jhmenuitem'help - shows in term'
'close'       jhmenuitem 'close';'x'
jhmenugroupz''

'debug'    jhb'debug'
'line'     jhtext '';50
'stops'    jhdiv'<STOPS>'
jhhr
'stack'    jhdiv '<STACK>'
'dbrun'    jhb'run'
'dbinto'   jhb'into'
'dbover'   jhb'over'
'dbout'    jhb'out'
'dbcut'    jhb'cut'
'dbjmp'    jhb'goto'
'val'      jhtext '0';2
'dbreset'  jhb'reset'
'dostack'  jhb'stack'
'dolocals' jhb'locals'
'dissect'  jhb'dissect'

jhflex 'sel'jhdiv'<FILES>'
)

CSS=: 0 : 0
*.jhdiv,.jhspan,.jhab,.jhac{<PS_FONTCODE>}
*.jhac{text-decoration:none;background-color:aqua;} 
#sel{PS_FLEX}  
)

JMP=: 0 NB. flag to clear all stops for jmp
nosus=: 'no suspension'

dostack=: 3 : 0
jhtml jhdiv (stack 3);'transient'
i.0 0
)

dolocals=: 3 : 0
jhtml jhdiv (dbxlocals'');'transient'
i.0 0
)

dohelp=: 3 : 0
jhtml jhdiv (jhfroma getdebug_jijx_'');'transient'
i.0 0
)

NB. x is current - -1 or d2 or m3
NB. jhab is changed to jhac for CSS aqua
buttons=: 3 : 0
'sl mid sids values sep'=. y
p=. ''
ww=. 3+#":#sids
for_i. i.#sids do.
 id=. mid,'*',' '-.~>i{sids
 a=. id jhab ww{.;i{values
 a=. a,'' jhspan jhfroma_jhs_ ww}.;i{values
 if. sl-:' '-.~>i{sids do.
  i=. 4+1 i.~'"jhab"'E.a
  a=. 'c' i}a
 end. 
 p=. p,a,sep
end.
)

ev_files_click=: 3 : 0
n=. 0".getv'jsid'
if. n e. stops do. stops=: stops-.n else. stops=: /:~stops,n end.
monad setstops namex
jhrajax }:;JASEP_jhs_,~each getdata_jdebug_''
)

ev_dissect_click=: 3 : 0
jhrajax 'dissect ',quote ;ln{defn
)

splitind=: ('__'&E. (i.) 1:) ({. ; 2: }. }.) ] NB. split at first __

basename=: 3 : 0
n=. 0{::splitind y
('_'={:n){::n; ((}:n)i:'_'){.n NB. invalid name is allowed
)

dbx_z_=: 3 : 0
t=. dltb y
if. 0=#t do. jselect_jhs_ jhshelp'debug keyboard' return. end.
i=. (t i.' ')
n=. }.i}.t
select. i{.t
case. 'line'do. dbxline_z_=: n 
case. 'debug' do. 
 if. 1<#13!:13'' do. 'stack not empty' return. end.
 if. 0~:#n do. dbxline_z_=: n end.
 formcmds_jdebug_ 'set line *',dbxline_z_
 9!:27 dbxline_z_,'[dbxup'''''
 9!:29[1

NB. ops with 9!:27
case. 'run'     do.
 9!:27'dbrun  dbxup'''''
 9!:29[1
case. 'goto'    do.
 if. ln_jdebug_=0".n do. i.0 0 return. end.
 9!:27'dbxgoto ',(":0".n),'[dbxup'''''
 9!:29[1
case. 'dissect' do.
 9!:27 'dissect ',quote ;ln_jdebug_{defn_jdebug_
 9!:29[1

NB. dbxup needed only when dbxls does not run
case. 'into'    do. dbinto dbxup''
case. 'over'    do. dbover dbxup''
case. 'out'     do. dbout  dbxup''
case. 'cut'     do. dbcut  dbxup''
case. 'reset'   do. dbxreset[ dbxup''

NB. ops that return results
case. 'stack'   do. dbxstack'' return.
case. 'locals'  do. dbxlocals'' return.
case. 'stop'    do. dbxstop n return.
case.           do. 'not a dbx op' return.
end.
i.0 0
)

dbxstop_z_=: 3 : 0
if. ';'e. y do.
 a=. (<;._2 y,';')-.a:
 for_b. a do. dbxstop ;b end.
 return.
end. 

t=. dltb y
if. 0=#t do. jselect_jhs_ jhshelp'debug stop manager' return. end.
if. '+'={.t do. >'''',~each(<'dbx'''),each dltb each (<'line ',dbxline_z_),(<'stop '),each<;._2 dltb dbsq'' return. end.
if. '-'={.t do. dbss'' return. end.

i=. t i.' '
d=. i}.t
n=. i{.t
if. -.('_'~:{:n) *. -.+./'__'E.n do. 'name must not have locale' return. end.
if. _2=nc<n do. 'invalid name' return. end.
i=. d i.':'
m=. deb i{.d
d=. deb }.i}.d
m=. (-.m-:,'*'){:: m;":~./:~_".m
d=. (-.d-:,'*'){:: d;":~./:~_".d
if. '_'e.m,d do. 'invalid number' return. end.
dbss (dbsq''),';',~n,' ',m,(0~:#d)#' : ',d
cleanstops_jdebug_''
dbxstop'+'
)

NB. keep last, discard empty, sort
cleanstops=: 3 : 0
t=. deb dbsq''
t=. <;.2 t,';'#~(0~:#t)*.';'~:{:t NB. add ; if not empty and not there
t=. t rplc each <':';' : ';';';' ; '
t=. ' ',~each deb each t

NB. keep last
n=. (t i.each' '){.each t
i=. n i: ~.n
t=. i{t

NB. discard emtpy
i=. t i.each ' '
a=. i}.each t
a=. a -.each <' :;'
t=. (0~:;#each a)#t

NB. sort
t=. t/:(t i.each' '){.each t
dbss;t
t
)

setstops=: 4 : 0
'm d'=. ":each getstops y
s=. (0=#(i.#defn)-.stops){::stops;'*'
if. x do. m=. ":s else. d=. ":s end.
a=. y,' ',(deb m),' : ',(deb d),';'
dbss a,~dbsq''
cleanstops''
)

clearstops=: 4 : 0
'm d'=. ":each getstops y
if. x do. m=. '' else. d=. '' end.
a=. y,' ',(deb m),' : ',(deb d),';'
dbss a,~dbsq''
cleanstops''
)

NB. y is name
NB. returns monad;dyad
NB. '' for no stops, '*' for all stops, 1 2 3 for those stops
getstops=: 3 : 0
t=. cleanstops''
i=. ((t i.each' '){.each t)i.<,y
if. i=#t do.
 '';''
else.
 t=. (#y)}.;i{t
 i=. t i.':'
 t=. t rplc':';' ';';';' '
 m=. deb i{.t
 d=. deb i}.t
 if. -.'*'e.m do. m=. /:~0".m end.
 if. -.'*'e.d do. d=. /:~0".d end.
 m;d
end. 
)

NB. stack - name,error,line,class,rep,script,args,locals,*
getdata=: 3 : 0
if. JMP do. JMP=: 0[dbss(>:';'i.~dbsq'')}.dbsq'' end.
cleanstops''
stps=. (0~:#dbsq''){::'no stops';dbsq''
t=. }.13!:13''
n=. +/0~:;1{"1 t
erron=. (1<n)#LF,~(":n),' errors on stack'

s=. ;8{"1 t
i=. s i. '*'
if. i=#s do. '';'';nosus;stps return. end.
s=. i{t
'n err line class args'=. 0 1 2 3 6{s
name=:  n
namex=: basename n
monad=: (class=3)*.1=#args
d=. <;._1 ;LF,;4{s
if. 1~:#d do.
  d=. }.}:d
  if. 3=class do.
    i=.d i.<,':'
    if. monad do.
      d=. i{.d
    else.
      if. (i+1)<#d do. d=. (i+1)}.d end. NB. 9.6 defn only has dyad defn
    end. 
  end.
end.

defn=: d
cdefn=. #defn
ln=: line

wid=. #":cdefn NB. width required for number line numbers
head=. wid":each i.cdefn
stops=: (-.monad){::getstops namex
stops=: ('*'e.stops){::stops;i.cdefn
e=. ((i.cdefn)e. stops){' x'
e=. <"0 e
c=. cdefn#' '
c=. <"0 '>' line}c
t=. head,each e, each c,each ' ',each defn
r=. buttons (":line);'files';(<head),(<t),<'<br>'

NB. e=. 1{::s
NB. try. a=. (<:(0=e){e,34){::9!:8'' catch. a=. ":e end.
NB. a=. (0{::s),'[',(':'#~-.monad),(":line),'] ',a

a=. erron,13!:12''
r=. r;(":line);(jhfroma a);stps
)

jev_get=: 3 : 0
dbr 1
dblxs'dbxupdate'''''
jsdata=: '"uninitialized"' NB. set jsdata so jhrcmds will set it 
jhrcmds'set line *',dbxline_z_
'jdebug' jhrx (getcss''),(getjs''),gethbs'FILES CURLINE STACK STOPS';getdata''
)

ev_close_click=: 3 : 0
dbr 0
dblxs''
jhrajax''
)

JS=: 0 : 0

function ajax(ts)
{
 var t;
 jbyid("sel").innerHTML= ts[0];
 jbyid("stack").innerHTML= ts[2];
 jbyid("stops").innerHTML= ts[3];
 t= jbyid("files*"+ts[1]); 
 if(null!=t) t.scrollIntoView({behavior: 'smooth', block: 'center'});
}

function update(ts){ajax(ts= decodeURIComponent(ts).split(JASEP));}

// jijxrunx works ev_into_click does not because update inside ajax request

function jdoit(t)
{
 if("no suspension"==jbyid("stack").innerHTML) return;
 jijxrunx("dbx'"+t+"'",false);
}

//function ev_body_load(){}
function ev_files_click() {jdoajax(["val"]);}

function ev_debug_click(){
 var t= 'debug '+jbyid('line').value;
 t= t.replaceAll("'","''");
 jijxrunx("dbx'"+t+"'",false);
 //jijxrunx("dbx "+t,false);
}
function ev_line_enter(){ev_debug_click();}

function ev_dbrun_click()  {jdoit('run');}
function ev_dbinto_click() {jdoit('into');}
function ev_dbover_click() {jdoit('over');}
function ev_dbout_click()  {jdoit('out');}
function ev_dbcut_click()  {jdoit('cut');}
function ev_dbreset_click(){jdoit('reset');}
function ev_dostack_click(){jdoit('stack');}
function ev_dolocals_click(){jdoit('locals');}

function ev_dissect_click(){jdoit('dissect');}

function ev_dbjmp_click()  {
  var v= parseInt(jbyid("val").value);
  jdoit('goto '+((isNaN(v)) ? 0 : v));
}
function ev_val_enter(){ev_dbjmp_click();}

function ev_help_click(){jijxrunx("dohelp_jdebug_''");}
function ev_dbhelp_click(){jijxrunx("dodbhelp_jdebug_''");}

// override jscore.js defs - to reset debug state
function ev_close_click() { jdoajax([]); }
function ev_close_click_ajax(){ winclose(); }
)
