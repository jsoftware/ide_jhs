load'pacman'

man=: 0 : 0
manage multiple JHS versions - git / pacman original / tar snapshot

jhsalt folder has alternate jhs code
 jhsalt,'/pac/addons/ide/jhs' - original pacman -set by first which
 jhsalt,'/bup/git/addons/ide/jhs' - from tar of git source

dif'' NB. linux kdiff3 git vs jhsalt/bup

switch'...' NB. git/pac/bup - jhs link to alternate code

get'...' NB. path to backup tar of git/addons/ide/jhs
)

jhsalt=: 'jhsalt' NB. folder with alternate JHS source

asserts=: 3 : 0
'should be run in jconsole' assert -.IFJHS+.IFQT 
'jhsalt must be defined'assert 0=nc<'jhsalt'
'jhsalt folder must exist' assert fexist jhsalt
'~Addons must be defined in ~config/folders.ijs' assert fexist '~Addons/ide/jhs/core.ijs'
)

NB. which JHS code
which=: 3 : 0
asserts''
r=.shell'ls -l ',jpath'~addons/ide/jhs'
if. 1~:+/r=LF do.
 p=. jhsalt,'/pac/addons/ide'
 mkdir_j_ p 
 echo'jhs not a link - assume it is pacman version'
 echo'pacman version copied to: ',p
 shell 'cp -r ',(jpath'~addons/ide/jhs'),' ',p
 jpath'~addons/ide/jhs'
else. 
 i=. r i:'>'
 }:2}.(i}.r)
end. 
)

NB. set jhs link to run alternate JHS code
switch=: 3 : 0
asserts''
old=. which''
echo old
select. y
case. 'git' do. t=. 'git/addons/ide/jhs'
case. 'bup' do. t=. jhsalt,'/bup/git/addons/ide/jhs'
case. 'pac' do. t=. jhsalt,'/pac/addons/ide/jhs'
case.       do. 'invalid arg'assert 0
end.
t=. jpath '~/',t
if. t-:old do. 'already set to that link' return. end.
rmdir_j_ jpath'~addons/ide/jhs' NB. delete pacman ~addons folder
shell'ln -s ',t,' ',jpath '~addons/ide/jhs'
which''
)

NB. dif between git and jhsalt/bup
dif=: 3 : 0
shell'kdiff3 git/addons/ide/jhs jhsalt/bup/git/addons/ide/jhs' 
)

NB. get'pastebuptarfilenamehere'
NB. copy file to jhsalt/bup/ and untar
get=: {{
    asserts''
    fn=. dltb deb 7}.y NB. drop prefix 'file://
    echo fn
    'not tar.gz'assert '.tar.gz'-:_7{.fn
    name=. (fn i: '/')}.fn
    echo name
    t=. 'jhsalt/bup'
    rmdir_j_ :: [ t
    mkdir_j_ t
    (fread fn)fwrite t,name
     q=.'tar -xzf ',t,name,' -C ',t
     echo q
     shell q
}}
