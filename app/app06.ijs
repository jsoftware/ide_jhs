coclass'app06'
coinsert'jhs'

HBS=: 0 : 0
NB. base div implicity opened
      jhclose''
'title' jhh1 'flex - jhtextarea ,: jhdiv'
'hbs'   jhb'show HBS'
'css'   jhb'show CSS'

jhflexa NB. base div close - flex active
'tatitle'jhh1'textarea'
'ta'jhtextarea'';10;10
jhflexz NB. reopen main div

'hr'jhline''

jhflexa
'tbtitle'jhh1'jhdiv'
'tb'jhdiv''
jhflexz

'footer'jhhn 3;'footer'
)

CSS=: 0 : 0
#ta{<PS_FONTCODE>;<PS_FLEX>;height:60%;}
#tb{<PS_FONTCODE>;<PS_FLEX>;height:40%;}
#hr{height: 10px; background-color: red;}
)

ev_create=: {{
t=. (''-:y){::y;<,LF,.~60 20$'silly text ' NB. y or default
'jpage y must be text' assert 2=3!:0 t
jhrcmds ('set ta *',t);'set tb *','<span style="color:blue;font-size:3rem;">jhdiv</span><br>',t
}}

ev_hbs_click=: {{ jhrcmds 'set ta *',HBS }}
ev_css_click=: {{ jhrcmds 'set tb *',CSS }}
