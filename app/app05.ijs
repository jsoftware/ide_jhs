coclass'app05'
coinsert'jhs'

HBS=: 0 : 0
      jhclose''
'title' jhh1 'flex - jhtextarea , jhdiv'                        NB. button to edit source script
        jhijs'' NB. button to edit source script
'hbs'   jhb  'show HBS'
'css'   jhb  'show CSS'

jhflexa
 jhflexrowa NB. side by side
  'ta'jhtextarea''
  'tb'jhdiv'' 
 jhflexrowz
jhflexz

'footer'jhhn 3;'footer'
)

CSS=: 0 : 0
#ta{<PS_FONTCODE>;<PS_FLEX>;width:50%;}
#tb{<PS_FONTCODE>;<PS_FLEX>;width:50%;}
)

manapp=: 'jpage y must be '''''

ev_create=: {{
 manapp assert ''-:y
 t=. y jpagedefault ,LF,.~20 20$'some text '
 jhcmds ('set ta *','jhtextarea',LF,t);'set tb *','<span style="color:blue;font-size:3rem;">jhdiv</span><br>',t
}}

ev_hbs_click=: {{ jhrcmds 'set ta *',HBS }}
ev_css_click=: {{ jhrcmds 'set tb *',CSS }}
