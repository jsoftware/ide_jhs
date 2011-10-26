NB. simple project manager and related tools

coclass'jsp'

spinit__   =: spinit_jsp_
sp__       =: sp_jsp_
spf__      =: spf_jsp_
spr__      =: spr_jsp_
spd__      =: spd_jsp_
speinit__  =: speinit_jsp_
spe__      =: spe_jsp_
spg__      =: spg_jsp_
spgf__     =: spgf_jsp_
spx__      =: spx_jsp_
spxinit__  =: spxinit_jsp_
sprunner__=: 3 : '0!:111 y'

sphelp__=: 0 : 0
spoverview has additional info

fr - file reference - filename or spr shortname or spr/spd/spg number

 spinit fr    set project and load (carried over sessions)
 sp 0         load project file
 ctrl+,       load project file
 sp fr        load file
 spr''        list recent files (carried over sessions)
 spf fr       fullpath
 spd folder   *.ijs in folder 

 speinit win;unix set editors (carried over sessions)
 speinit '"C:\Program Files (x86)\gedit\bin\gedit.exe"';'gedit'
 spe fr       edit file

 spg'pattern'[;'folder']
 spg''        grep with last pattern and folder
 spgf fr      pattern lines in file

 spxinit fr   set script for managed execution
 ctrl+/       advance
 spx''        advance
 spx 0        status
 spx n        run line n
)

spoverview__=: 0 : 0
sp utilties loaded when JHS starts (~addons/ide/jhs/sp.ijs).

Following shows how to use sp by example.

With desktop editor create ~temp/a.ijs and ~temp/b.ijs
each with a few J sentences.

   spinit '~temp/a.ijs' NB. set project file
   ctrl+,               NB. run project file
   spf '~temp/b.ijs'    NB. add to recent files
   spr ''               NB. list recent files
   spf 1000
   spf 'abc'
   sp  1000
   sp  'abc'
   spd '~temp'          NB. list ijs files in folder
   sp  number           NB. load file from spd number

spr shortname and spr/spd/spg number ease file references.

You can start the editor outside of J or from J.
speinit sets Windows and Unix editor that J will start.
Example assumes you have installed gedit in Windows.

NB.speinit win;unix
   speinit '"C:\Program Files (x86)\gedit\bin\gedit.exe"';'gedit'
   spe 0                NB. edit project file
   spe 'a'              NB. edit spr shortname a 
   spe number           NB. spr/spd/spg number

Search folder ijs files with grep.
Windows grep.exe is included in JHS package for convenience.

NB.spg pattern;folder
   spg '=:';'~temp'
   spgf fr              NB. search for pattern in file

Managed execution of a script can be useful.
Create ~temp/c.ijs with NB. lines, =: lines, and multiline defns

   spxinit'~temp/c.ijs' NB. set script for managed execution
   ctrl+/               NB. execute next
   spx 0                NB. status
)

MAXRECENT=: 20 NB. max recent files 
RECENTN  =: 1000
SPDN     =: 2000
GREPN    =: 3000
sprecentf=: '~temp/sp/recent.txt'
spspf    =: '~temp/sp/sp.txt'
spspef   =: '~temp/sp/editor.txt'
GREPPERS =: (jpath'~addons/ide/jhs/grep.exe');'grep'

cfile=: 3 : 0
t=. fread y
>(_1-:t){t;''
)

spinit=: 3 : 0
t=. spf y
assert. (fexist t)['must exist'
SPFILE=: t
t fwrite spspf
sp 0
)

sp=: 3 : 0
smoutput 'load: ',t=.spf y
load__ t
)

