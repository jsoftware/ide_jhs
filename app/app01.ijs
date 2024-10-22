coclass'app01'
coinsert'jhs'

0 : 0
app (browser page) with a few hmtl elements and event handlers
)

manapp=: 'jpage y must be ''''' NB. doc jpage y arg

NB. J lines run in jhs locale that define html for the page
HBS=: 0 : 0
        jhclose ''          NB. menu with close
'title' jhh1    'overview'
'b1'    jhb     'button-one'
't1'    jhtext  ''          NB. text field
        jhijs   ''          NB. open defining script
)

NB. jpage (or url) calls to init page for browser
ev_create=: 3 : 0 
manapp assert ''-:y
jhrcmds 'set t1 *just loaded'  NB. browser command when page loads
)

NB. click b1 -> ev_b1_click -> jhrcmds returns cmd to browser -> browser runs cmd
ev_b1_click=: {{ jhrcmds 'set t1 *b1 clicked' }}

NB. enter in t1 -> ev_t1_enter -> jhrcmds returns cmd to browser -> browser runs cmd
ev_t1_enter=: {{ jhrcmds 'set t1 *enter in t1' }}
