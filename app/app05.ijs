coclass'app05'
coinsert'jhs'

HBS=: 0 : 0
      jhclose''
'title' jhh1 'flex - jhtextarea , jhdiv'                        NB. button to edit source script
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

ev_create=: {{
t=. (''-:y){::y;<,LF,.~60 20$'silly text ' NB. y or default
'jpage y must be text' assert 2=3!:0 t
jhrcmds ('set ta *','jhtextarea',LF,t);'set tb *','<span style="color:blue;font-size:3rem;">jhdiv</span><br>',t
}}

ev_hbs_click=: {{ jhrcmds 'set ta *',HBS }}
ev_css_click=: {{ jhrcmds 'set tb *',CSS }}
