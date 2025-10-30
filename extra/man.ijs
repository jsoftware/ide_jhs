0 : 0
NBblock - contiguous lines that are 1 or more NB. lines , 0 or more blank lines , next line (=:)

NB*block - NBblock where first line starts with NB.*

   man'name' - report manblock for defining =:

   man script - extract all NB.*blocks from script

   man'locale?' - extract all NB.+blocks for scripts that defined the locale

script NBblock with first line start with NB.+ documents the script



NB.* marks NB.   


)

coclass'jman'

man_z_=: man_jman_

3 : 0''
if. 3~:nc<'jhrcmds_jhs_' do. NB. IFJHS not defined when script loaded
 NB. man in jqt and jconsole
 jselect_z_=: [
 edit_z_=: open_z_
end.
i.0 0
)

NB. install base9 library in ~system - so docs can be found
base9install=: 3 : 0
require'pacman'
a=. jpath'~system'
'r p'=. httpget_jpacman_ 'https://github.com/jsoftware/base9/archive/refs/heads/master.zip'
'download failed'assert 0=r
if. fexist a,'/base9' do.
  'r m'=. rmdir_j_ a,'/base9'
  ('remove old ~system/base9 folder failed: ',m) assert 0=r
end. 
hostcmd_jpacman_ 'unzip -o ',(dquote p),' -d ',dquote a
'base9-master not created'assert fexist a,'/base9-master'
(a,'/base9') frename (a,'/base9-master')
echo'base9 library installed in ~system'
)

base9installhelp=: 0 : 0
standard library scripts (e.g., in ~system)
are built from base library source files
and comments have been stripped out

man needs access to the base library source
to show those comments

to install base library in ~system/base9 run:

   base9install_jman_''
)

zloc=: <,'z'

NB. y is 'name' or 'name_abc_' or '_locale_' or file
NB.
NB. name is searched in all locales (or just abc) and if found
NB. the defining script is searched for the last defn line
NB. the block of NB. lines preceding the defn line
NB.  ignoring blank lines before the defn line
NB. and the defn line are included in the result
NB. 
NB. if name starts with - then search for name...
NB. if name starts with * then search for ...name...
NB. -* not supported for 'name_abc_'
NB.
NB. if name is defined in multiple scripts they are listed
NB. if script is in ~system the search continues in base9
NB.
NB. man'_abc_' - shows man line for each name in abc locale
NB. 
NB. man file - returns all NB. blocks starting with NB.*
NB. a following defn line with =: is included
NB. 
NB. base library, JHS, and others have NB. conventions
NB. that help with pulling documention from a script
NB. NB. block starting with NB.* indicates documentation
NB. for extraction and possible formating
NB. NB.* starts doc block
NB. JHS NB.*.n ... - n selects htmln css for the text
NB. 1 major section - 2 minor section - 3 sub section

man=: 3 : 0
erase'man_jpacman_' NB.! avoid 2 man defines
man_z_=: man_jman_ NB. erase might have man_z_

if. 0~:+/'./\'e. y do. manscript y return. end.
r=.  getman y
NB. remove NB.*blank and NB.blank 
r=. <;.2 r
b=. ;(<'NB.')=3{.each r
r=. (b*3)}.each r
jselect_jhs_ ;r
)

