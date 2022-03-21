NB. tools for git to pacman release

NB. setp 'ide/jhs'
setp=: 3 : 0
t=. jpath'~Addons/',y,'/'
'not path to git manifest'assert t,'/manifest.ijs'
gitp=: t
)

NB. manifest_status ''
NB. setp must be run first - e.g. setp'ide/jhs'
NB. files in nopacman folder are not in the manifest
manifest_status=: 3 : 0
'gitp is not path to git manifest'assert gitp,'manifest.ijs'
f=. [: {."1 dirtree
gfiles=. f gitp
gfiles=. gfiles-.f gitp,'nopacman'
gfiles=. gfiles-.f gitp,'*.exe'
gfiles=. gfiles-.f gitp,'*.so'
gfiles=. gfiles-.f gitp,'*.dylib'
gfiles=. /:~(#gitp)}.each gfiles

load gitp,'manifest.ijs'
mfiles=. dltb each <;._2 FILES
dirs=. ('/'=;{:each mfiles)#mfiles
mfiles=. mfiles-.dirs
dirs=. ;{."1 each dirtree each  (<gitp),each dirs
dirs=. (#gitp)}.each dirs
mfiles=. /:~dirs,mfiles

if. gfiles-:mfiles do. echo 'manifest is current' return. end.

t=. gfiles-.mfiles
if. #t do.
 echo 'git files not in manifest'
 echo t
end.
t=. mfiles-.gfiles
if.  #t do.
 echo 'manifest files not in git'
 echo t
end.
)

NB. setp must be run first - e.g. setp'ide/jhs'
bump_version=: 3 : 0
'gitp is not path to git manifest'assert gitp,'manifest.ijs'
f=. gitp,'manifest.ijs'
m=. fread f
i=. 1 i.~'VERSION=: ' E. m
a=. i{.m
b=. i}.m
i=. b i. LF
n=. i{.b
echo'old: ',n
b=. i}.b
n=. (n i.' ')}.n
n=. n rplc '''';' ';'.';' '
n=. 0".n
'bad version'assert 3=#n
n=. (2{.n),>:{:n
n=. (":n)rplc' ';'.'
t=. 'VERSION=: ''',n,''''
echo 'new: ',t
m=. a,t,b
m fwrite f
EMPTY
)
