coclass'app01'
coinsert'jhs'

NB. HBS - lines run in _jhs_ that define html elements
HBS=: 0 : 0
jhclose '' NB. menu with close
'title' jhh1 'overview' NB. header size 1
'b1' jhb 'flip' NB. button
't1' jhtext '' NB. text field
)

NB. CSS - define how elements look
CSS=: 0 : 0
#t1{border:2px solid blue;} /* t1 element */
)

NB. event handlers
NB. NV is event name value pairs
NB. getv'abc' gets abc value
NB. jhrcmds sets cmds to run in browser 

NB. jpage (or url) calls to create page
ev_create=: 3 : 0 
'jpage y must be empty'assert''-:y
jhrcmds 'set t1 *just loaded'
)

NB. b1 click -> ev_b1_click -> browser cmds
ev_b1_click=: {{ jhrcmds 'set t1 *',|.getv't1' }}

NB. t1 enter -> ev_t1_enter -> browser cmds
ev_t1_enter=: {{ jhrcmds 'set t1 *enter in t1' }}
