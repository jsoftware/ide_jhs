load'~addons/ide/jhs/react/tictactoe/addj/reacttictactoe.ijs'

coclass'tictactoe'
coinsert'jhs'
title=: 'tictactoe'

desc=: 0 : 0
react is a javascript framework for building apps
https://react.dev/
react/tictactoe has react tictactoe code from codepen
react/tictactoe/addj has changes so J calculates plays
addj code runs in an iframe
)

NB. define html for the page
HBS=: 0 : 0
jhclose'react'
'desc'jhdiv desc
jhdivz
'<iframe id="react" src="reacttictactoe"  ></iframe>'
)

NB. id desc has variable font and preformatted white space
NB. id react takes all height and has scroll if necessary
CSS=: 0 : 0
#desc{font-family:<PC_FONTVARIABLE>;white-space:pre;}
#react{height:100%;overflow:scroll;}
)

ev_create=: 3 : 0 
jhcmds ''  NB. browser commands when page loads
)
