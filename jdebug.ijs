NB. jhs debug page

0 : 0
z locale names
 dbx... prefix indicates JHS db verbs
 dbxx.. prefix indicates JHS db nouns

 dbxxerr - 13!:12'' - when dbx is run
 dbxxstk - 13!:13'' - when dbx is run

prior some late 9.7 fix a 13!:13'' could get an error for dbl (foo__dbl)
 that overwrote original error

avoid assert as this stuff runs with debug enabled

latent expressions update jdebug page
 13!:15 updates on suspension
  9!:27 updates when no suspension

9.6 changed 13!:13 to have only the monad or dyad defn
 also has some new cols
) 

NB. update jdebug page - called by debug or dbxup latent expression
NB. set dbxxerr and dbxxstk now for all subseguent users
dbx_z_=: 3 : 0
9!:29[0 NB. don't run twice
dbxxerr_z_=: 13!:12''
dbxxstk_z_=: 13!:13''
try.
 d=. getdata_jdebug_''
 NB. term display of last error if not stop
 if. 18~:dberr'' do.
  if. 0~:+/'*'=;8{"1 [dbxxstk do. jhtml_jhs_ '<div class="transient" style="color:red;">',( jhfroma_jhs_;}.each<;.2 dbxxerr),'</div>' end.
 end. 
 a=. jurlencode_jhs_ }:;JASEP_jhs_,~each d
 jjs_jhs_'var w= findwindowbyname("jdebug"); if(w==null) alert("required: debug page (term menu>system pages>debug)"); else w.update("',a,'");'
catch.
 echo 'error in jdebug',LF,dbxxerr
end. 
i.0 0
)

dbxup_z_=: 3 : 0
9!:27'dbx'''''
9!:29[1
y
)

NB. move > to line
dbxline_z_=: 3 : 0
n=. 0{::1{::dbxxstk
dbss (n,' * : * ;'),dbsq''
JMP_jdebug_=: 1 NB. get rid of all stops after jmp
13!:7 y
)

NB. clear stack
dbxreset_z_=: 3 : 0
if. 1<#13!:13'' do. NB. 13!:13 ok here
 dblxs'' NB. turn off db lx
 9!:27'dbxreset''''' NB. dbxup should allow dbxxstk
 9!:29[1
 dbcut''
else.
 dblxs'dbx''''' NB. turn on db lx
 dbxup''
end. 
)

dblxs'dbx''''[9!:29[0' NB. jhs debug latent expression

coclass'jdebug'
coinsert'jhs'

JMP=: 0 NB. flag to clear all stops for jmp
nosus=: 'no suspension'

HBS=: 0 : 0
jhmenu'debug'
'menu0'       jhmenugroup ''
'help'        jhmenuitem'help - shows in term'
'dbhelp'      jhmenuitem'standard library - shows in term'
'close'       jhmenuitem 'quit';'q'
jhmenugroupz''

'stops'    jhdiv'<STOPS>'
jhhr
'stack'    jhdiv '<STACK>'
'dbrun'    jhb'run'
'dbover'   jhb'thru'
'dbinto'   jhb'into'
'dbout'    jhb'out'
'dbcut'    jhb'cut'
'dbjmp'    jhb'>'
'val'      jhtext '';2
'dbreset'  jhb'reset'
'nox'      jhb'no x'
'dostack'  jhb'stack'
'dissect'  jhb'dissect'

jhresize''
'sel'      jhdiv'<FILES>'
)

help=: 0 : 0
x marks stops - click to set/unset
> marks current line

run  - run until error or stop or end
thru - run - temp stop on next line
into - run - temp stop in first called explicit defn 
out  - run - temp stop on next line in caller
cut  - run - temp stop on current line in caller
>    - move > to line in input field
reset- stack (dbs'') to be empty
no x - remove stops 

   dbxsm''           NB. stop manager
)

dostack=: 3 : 0
t=. '<div class="transient">'
t=. t,jhfroma stack 3
t=. t,'</div>'
jhtml t
i.0 0
)

dohelp=: 3 : 0
t=. '<div class="transient">'
t=. t,jhfroma help
t=. t,'</div>'
jhtml t
i.0 0
)

dodbhelp=: 3 : 0
t=. '<div class="transient">'
t=. t,jhfroma dbhelp
t=. t,'</div>'
jhtml t
i.0 0
)

