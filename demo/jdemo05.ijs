coclass'jdemo05'
coinsert'jhs'

NB. sentences to create html elements
NB. jhbshtml_jdemoxx_'' shows HBS html
HBS=: 0 : 0
jhclose''
'title'  jhh1 'chartjs'
'run'jhb'run'
'sentence'jhtext''
jhbr
'cjsa'jhchart''
)

NB. style the html elements
CSS=: 0 : 0
.jhchart_parent{border:solid;height:200px;width:50%;float:left;}
)

get=: 3 : 0
jcjs'type';y
jcjs'get'
)

NB. validate sentence
validate=: 3 : 0
try.
 v=. ".y 
 assert (1=$$v)*.2~:3!:0 v
catch.
 echo 'bad sentence: ',y
 y=. '5?5'
 v=. ".y
end.
y;v
)

ev_create=: 3 : 0
t=. y jpagedefault '5?5'
't v'=. validate t
jcjs'reset'
jcjs'labels';#v
jcjs'data';v
jcjs'legend';'mydata'
jcjs'add';'options.animation.duration 2000'
d=. ('set sentence *',t);('chartjs cjsa *',get'line')
jhrcmds d
)

ev_run_click=: {{ ev_create getv'sentence' }}
ev_sentence_enter=: ev_run_click

INC=: INC_chartjs NB. include chart js code

