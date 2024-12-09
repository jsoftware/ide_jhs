coclass'testselect'
coinsert'jhs'


NB. J lines run in jhs locale that define html for the page
HBS=: 0 : 0
         jhclose ''           NB. menu with close
'click'  jhselect('abc';'def';'ghi');10;1
'change' jhselect('123';'234';'345');10;1;'';'~'
'both'   jhselect('b1';'b2';'b3');10;1
't1'    jhtext  ''           NB. text field
)

NB. jpage (or url) calls to init page for browser
ev_create=: 3 : 0 
jhcmds ''
)

NB. click b1 -> ev_b1_click -> jhrcmds returns cmd to browser -> browser runs cmd
ev_b1_click=: {{ jhrcmds 'set t1 *b1 clicked' }}

NB. enter in t1 -> ev_t1_enter -> jhrcmds returns cmd to browser -> browser runs cmd
ev_t1_enter=: {{ jhrcmds 'set t1 *enter in t1' }}
