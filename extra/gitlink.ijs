NB. replace addons folder with link to git/dev/...

NB. * path-to-git-folder
NB. create link in !addons/... to git folder
gitlink=: 3 : 0
'must not have trailing /'assert '/'~:{:y
t=. jpath '~/',y
s=. (jpath'~addons'),(_2{(t='/')#i.#t)}.t
'target does not exist'assert 2=ftype t
'target not git repo'  assert 2=ftype t,'/.git'
'source does not exist'assert 2=ftype s
t=. dquote t
s=. dquote s
if. IFUNIX do.
 shell'rm -rf ',s
 shell'ln -s ',t,' ',s
else.
 t=. hostpathsep t
 s=. hostpathsep s
 shell::['rmdir ',t NB. delete if it is a sumlink
 shell::['rmdir /S /Q ',t NB. delete if it is a folder
 shell'mklink /D ',s,' ',t
end.
)

