coclass'jlog'
coinsert'jhs'

NB. J lines run in jhs locale that define html for the page
HBS=: 0 : 0
        jhclose ''         NB. menu with close
'clear' jhb 'clear'        
'jlog'   jhtextarea  ''         NB. text field
)

NB. jpage (or url) calls to init page for browser
ev_create=: 3 : 0 
'jpage y must be empty' assert ''-:y
jhcmds ''
)

ev_clear_click=: 3 : 0
jhrcmds'set jlog *'
)

CSS=: 0 : 0
#jlog{width:100vw;height:100vh;}
*{font-family:PC_FONTFIXED;}
)
