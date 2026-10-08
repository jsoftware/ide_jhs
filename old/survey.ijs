coclass'jsurvey'
coinsert'jhs'

NB. locale jsurvey must match url used in guest.js

thankyou=: 0 : 0
<div style='padding:2rem;'><font style='color:blue;font-weight:bold;font-size:1.5em;'>Jsoftware </font>
thanks you for submitting this survey.
</div>
)

survey=: 0 : 0
<div><font style="color:blue;font-weight:bold;font-size:1.5em;">Jsoftware survey - basic</font><br><br>
Your answers to these 12 questions will help guide Jsoftware efforts to improve J. A comment area follows each guestion.
</div>

+How long have you been using J?
 *less than 1 year
 *1-3 years
 *4-10 year
 *seems like forever
  
+Which platform do you use most with J?
 *Windows
 *Mac
 *Linux
 *iOS
 *Android
 
+What platforms do you use with J?
 -Windows
 -Mac
 -Linux
 -iOS
 -Android
   
+Which J front end do you use the most?
 *Jqt
 *jconsole
 *JHS
 
+What J front ends to you use?
 *Jqt
 *jconsole
 *JHS
 
+What script editor do you us the most?
 *Jqt edit
 *JHS edit
 *Visual Studio Code
 
+What J technologies do you use?
 -plot
 -viemat
 -dissect
 -Jd
 -Jqt window driver
 -JHS apps
 
+What use do you make of debug?
 *none
 *raw (dbr,dbs,...)
 *Jqt
 *JHS
 
+How old are you?
 *under 20
 *21 to 30
 *31 to 40
 *41 to 50
 *over 50 

+How would you rate Jsoftware support for J?
 *poor
 *average
 *excellent
 
+Would you recommend J to a friend or colleague?
 *no
 *yes
 *absolutely
 
+Comments please!
)

NB. question,item
getid=: 3 : 0
'q i question item'=. y
questions=: questions,question;item
id=. 'q',(":q),'i',(":i)
ids=: ids,id,LF
jsids=: jsids,',''',id,''''
'''',id,''''
)

createHBS=: 3 : 0
d=. <;._2 survey
d=. deb each d
i=. d i. <''
h=. i{.d
d=. i}.d
r=. <'''',(;h),''''
q=. 0
i=. 1
type=. ' '
ids=: ''
jsids=: ''
questions=: 0 2$''
for_n. d do.
 t=. deb ;n
 s=. {.t
 t=. }.t
 item=. t
 select. s
 case.'+' do.
  if. q~:0 do. NB. new question
   if. type='*' do.
    set=. '''','q',(":q),''''
    r=. r,<(getid q;i;question;'na'),' jhrad ',set,';''none of the above'''
    i=. >:i
   end.
   r=. r,<(getid q;i;question;'ta'),' jhtextarea '''';1;20'
   type=. ' '
  end.
  q=. >:q
  i=. 1
  r=. r,<'jhhr'
  r=. r,<'jhquestion ''',(":q),'. ',t,''''
  question=. t
 case.'-' do.
  type=. '-'
  r=. r,<(getid q;i;question;item),' jhchk''',t,''';0'
  i=. >:i
 case.'*' do.
  type=. '*'
  set=. '''','q',(":q),''''
  r=. r,<(getid q;i;question;item),' jhrad ',set,';''',t,''''
  i=. >:i
 case.'=' do.
  r=. r,<(getid q;i;question;item),' jhtextarea '''';1;20'
  i=. >:i
 case.' ' do. 
 end.
end.
if. type='*' do.
 set=. '''','q',(":q),''''
 r=. r,<(getid q;i;question;item),' jhrad ',set,';''none of the above'''
 i=. >:i
end.
r=. r,<(getid q;i;question;''),' jhtextarea '''';1;20'
r=. r,<'jhhr'
t=. ;r,each LF
t=. t rplc LF;LF,'''<br>''',LF
t,LF,~'''sub''jhb''submit'''
)

createJS=: 3 : 0
JS=: JS rplc '<IDS>';(}.jsids);'<THANKYOU>';thankyou-.LF
)

jhquestion=: 3 : 0
y
)

HBS=: ''

create_new_survey=: 3 : 0
echo 'create new survey'
p=. 'jsurvey'
mkdir_j_ p
HBS=: createHBS''
JS=: createJS''
HBS    fwrite p,'/HBS'
ids    fwrite p,'/ids'
survey fwrite p,'/survey'
''     fwrite p,'/data'
t=. 'jsurvey' jhrpage (getcss''),(getjs''),gethbs''
t=. (t i.'<')}.t
t fwrite p,'/survey.html'
)

create=: 3 : 0
if. HBS-:'' do. create_new_survey'' end.
'create_new_survey_jsurvey_ must be run to create HBS'assert -.HBS-:''
'survey' jhrx (getcss''),(getjs''),gethbs''
)

NB. called when browser gets this page
jev_get=: create

ev_sub_click=: 3 : 0
echo'sub click'
echo NV
nv=: NV
b=. 'j'~:;{.each{."1 nv
snv=. b#nv
t=. '1'=;1{. each 1{"1 snv
answers=: (t#{."1 snv),.t#questions_jsurvey_
echo answers
t=. 1<;#each 1{"1 snv
comments=: (}:"1(t#{."1 snv),.t#questions_jsurvey_),.'*',each t#{:"1 snv
echo comments
jhrajax''
)

NB. jsurvey utils

NB. \0 terminated survey submissions
NB. start with blank delimited ts ip
surdata=: 3 : 0
d=. <;.2 fread'jsurvey/data'
i=. ;d i.each' '
ts=. i{.each d
d=. (>:i)}.each d
i=. ;d i.each' '
ip=. i{.each d
ts,.ip,.(>:i)}.each d
)

CSS=: 0 : 0
form{margin:2rem;}
#sub{font-size:2em;padding:5px;}
)

NB. *.jhspan:hover{background-color:lightblue;}

JS=: 0 : 0
//function ev_sub_click(){jdoajax([<IDS>]);}
function ajax(){document.body.innerHTML="<THANKYOU>";}

)