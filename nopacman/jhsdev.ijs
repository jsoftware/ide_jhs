jhs_create_symbolic_link=: 3 : 0
'already linked to ~Addons'assert 0=fexist'~addons/ide/jhs/.git'
 rmdir_j_ jpath'~addons/ide/jhs' NB. delete pacman ~addons folder
 hostcmd_j_ 'ln -s ',(jpath'~Addons/ide/jhs/'),' ',jpath '~addons/ide/jhs'
'link to ~Addons did not work'assert 1=fexist'~addons/ide/jhs/.git'
)

man=: 0 : 0
JHS development

editing/testing done with git/addons/ide/jhs

JHS runs with git code due to symbolic link set by: jhs_create_symbolic_link''

~Addons -> git/addons
~addons -> j90x/addons -> git/addons

git manifest version numbers should always increase
 so pacman update should never see that pacman update as required

*** pacman release build (from ~Addons/ide/jhs):
...$ cd ~
cd ~bin/buptar git/addons/ide/jhs

 ...$ cd git/addons/ide/jhs
 ...$ git pull
 ...$ git status - resolve problems

start J
   load'~Addons/ide/jhs/nopacman/jhsdev.ijs'
   setp'ide/jhs'
   manifest_status'' NB. edit manifest to resolve problems
   bump_version''

 ...$ git status
 ...$ git commit -a -m "pacman release ..."
 ...$ git push

*** test pacman build:
 menu>jpacman - so that it is loaded and will run after next ferase
 ferase'~addons/ide/jhs' NB. erase ln symbolic link file to git/addons/ide/jhs
 jijx>pacman>Not Installed
 check ide/jhs
 install selected

 shutdown/start/test

*** ln to ~Addons for development:
 start JHS
 jhs_create_symbolic_link''
)
