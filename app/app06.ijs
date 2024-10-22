coclass'app06'
coinsert'jhs'

HBS=: 0 : 0
NB. base div implicity opened
      jhclose''
'title' jhh1 'css flex - ta above tb'
'hbs'   jhb'show HBS'
'css'   jhb'show CSS'

jhdivz NB. base div close - flex active

NB. elements not in main div share remaining space
'tatitle'jhtitle'tb textarea'
'ta'jhtextarea'';10;10
jhdiva''                       NB. reopen main div

'hr'jhline''

jhdivz
'tbtitle'jhtitle'tb textarea'
'tb'jhtextarea'';10;10

jhdiva''                       NB. reopen main div
'footer'jhhn 3;'adsf'
)

CSS=: 0 : 0
#ta{<PS_FONTCODE>;resize:none;} /* code font - no resize handle */
#tb{<PS_FONTCODE>;resize:none;} /* code font - no resize handle */
#ta{width: 100%;height:70%;} /* full height - share width */
#tb{width: 100%;height:30%;}
#hr{height: 10px; background-color: red;}
)

manapp=: 'jpage y must be '''''

ev_create=: {{
 manapp assert ''-:y
 t=. y jpagedefault ,LF,.~20 20$'some text '
 jhrcmds ('set ta *',t);'set tb *',100}.|.t
}}

ev_hbs_click=: {{ jhrcmds 'set ta *',HBS }}
ev_css_click=: {{ jhrcmds 'set tb *',CSS }}
