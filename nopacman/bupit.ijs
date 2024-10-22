load'pacman'

NB. jhsalt folder has alternate jhs code
NB. dif between git code and jhsalt code
NB. switch jhs link to run alternate code

reload=: 3 : 0
load'~addons/ide/jhs/nopacman/bupit.ijs'
)

NB. get'pastebuptarfilenamehere'
NB. copy file to jhsalt/bup/ and untar
get=: {{
    fn=. deb 7}.y NB. drop prefix 'file://
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

NB. which JHS code
which=: 3 : 0
r=.shell'ls -l j9.5/addons/ide/jhs'
'jhs is not a link'assert 1=+/r=LF
i=. r i:'>'
}:2}.(i}.r)
)

NB. dif between git and jhsalt/bup
dif=: 3 : 0
shell'kdiff3 git/addons/ide/jhs jhsalt/bup/git/addons/ide/jhs' 
)

NB. set jhs link to run alternate jhs code
switch=: 3 : 0
old=. which''
echo old
select. y
case. 'git' do. t=. 'git/addons/ide/jhs'
case. 'bup' do. t=. 'jhsalt/bup/git/addons/ide/jhs'
case. 'pac' do. t=. 'jhsalt/pac/git/addons/ide/jhs'
case.       do. 'invalid arg'assert 0
end.
t=. jpath '~/',t
'that link already set'assert -.old-:t
ferase :: [ '~addons/ide/jhs'
shell'ln -s ',t,' ',jpath '~addons/ide/jhs'
which''
)

NB. from nopacman
jhs_create_symbolic_link=: 3 : 0
'already linked to ~Addons'assert 0=fexist'~addons/ide/jhs/.git'
 rmdir_j_ jpath'~addons/ide/jhs' NB. delete pacman ~addons folder
 hostcmd_j_ 'ln -s ',(jpath'~Addons/ide/jhs/'),' ',jpath '~addons/ide/jhs'
'link to ~Addons did not work'assert 1=fexist'~addons/ide/jhs/.git'
)
