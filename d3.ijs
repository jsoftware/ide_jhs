NB. d3 utils
coclass'jhs'

NB. jd3 plots

jd3x=: ''

jd3doc=: 0 : 0
jd3'help'
jd3'options'     NB. plot options
jd3'state'       NB. current options state
jd3'reset'       NB. reset options state
jd3'type bar'    NB. add type option
jd3'title TITLE' NB. add title option

'tab' jd3 data   NB. browser tab title

example:
jd3'reset;type line;title My Data;legend "line one","line two","line three"'
'P' jd3 ?3 4$100

jd3'type bar;label "a","b","c","d"'
'P' jd3 ?3 4$100

jd3'type pie'
'P' jd3 ?4$100
)

jd3docoptions=: 0 : 0
jd3'option arg'    - add option to jd3x__
 type        line      - line or pie or bar
 header      how now<hr>
 title       Good Data
 minh        200       - min height
 maxh        600
 minw        300       - min width
 maxw        700
 linewidth   4
 barwidth    40
 label       "s","d","f"
 legend      "a","b","c"
 footer      <hr>how now
)

jd3=: 3 : 0
assert 'literal'-:datatype y

 if. ';'e. y do.
  t=. jd3 each a:-.~<;._2 y,';'
  >(0~:;*/each $each t)#t
  return.
 end.

 i=. y i.' '
 c=. dltb i{.y
 a=. dltb i}.y
 a=. a rplc '"';''''
 b=. '\"',a,'\"'
 select. c
 fcase.'' do.
 case.'help' do. jd3doc return.
 case.'options' do. jd3docoptions return. 
 case.'state' do. jd3x return.
 case.'reset' do. jd3x=: '' return.
 case. ;:'type header title footer' do.
  t=. c,'=',b
 case. ;:'minh maxh minw maxw barwidth linewidth' do.
  t=. c,'=',a
 case. ;:'legend label' do.
  t=. c,'=[',a,']'
 case. do. ('jd3 unknown option: ',y)assert 0  
 end.
 jd3x=: jd3x,t,LF
 i.0 0
:
assert 'literal'-:datatype x
assert -.'literal'-:datatype y

x gd_set_jd3_ (jd3x,jd3data y)rplc LF;'\n' 

NB. (x,'_tabdata')=: (jd3x,jd3data y)rplc LF;'\n' 
'jd3' windowopen_jhs_ x
)

jd3data=: 3 : 0
d=. ":each <"1 y
d=. d rplc each <' ';','
d=. d rplc each <'_';'-'
d=. ']',~each '[',each d
']',~'data=[',;d,each','
)

