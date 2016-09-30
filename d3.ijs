NB. d3 utils
coclass'jhs'

NB. jd3 plots

jd3x=: ''

jd3doc=: 0 : 0
jd3'help'
jd3'options'     NB. plot options
jd3'state'       NB. current options state

jd3'reset'       NB. reset options state
jd3'title TITLE' NB. add title option

'tab' jd3 data   NB. browser tab title

example:
jd3'reset'
jd3'type line'
jd3'title My Data'
jd3'legend "line one","line two","line three"'
'L' jd3 ?3 4$100

jd3'type bar'
jd3'label "a","b","c","d"'
'B' jd3 ?3 4$100

jd3'type pie'
'P' jd3 ?4$100
)

jd3docoptions=: 0 : 0
jd3'option arg'    - add option to jd3x__
 type        line      - line or pie or bar   
 title       Good Data
 titlesize   12pt      - html font size
 minh        100       - min graph pixel height
 maxh        300       - max graph pixel height
 linewidth   2
 barwidth    20
 legend      "a","b","c"
 lable       "s","d","f"
 header      how now<hr>
 header_css  "font-size":"24pt","margin-left":50
 footer      <hr>how now
 footer_css  "font-size":"24pt","margin-left":50
 data        formatted data - as formatted by jd3data
)

jd3=: 3 : 0
assert 'literal'-:datatype y
 i=. y i.' '
 c=. dltb i{.y
 a=. dltb i}.y
 b=. '"',a,'"'
 select. c
 fcase.'' do.
 case.'help' do. jd3doc return.
 case.'options' do. jd3docoptions return. 
 case.'state' do. jd3x return.
 case.'reset' do. jd3x=: '' return.
 case.'header' do.
  t=. '$("#ahtml").html(',b,')'
 case.'footer' do.
  t=. '$("#zhtml").html(',b,')'
 case.'header_css' do.
  t=. '$("#ahtml").css({',a,'})'
 case.'footer_css' do.
  t=. '$("#zhtml").css({',a,'})'
 case. ;:'type title titlesize minh maxh' do.
  t=. c,'=',b
 case. ;:'legend label' do.
  t=. c,'=[',a,']'
 case. do. ('jd3 unknown option: ',y)assert 0  
 end.
 jd3x=: jd3x,t,LF
 i.0 0
:
require'~addons/ide/jhs/jd3.ijs'
assert 'literal'-:datatype x
assert -.'literal'-:datatype y
(x,'_ev_body_load_data_jd3_')=: jd3x,jd3data y
'jd3' windowopen_jhs_ x
)

jd3data=: 3 : 0
d=. ":each <"1 y
d=. d rplc each <' ';','
d=. d rplc each <'_';'-'
d=. ']',~each '[',each d
']',~'data=[',;d,each','
)
