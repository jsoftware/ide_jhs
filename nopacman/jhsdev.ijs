man=: 0 : 0
JHS development

editing/testing done with code in git/addons/ide/jhs

JHS runs with git code due to the following link:
...$ ln -s ~/git/addons/ide/jhs/ ~/j903/addons/ide/jhs

~Addons -> git/addons
~addons -> j90x/addons -> git/addons

git manifest version numbers should always increase
 so pacman update should never see that pacman update as required

force pacman update for testing pacman release by:
 bup'git/addons/ide/jhs'
 setp'ide/jhs'

 

 update manifest FILES
 bump manifest VERSION
 ...$ git pull
 ...$ git status
 start JHS
 delete jhs folder (the link to git/addon/ide/jhs)
 pacman update not installed
 shutdown/restart/test
 shutdown
 delete j903/addons/ide/jhs folder
 ...$ ln -s ... - restore testing from git
JHS is development/testing is done in git folder

pacman release requires:
 update manifest FILES
 bump manifest VERSION
 check git status etc
 git commit
 git push
 delete JHS folder with ln to git
 pacman not installed
 install not installed
 exit''
 start JHS and test
 exit''
 delete j90x/addons/ide/jhs folder
 ...$ ln -s ~/git/addons/ide/jhs/ ~/j903/addons/ide/jhs
 start JHS and test and verify new version
)