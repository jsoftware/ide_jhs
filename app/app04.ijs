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
'title'  jhh1 'css flex - ta textarea'
         jhijs''                        NB. button to edit source script
         jhhr
'hbs'    jhb'show HBS'
'css'    jhb'show CSS'

jhdivz NB. base div close - flex active
'foo'jhb'asdf'
'ta'     jhtextarea '' NB. textarea element is in flex area

jhdiva'' NB. base div open - flex inactive

'footer' jhhn 3;'page footer'
NB. base div implicitly closed
)

CSS=: 0 : 0
#ta{font-family:<PC_FONTFIXED>;resize:none;} /* id ta - fixed font - no resize handle */
#ta{width:100%;height:100%;}                 /* id ta - fill available space          */
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
