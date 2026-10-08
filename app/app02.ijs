coclass'app02'
coinsert'jhs'

0 : 0
more html elements and event handlers
element id c*c1 has main id e and secondary id c1
clicking e*c1 calls ev_e_click (main id)
event handler can get secondary id with getv'jsid'
)

HBS=: 0 : 0
        jhclose ''
'title' jhh1    'html'
'b1'    jhb     'b1 flip t1'
'b2'    jhb     'b2 flip both'
'b3'    jhb     'error'
jhbr                  NB. jhbr_jhs_ is html '<b/>'
'e*t1'  jhtext  ''
'e*t2'  jhtext  ''
jhbr
'e*c1'  jhchk   'chk1'
'e*c2'  jhchk   'chk2';1
'e*r1'  jhrad   'rad1';0;'rg0' NB. rg0 is radio group 0
'e*r2'  jhrad   'rad2';1;'rg0'
'd1'    jhdiv   ''   NB. html division (or section) for html elements
)

report=: {{ 'mid sid type'=.getvs 'jmid jsid jtype'
t=. 'jmid jtype jsid: ',mid,' ',type,' ',sid,LF,'event: ev_',mid,'_',type
t=. t,LF,'NV has following name value pairs and getv''...'' gets a value'
'set d1 *','<hr/>',jhfroma t,LF,seebox NV }}
 
return=: {{ jhrcmds  (report'');boxopen y }}

NB. y is jpage arg
ev_create=: 3 : 0 
t=. (''-:y){::y;<'t1 def';'t2 def' NB. y or default
v=. (1=L. t)*.(2=#t)*.2=;3!:0 each t NB. validate 
'jpage y must be empty or similar to text1;text2' assert v
jhrcmds ('set e*t1 *',0{::t);'set e*t2 *',1{::t NB. browser commands
)

ev_b1_click=:  {{ return 'set e*t1 *',|.getv'e*t1' }}

ev_b2_click=: {{ return ('set e*t1 *',|.getv'e*t1');'set e*t2 *',|.getv'e*t2' }}

ev_b3_click=: {{ return return 'set badid *' }}

ev_e_click=: {{ return '' }} NB. called for all elements with main id e
ev_e_enter=: ev_e_click