getman=: 3 : 0
n=. dltb y
if. '_'={.n do.
 t=. ('nl',n)~i.4
 t=. manfix t,each<n
 return.
end.
if. 0~:+./'__'E. n do. '__ not allowed in name' return. end.
if. -.'_'={:n do.
 NB. man'name' or '-name' or '*name'
 if. ({.n)e. '-*' do.
  r=. manall n
  if. 1<#r do. manfix r return. end.
  n=. ;r NB. only 1 found so get it
  n=. (_2{(n='_')#i.#n){.n NB. strip off locale
 end.
 t=. ('nl 0 1 2 3') doin conl 0
 t=. ('''',n,'''',' nl i.4') doin_jman_ conl 0
 t=. ;(<<n)e. each t
 t=. t#conl 0
 
 if. zloc e. t do.  NB. remove z if it just points to a defn in another locale
  if. '_'={:5!:5 <n,'_z_' do.
   t=. t -. zloc
  end.
 end.  
 
 if. 0=#t do. 'not found' return. end.
 if. 1<#t do. 
  tt=. (<n),each '_',each '_',~each t
  r=. ;LF,~each(<'   man'''),each '''',~each tt
  return.
 end.
 n=. n,'_',(;t),'_'
end.
i=. 4!:4<n
if. i<:0 do. 'not an explicit defn defined by loading a script' return. end. 
f=. i{4!:3''
bs=. '' NB. might be script leading to base9
t=. jpath'~system/'
if. t-: (#t){.;f do.
 NB. look for defn in base9
 bs=. ('   edit''',(;f),''''),LF NB. script leading to base9
 p=. jpath'~system/base9'
 if. -.fexist p do. base9installhelp return. end.
 dt=. {."1 dirtree p,'/*.ijs'
 dt=. dt-.<p,'/project/standalone.ijs' NB. standalone.ijs defines load_z_ etc
 for_f. dt do.
  r=. (fread f) manx n
  if. -.r-:'not found' do. r break. end.
 end.
else.
 bs=. '' NB. not script leading to base9
 r=. (fread f) manx n
end.
r=. '   ',n,LF,bs,('   edit''',(;f),''''),LF,(LF={.r)}.r
)

manfix=: 3 :0
;LF,~each(<''''),~each(<'   man'''),each y
)

NB. -abc - names that start with abc
NB. *abd - names that contain abc
manall=:3 : 0
n=. dltb y
n=. ('-'={.n)}.n
t=. ('''',n,'''',' nl i.4') doin_jman_ conl 0
b=. 0~:;#each t
t=. b#t
c=. b#conl 0
r=. ''
for_i. i.#t do.
 r=. r, (;i{t),each '_',each (i{c),each'_'
end. 
t;<c
r
)

manx=: 4 : 0
d=. x
p=. ('_'={:y){::y; ((}:y)i:'_'){.y 
nna=. '(^|[^[:alnum:]_])'
nnz=. '($|[^[:alnum:]_])' NB. .: removed
gass=. '[[:space:]]*=:'
b=.   (nna,p,gass) rxmatches_jregex_ d NB. name
b=. b,(nna,y,gass) rxmatches_jregex_ d NB. name_loc_
if. 0=#b do. 'not found' return. end.
i=. {.{:{:b/:b NB. use the latest in the file if more than 1
i=. i+LF=i{d
i=. +/LF=i{.d NB. lines up to defn

bdx=. <;._2 d,LF
bd=. dltb each bdx

t=. i{.bd NB. lines before defn
defn=. i{bd

msk=. 0=;#each t
bb=. +/(msk i: 0)}.msk NB. count of block of blank lines before defn
msk=. ;(<'NB.')=3{.each (-bb)}.t
bnb=. +/(msk i: 0)}.msk NB. count of block of NB. lines before defn
t=. (-bb+bnb){.t
t=. bnb{.t
r=. t,defn
r=. r,(1~:#b)#<'warning: reporting last of ',(":#b),' defns'
;r,each LF
)

doin=: 4 : '(<x)(4 : ''do__y x'')each<"0 y' NB. run sentence in each locale

manscript=: 3 : 0
r=. ''
d=. <;.2 LF,~fread y
bd=. dltb each d
bdp=. 4{.each bd
i=. 0
while. i<#bdp do.
 i=. i+(i}.bdp) i. <'NB.*' NB. start of next doc block
 if. i=#bdp do. ;r return. end.
 t=. i}.bdp
 a=. ((3{.each t)=<'NB.')i.0 NB. include NB. block
 t=. a}.t
 b=. (1=;#each (i+a)}.bd)i. 0 NB. blank block
 n=. a{.i}.d
 c=. (<'=:')e.;:;(i+a+b){d NB. next line included if it has =:
 c=. c *. '<'~:4{;{.n 
 i=. i+a+b+c 
 if. c do. n=. n,(i-1){d end.
 r=. r,n,<LF
end.
;r
)
