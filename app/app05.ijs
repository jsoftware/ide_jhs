coclass'app05'
coinsert'jhs'

HBS=: 0 : 0
NB. base div implicity opened
      jhclose''
'title'  jhh1 'css flex - ta beside tb'
'hbs'    jhb  'show HBS'
'css'    jhb  'show CSS'

jhdivz NB. base div close - flex active

'jflexrow'jhdiva''      NB. allow side by side resizing
      'ta'jhtextarea''
      'tb'jhtextarea''
jhdivz NB. close jflexrow div

jhdiva'' NB. base div open - flex inactive

'footer'jhhn 3;'page footer'
NB. base div implicity closed
)

CSS=: 0 : 0
#ta{<PS_FONTCODE>;resize:none;} /* code font - no resize handle */
#tb{<PS_FONTCODE>;resize:none;} /* code font - no resize handle */
#ta{width: 50%;height:100%;} /* fill available space */
#tb{width: 50%;height:100%;}
)

manapp=: 'jpage y must be '''''

ev_create=: {{
 manapp assert ''-:y
 t=. y jpagedefault ,LF,.~20 20$'some text '
 jhrcmds ('set ta *',t);'set tb *',100}.|.t
}}

ev_hbs_click=: {{ jhrcmds 'set ta *',HBS }}
ev_css_click=: {{ jhrcmds 'set tb *',CSS }}