CSS=: 0 : 0
form{margin:0px 2px 2px 2px;}
*.jhdiv{<PS_FONTCODE>}
*.jhspan{<PS_FONTCODE>}
*.jhab{<PS_FONTCODE>}
*.jhac{<PS_FONTCODE>text-decoration:none;background-color:aqua;} 
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
reply''
)

ev_dissect_click=: 3 : 0
jhrajax 'dissect ',quote ;ln{defn
)

dbxsm_usage=: 0 : 0
stops on blank or NB. lines do not work

   dbxsm''          NB. usage
   dbxsm [ name [ monad lines or * [ : dyad lines or *]]]
   dbxsm'f'         NB. remove f stops
   dbxsm'f *:*'     NB. stop f on all lines
   dbxsm'f 2 : 5 7' NB. stop f on monad 2 and dyad 5 7
   
   dbxsm'+'         NB. report stops
   dbxsm'-'         NB. remove all stops
)

splitind=: ('__'&E. (i.) 1:) ({. ; 2: }. }.) ] NB. split at first __

basename=: 3 : 0
n=. 0{::splitind y
('_'={:n){::n; ((}:n)i:'_'){.n NB. invalid name is allowed
)

dbxsm_z_=: 3 : 0
t=. dltb y
if. 0=#t do. dbxsm_usage_jdebug_ return. end.
if. '+'={.t do. >'''',~each(<'dbxsm'''),each dltb each <;._2 dltb dbsq'' return. end.
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
dbxsm'+'
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
t=. dbxxstk NB. dbxxstk
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

n=. +/0~:;1{"1 dbxxstk NB. dbxxstk
a=. (1<n)#LF,~(":n),' errors on stack'
a=. a,dbxxerr

r=. r;(":line);(jhfroma a);stps
)

NB. display error stack
stack=: 3 : 0
s=. }.dbxxstk NB. first engry is dbx
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
seebox fem,.name,.fln,.fld
)

jev_get=: 3 : 0
dbxxerr_z_=: 13!:12''
dbxxstk_z_=: }.13!:13'' NB. drop jev_get_jdebug_
'jdebug' jhrx (getcss''),(getjs''),gethbs'FILES CURLINE STACK STOPS';getdata''
)

reply=: 3 : 0
jhrajax }:;JASEP_jhs_,~each getdata_jdebug_''
)

ev_nox_click=: 3 : 0
monad clearstops namex
reply''
)

JS=: 0 : 0

var line;

function ev_body_load(){jresize();}

function ajax(ts)
{
 var t;
 jbyid("sel").innerHTML= ts[0];
 line= ts[1];
 jbyid("stack").innerHTML= ts[2];
 jbyid("stops").innerHTML= ts[3];
 t= jbyid("files*"+line); 
 if(null!=t) t.scrollIntoView({behavior: 'smooth', block: 'center'});

jresize(); //!

}

function update(ts){ajax(ts= decodeURIComponent(ts).split(JASEP));}

function jdoit(t)
{
 if("no suspension"==jbyid("stack").innerHTML) return;
 if(t=="dbxline")
 {
  v= parseInt(jbyid("val").value);
  v= " "+((isNaN(v)) ? 0 : v);
 }
 else
  v= "''";
 jijxrunx(t+" dbxup"+v,false);
}

function ev_body_load(){}
function ev_files_click() {jdoajax(["val"]);}
function ev_dbrun_click()    {jdoit('dbrun');}
function ev_dbover_click()   {jdoit('dbover');}
function ev_dbinto_click()   {jdoit('dbinto');}
function ev_dbout_click()    {jdoit('dbout');}
function ev_dbjmp_click()    {if(line!=jbyid("val").value) jdoit('dbxline');}
function ev_val_enter()      {ev_dbjmp_click();}
function ev_dbcut_click(){jdoit('dbcut');}
function ev_dbreset_click()  {jdoit('dbxreset');}
function ev_nox_click(){jdoajax();}
function ev_help_click(){jijxrunx("dohelp_jdebug_''");}
function ev_example_click(){jijxrunx("doexample_jdebug_''");}
function ev_nuvoc_click(){jijxrunx("jhswiki'nuvoc'");}
function ev_dbhelp_click(){jijxrunx("dodbhelp_jdebug_''");}
function ev_dostack_click(){jijxrunx("dostack_jdebug_''");}

function ev_dissect_click(){jdoajax([]);}
function ev_dissect_click_ajax(ts){jijxrunx(ts[0]);};
)
