coclass'jdemo16'
coinsert'jhs'
NB. override create, jev_get, saveonclose verbs to customize app
title=: ;coname'' NB. tab title unless replaced by create or cojhs

NB. html form definition 
HBS=:  0 : 0
       jhclose''                      NB. redbar close    
       jhh1'pswd app - no javascript' NB. header 1
'pswd' jhspan '&nbsp;'                NB. pswd text - non-breaking space
       jhhr                           NB. html horizonatal rule
'len'  jhspan'length: ',":length
'up'   jhb'▲'                         NB. button to increase length
'dn'   jhb'▼'
'epy'  jhspan'entropy: '
       jhbr                           NB. html line break
'sp'   jhcheckbox'%^& etc';0
'uc'   jhcheckbox'uppercase';0
'di'   jhcheckbox'digits';0
       jhbr
'gen'  jhb'generate'
'copy' jhb'copy to clipboard'
       jhhr
'sim'  jhradio'simple css';1;'cssset' NB. csset radio button group
'fan'  jhradio'fancy css' ;0;'cssset'
       jhbr
       desc                         NB. desriptive text
       jhdemo''                     NB. link to open source script
)

NB. ids for id/value pairs for J handler with no javascript handler
JEVIDS=: jhjevids'pswd sp uc di sim fan'

length=: 10 NB. chars in password

gen=: 3 : 0
'lc uc di sp'=. (26}.Alpha_j_);(26{.Alpha_j_);'0123456789';'~!@#$%^&*()-=_+'
sud=. ;0".each getvs'sp uc di' NB. sp uc di values from event
a=. lc,;sud#sp;uc;di           NB. valid pswd chars
(a {~ ? length##a);<<.length*2^.#a
)

run=: 3 : 0
lastevent__=: NV NB. name/value pairs in event
length=: 10>.30<.length+('up'-:getv'jmid')-'dn'-:getv'jmid'
len=. 'set len *length: ',":length
'p e'=. gen''
psw=. 'set pswd *',p
epy=. 'set epy *entropy: ',":e
css=. 'css *',(1=0".getv'fan')#fancycss
jhrcmds  len;psw;epy;css NB. len;psw;css
)

ev_gen_click=: ev_sp_click=: ev_uc_click=: ev_di_click=: run
ev_sim_click=: ev_fan_click=: ev_up_click=: ev_dn_click=: run

ev_copy_click=: 3 : 0
jhrcmds'copy *',getv'pswd'
)

desc=: 0 : 0
<hr>Modeled after J602 app documented in
J wiki (User:Andrew_Nikitin/Literate).<br><br>
All events are passed to J handlers and no javascript code is required.<br><br>
Close with redbarclose or ctrl+\ as this informs J server and runs verb saveonclose.
Tab/browser close do not run saveonclose.
)

NB. html cascading style sheet - document look and feel
CSS=: 0 : 0
form{margin:0px 2px 2px 2px;}
*.jhtext{font-family:"monospace";}
)

fancycss=: 0 : 0
form{margin:0px 40px;}
*.jhb{padding: 2px 2px;margin:0px;background-color:aqua;color:red;border:0px;}
#pswd{background-color:salmon;font-size:20px}
)

JS=: JEVIDS,0 : 0
// add custom javascript code and event handlers here
)
