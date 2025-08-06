coclass'app02'
coinsert'jhs'

0 : 0
more html elements and event handlers
element id c*c1 has main id e and secondary id c1
clicking e*c1 calls ev_e_click (main id)
event handler can get secondary id with getv'jsid'
)

manapp=: 'jpage y must be '''' or similar to ''text1'';''text2'''

HBS=: 0 : 0
        jhclose ''
'title' jhh1    'html'
        jhijs''                        NB. button to edit source script
        jhhr
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

ev_create=: 3 : 0 
y=. y jpagedefault 't1 default';'t2 default'
manapp assert (1=L. y)*.(2=#y)*.2=;3!:0 each y
jhcmds ('set e*t1 *',0{::y);'set e*t2 *',1{::y NB. browser commands when page loads
)

ev_b1_click=:  {{ return 'set e*t1 *',|.getv'e*t1' }}

ev_b2_click=: {{ return ('set e*t1 *',|.getv'e*t1');'set e*t2 *',|.getv'e*t2' }}

ev_b3_click=: {{ return return 'set badid *' }}

ev_e_click=: {{ return '' }} NB. called for all elements with main id e
ev_e_enter=: ev_e_click
