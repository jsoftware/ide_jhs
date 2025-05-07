coclass'app01'
coinsert'jhs'

manapp=: 'jpage y must be ''''' NB. doc jpage y arg

NB. J lines run in jhs locale that define html for the page
HBS=: 0 : 0
        jhclose ''         NB. menu with close
'title' jhh1    'overview' NB. header size 1
        jhijs''            NB. button to edit source script
        jhhr               NB. horizontal rule
'b1'    jhb     'flip'     NB. button
't1'    jhtext  ''         NB. text field
)

NB. jpage (or url) calls to init page for browser
ev_create=: 3 : 0 
manapp assert ''-:y
jhcmds 'set t1 *just loaded'  NB. browser command when page loads
)

NB. click b1 -> ev_b1_click -> jhrcmds returns cmd to browser -> browser runs cmd
ev_b1_click=: {{ jhrcmds 'set t1 *',|.getv't1' }}

NB. enter in t1 -> ev_t1_enter -> jhrcmds returns cmd to browser -> browser runs cmd
ev_t1_enter=: {{ jhrcmds 'set t1 *enter in t1' }}
