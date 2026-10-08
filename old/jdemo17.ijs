coclass'jdemo17'
coinsert'jhs'
NB. play with hamburger menu

NB. sentences that define html elements
HBS=: 0 : 0
jhmenu''

'menu0' jhmenugroup'' NB. '☰';''
        jhmenulink   'apps';'apps galore'
'tools' jhmenuitem   'tools run'
        jhmenulink   'view';'view stuff'
        jhmenulink   'tour';'tour stuff'
        jhmenulink   'help';'help stuff'

'boo' jhb 'boo'
jhbr
'coo' jhb 'coo'
jhbr
'doo' jhb 'doo'
jhbr


'quit'  jhmenuitem   'quit'
jhmenugroupz''

'apps'  jhmenugroup''
'file'  jhmenuitem'file'
jhmenugroupz''

'view'  jhmenugroup''
        jhmenulink 'foo';'foo above'
'wclear'jhmenuitem'clear window'
'rclear'jhmenuitem'clear refresh'
jhmenugroupz''

'foo'   jhmenugroup'foo above';'view'
'funny' jhmenuitem'funny'
jhmenugroupz''

)

NB. J code - initialize and handle events
create=: 3 : 0 NB. called by page or browser to initialize locale
t=. y jpagedefault 'this is default data'
'must be text'assert 2=3!:0 t
jsdata=: 'ta';t
)

jev_get=: jpageget NB. called by browser to load page



