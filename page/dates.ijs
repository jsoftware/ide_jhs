coclass'dates'
coinsert'jhs'

HBS=: 0 : 0
jhclose''
'run'jhb'run'
'choice'jhtext'';30
jhbr
'city'   jhselect ('warsaw';'toronto';'paris');1;0
'<input type="date" class="jhtext" id="start" name="start" value="2026-01-01" onchange="return jev(event)">'
'<input type="date" class="jhtext" id="end"   name="end"   value="2026-01-31" onchange="return jev(event)">'
jhbr
'cjsa'jhchart''
)

ev_create=: {{jhcmds 'set choice *warsaw 2026-01-01 2026-01-31'}}

ev_city_change=: {{
'city start end'=. getvs'city start end'
jhrcmds 'set choice *',city,' ',start,' ',end
}}

ev_start_change=: ev_city_change
ev_end_change=:   ev_city_change

ev_run_click=: {{jhrcmds chart 20?20}}

chart=: {{
jcjs'reset'
jcjs'type';'line'
jcjs'labels';#y
jcjs'data';y
jcjs'legend';'mydata'
jcjs'add';'options.animation.duration 2000'
'chartjs cjsa *',jcjs'get'
}}

CSS=: 0 : 0
#choice{color:red}
)

INC=: INC_chartjs NB. include chart js code
