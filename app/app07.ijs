coclass'app07'
coinsert'jhs'

NB. sentences to create html elements
NB. jhbshtml_jdemoxx_'' shows HBS html
HBS=: 0 : 0
jhclose''
'title' jhh1 'chartjs'
        jhijs''                        NB. button to edit source script
        jhhr
'top'   jhdiv'same data - 4 chart types'
jhbr
'run'   jhb'run'
'sentence'jhtext''
jhbr
'cjsa'  jhchart''
'cjsb'  jhchart''
jhbr
'cjsc'  jhchart''
'cjsd'  jhchart''
)

NB. style the html elements
CSS=: 0 : 0
#top{text-align:center;font-size:20px;}
#sentence{margin-bottom:5px;}
.jhchart_parent{border:solid;height:200px;width:50%;float:left;}
#cjsd_parent{background-color:pink}
hr{clear:both} /* so it doesn't appear under elements that float */
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

create=: 3 : 0
't v'=. validate y
jcjs'reset'
jcjs'labels';#v
jcjs'data';v
jcjs'legend';'mydata'
jcjs'add';'options.animation.duration 2000'
d=. ('set sentence *',t);('chartjs cjsa *',get'line');('chartjs cjsb *',get'bar');('chartjs cjsc *',get'pie');'chartjs cjsd *',get'doughnut'
)

ev_create=: 3 : 0
jhcmds create y jpagedefault '5?5'
)

ev_run_click=: {{ jhrcmds create getv'sentence' }}
ev_sentence_enter=: ev_run_click

INC=: INC_chartjs NB. include chart js code

