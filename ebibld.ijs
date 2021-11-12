NB. JHS is (unfortunately) not developed in the git/addons folder
NB. development is done in the ~addons folder
NB. and periodically is moved to the git/addons folder with the help of this script

NB. duplicated - be careful and fix
bup=: 3 : 0
p=. jpath y
t=. jpath'~/'
if. t-:(#t){.p do. p=. (#t)}.p end.
try.
 shell_jtask_'bin/bup ',p,' > bup.txt 2>&1'
catch.
 0 assert~fread'bup.txt'
end.
i.0 0
)

help=: 0 : 0

>git pull

  set'ide/jhs'
  dobup''           NB. backup up git and ~addons
  status''
  copy_dev_to_git'' NB. be very careful
  status''
  NB. manual update of git/addons/ide/jhs/manifest.ijs
  status''          NB. must be clean

  bump_version''
)

NB. set'ide/jhs'
set=: 3 : 0
'must not be empty'assert 0~:#y
devp=: '~addons/',y,'/'
gitp=: 'git/addons/',y,'/'
'not dev folder'assert 2=ftype devp
'not git folder'assert 2=ftype gitp
)

dobup=: 3 : 0
bup (}:devp),' ','before_push'
bup (}:gitp),' ','before_push'
)

rep=: 4 : 0
echo x
if. #y do. echo y else. echo ' ' end.
)

NB. status'ide/jhs'
status=: 3 : 0
'not dev folder'assert 2=ftype devp
'not git folder'assert 2=ftype gitp

NB. shell 'bin/bup ',}:devp
NB. shell 'bin/bup ',}:svnp

echo devp,'   >>>   ',gitp

dfiles=: /:~(#jpath devp)}.each {."1 dirtree devp
gfiles=: /:~(#jpath gitp)}.each {."1 dirtree gitp
gfiles=: gfiles-.'build.ijs';'grep.exe'

'git files not in dev'rep gfiles-.dfiles

'dev files not in git'rep dfiles-.gfiles

ddata=: fread each (<devp),each dfiles
gdata=: fread each (<gitp),each dfiles

cfiles=: (ddata~:gdata)#dfiles
'dev files not equal to git files'rep cfiles

load devp,'manifest.ijs'
mfiles=: /:~(<'manifest.ijs'),<;._2 FILES

'development files not in manifest'rep dfiles-.mfiles,<'ebibld.ijs'
'manifest files not in development'rep mfiles-.dfiles
)

bump_version=: 3 : 0
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

copy_dev_to_git=: 3 : 0
d=. fread  each (<devp),each cfiles
d   fwrite each (<gitp),each cfiles
)

copy_mfiles_git_to_dev=: 3 : 0
d=. fread  each (<gitp),each mfiles
d   fwrite each (<devp),each mfiles
)


cre8f=: 3 : 0
t=. jpath y
for_n. ('/'=t)#i.#t=. t,'/'  do.
  1!:5 :: [ <n{.t
end.
EMPTY
)