NB. spf file - shortname longname number
spf=: 3 : 0
if. 0-:y do. spf SPFILE return. end.
if. 1-:y do. spf SPXFILE return. end.
if. 4=3!:0 y do.
 assert. 1=#y['not single file number'
 if. (y>:SPDN)*.(y-SPDN)<#SPDFILES do.
  f=. >(y-SPDN){SPDFILES
 elseif. (y>:GREPN)*.(y-GREPN)<#GREPFILES do.
  f=. >(y-GREPN){GREPFILES
 elseif. (y>:RECENTN)*.(y-RECENTN)<#RECENTFILES do.
  f=. >(y-RECENTN){RECENTFILES
 end.
 spf f
 return.
end.
assert. 2=3!:0 y['not string'
if. +./y e.'~/.' do.
 assert. ('.ijs'-:_4{.y)['not ijs'
 t=. RECENTFILES
 t=. ~.t,~<y
 t=. (MAXRECENT<.#t){.t
 RECENTFILES=: t
 (;t,each LF) fwrite sprecentf
 y
elseif. 1 do.
 s=. shorts RECENTFILES
 b=. RECENTFILES
 c=. s=<,y
 if. 0=+/c do.
  assert. 0['shortname not found'
 elseif. 1=+/c do.
  ,>c#b
 elseif. 1 do.
  smoutput seebox_jhs_     (c#":each<"0 i.#t),.(c#s),.c#b
  assert. 0['multiples'
 end.
end.
)

shorts=: 3 : 0
t=. '/',each y
_4}.each(>:>t i:each '/')}.each t
)

spr=: 3 : 0
seebox_jhs_ RECENTN numit RECENTFILES
)

spd=: 3 : 0
if. ''-:y do. SPDFILES=: '' return. end.
SPDFILES=: (<'/',~y),each (>:#jpath y)}.each {."1 dirtree y,'/*.ijs'
seebox_jhs_ SPDN numit SPDFILES
)

speinit=: 3 : 0
assert. 2=#y['must give windows;unix editors'
EDITX =: >IFUNIX{y
(;LF,~each y) fwrite spspef
i.0 0
)

spe=: 3 : 0
assert. 0~:#EDITX['no editor set - speinit required'
smoutput f=. spf y
fork_jtask_ EDITX,' "',(jpath f),'"',EDITXTAIL
)

spg=: 3 : 0
'-c --include=*.ijs -R -F' spg y
:
if. -.''-:y do.
 select. #a=. boxopen y
 case. 1 do.
  'SPGPATTERN'=: y
 case. 2 do.
  'SPGPATTERN SPGFOLDER'=: a
 case. do. smoutput 'too many args' return.
 end.
end.
p=. jpath SPGFOLDER
g=. GREPX,' ',x,' "',SPGPATTERN,'" "',p,'"'
try. NB. unix grep finding nothing gives interface error???
 t=. <;._2 spawn_jtask_ g
catch.
 t=. ''
end.
i=. t i: each ':'
c=. >".each (>:>i)}.each t
t=. i{.each t
t=. (>:#p)}.each t
t=. (0~:c)#t
c=. (0~:c)#c
s=. \:c
t=. s{t
GREPFILES=: t,~each'/',~each<SPGFOLDER
c=. s{c
c=. <"1' ',.~2j0":,.c
t=. c,each t
('grep',(#GREPX)}.g),LF,seebox_jhs_ GREPN numit t
)

spgf=: 3 : 0"0
f=. spf y
t=. GREPX,' -n -F "',SPGPATTERN,'" "',(jpath f),'"'
t=. <;.2 spawn_jtask_ t
i=. t i. each ':'
c=. 4j0":each ".each i{.each t
t=. (>:>i)}.each t
f,LF,;c,each,' ',each t
)

numit=: 4 : 0
(":each<"0 x+i.#y),.(shorts y),.y
)

spxinit=: 3 : 0
assert. fexist spf y['must exist'
SPXFILE=: spf y
SEM=: get SPXFILE
SEMN=: 1
status''
i.0 0
)

spx=: 3 : 0
if. -.fexist SPXFILE do. smoutput 'not initialized - do spxinit' return. end.
if. ''-:y do. spx SEMN return. end.
if. 0-:y do. status'' return. end.
d=. SEM
SEM=:get SPXFILE
if. -.d-:SEM do.
 status''
 smoutput'file changed!'
 return.
end.
if. (0~:$$y)+.-.(3!:0[4) e. 1 4 do. smoutput 'arg not index' return. end.
SEMN=: y
label_top.
if. SEMN>:#SEM do. 'end of script' return. end.
ndx=. <:SEMN
d=. >ndx{SEM
if. 0=#d-.' ' do. SEMN=:>:SEMN goto_top. end.

NB. collect : lines
if. iscolon d do.
 c=. (dltb each ndx}.SEM) i. <,')'
 d=. ;LF,~each (ndx+i.>:c){SEM
 ndx=. ndx+c
end.

NB. collect comment lines
if. isnb d do.
 c=. (>(3{.each dltb each ndx}.SEM) -: each <'NB.')i.0
 d=. ;LF,~each (ndx+i.c){SEM
 ndx=. ndx+<:c
end.

NB.! kludge to convert =. tp =:
i=. d i.LF
t=. i{.d
if. (<'=.')e.;:t do.
 d=. (t rplc '=.';'=:'),i}.d
end.
sprunner__ d
SEMN=: 2+ndx
SEMN=: SEMN-SEMN>#SEM
if. (SEMN<#SEMN)*.'NB.'-:3{.dlb d do. goto_top. end.
i.0 0
)

iscolon=: 3 : 0
t=. ;:y
if. (<'define')e.t do. 1 return. end.
NB.! vstar - detect AS '(' at end of line
if. (_2{.i.#t)-:t i.;:'AS ''(''' do. 1 return. end. 
i=. t i. <,':'
(,each':';'0')-:(i+0 1){t,'';''
)

isnb=: 3 : 0
'NB.'-:3{.dltb y
)

get=: 3 : 0
d=. toJ fread y
d=. d,(LF~:{:d)#LF
<;._2 d
)

status=: 3 : 0
smoutput (":SEMN),' of ',(":#SEM),' in  ',SPXFILE
)

3 : 0''
try.
if. _1=nc<'initialized' do. 
 1!:5 :: [ <jpath '~temp/sp'
 SPFILE     =: cfile spspf
 RECENTFILES=: <;._2 cfile sprecentf
 SPDFILES   =: ''
 GREPFILES  =: ''
 SPGPATTERN =: ''
 SPGFOLDER  =: '~system' 
 SPXFILE    =: ''
 SEMN       =: 0
 t=. cfile spspef
 t=. >(''-:t){t;2#LF
 EDITX      =: >IFUNIX{<;._2 t
 EDITXTAIL  =: >IFUNIX{'';' &'
 GREPX      =: >IFUNIX{GREPPERS
end.
initialized=: 1
catch.
 smoutput'sp initialization failed'
end.
i.0 0
)

0 : 0
bind -s ^E "sp''\n"
bind -s ^R "spx''\n"
editrc fwrite '~home/.editrc'
)

