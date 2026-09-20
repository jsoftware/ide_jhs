coclass'app04'
coinsert'jhs'

manapp=: 'jpage y must be '''''

0 : 0
css flex allows dynamic sizing
you can do almost any layout you can imagine
but it can be complicated!
you can do a lot with cut/paste from examples
serious use requires study of extensive online resources
)

HBS=: 0 : 0
NB. base div implicitly opened
         jhclose''
'title'  jhh1 'flex - jhtextarea'
         jhijs''                        NB. button to edit source script
'hbs'    jhb'show HBS'
'css'    jhb'show CSS'

jhflex 'ta'jhtextarea''  NB. wrap element in jhflexa and jhflexz

'footer' jhhn 3;'page footer'
)

CSS=: 0 : 0
#ta{<PS_FONTFIXED>;<PS_FLEX>}
)

NB. J code - initialize and handle events
ev_create=: 3 : 0 NB. called by page or browser to initialize locale
manapp assert ''-:y
t=. y jpagedefault ,LF,.~60 20$'silly text '
'must be text'assert 2=3!:0 t
jhcmds 'set ta *',t
)

ev_hbs_click=: 3 : 0
jhrcmds 'set ta *',HBS
)

ev_css_click=: 3 : 0
jhrcmds 'set ta *',CSS
)
