coclass'app08'
coinsert'jhs'

man=: 'jpage y must be '''''

NB. override create, jev_get, saveonclose verbs to customize app

NB. html form definition
NB. html element id can be one part (pswd) or two parts (gn*up)
NB. gn*up (mid*sid) has gn main id and up secondary id
NB. J event handler is ev_mid_type
NB. easy to have a single handler for different events
HBS=:  0 : 0
        jhclose''                      NB. menu with close 
'head'  jhh1   'password'
        jhijs''                        NB. button to edit source script
        jhhr
'pswd'  jhspan '&nbsp;'                NB. pswd text - non-breaking space
        jhhr                           NB. html horizonatal rule
'len'   jhspan'length: ',":length
'gn*up' jhb'▲'                         NB. button to increase length
'gn*dn' jhb'▼'
'epy'   jhspan'entropy: '
        jhbr                           NB. html line break
'gn*sp' jhchk'%^& etc';0
'gn*uc' jhchk'uppercase';0
'gn*di' jhchk'digits';0
        jhbr
'gn'    jhb'generate'
'copy'  jhb'copy to clipboard'
        jhhr
'gn*sim'jhrad'simple css';1;'cssset' NB. csset radio button group
'gn*fan'jhrad'fancy css' ;0;'cssset'
        jhbr
        desc
)

length=: 10 NB. chars in password

NB. return pswd;entropy
gen=: 3 : 0
'lc uc di sp'=. (26}.Alpha_j_);(26{.Alpha_j_);'0123456789';'~!@#$%^&*()-=_+'
sud=. ;0".each getvs'gn*sp gn*uc gn*di' NB. sp uc di values from event
a=. lc,;sud#sp;uc;di                    NB. valid pswd chars
(a {~ ? length##a);<<.length*2^.#a
)

NB. jhrcmds finishes event handler with 0 or more commands
NB. that will be run in the browser
ev_gn_click=: 3 : 0
lastevent__=: NV NB. name/value pairs in event
length=: 10>.30<.length+('up'-:getv'jsid')-'dn'-:getv'jsid'
'p e'=. gen''
len=. 'set len  *length: ',":length
psw=. 'set pswd *',p
epy=. 'set epy  *entropy: ',":e
css=. 'css      *',(1=0".getv'gn*fan')#fancycss
jhrcmds  len;psw;epy;css NB. len;psw;css
)

ev_create=: 3 : 0 NB. called by page or browser to initialize locale
man assert ''-:y
jhcmds ''
)

ev_copy_click=: 3 : 0
jhrcmds'copy *',getv'pswd'
)

desc=: 0 : 0
<hr>Modeled after J602 app documented in
J wiki (User:Andrew_Nikitin/Literate).<br><br>
All events are passed to J handlers and no javascript code is required.<br><br>
Tab/browser close does not inform J server.
)

NB. html cascading style sheet - document look and feel
CSS=: 0 : 0
form{margin:0px 2px 2px 2px;}
*.jhtext{font-family:"monospace";}
)

fancycss=: 0 : 0
form{margin:0px 40px;}
#pswd{background-color:salmon;font-size:20px}
)
