NB. utils

cojhs_z_=:     cojhs_jhs_
jpage_z_=:     jpage_jhs_
jhsoption_z_=: jhsoption_jhs_
jhsflex_z_=:   jhsflex_jhs_
jhsclosepages_z_=: jhsclosepages_jhs_

coclass'jhs'

cojhs=: jpage

0 : 0
opening/reopening page from J or url is fundamental

function pageopen(url,wid,specs)

open - [xywh] open url [; jwid ] - calls pageopen
edit - [xywh] edit'~temp/abc.ijs - calls open

jpage - 'class;show;title' jpage data - calls open

jpage create numbered locale for the page 

'term' open does jjs newpage to get iframe page in SPA
'tab'  open jjs pageopen to get new or exisiting page
''     open isSPA chooses term or tab

default jev_get calls jpageget if ev_create is defined (indicates jpage)
 jpageget creates numbered locale for the page
)

NB.* see ~addons/ide/jhs/util.ijs for complete information
NB.* 
NB.* jhs locale definitions:
NB.* 

NB.* jhsclosepages jhsclosepages''
jhsclosepages=: 3 : 0
jjs 'closepages()'
)

NB.* 
NB.* jhsflex - set relative term iframe sizes and freeze splitter
NB.*    jhsflex '50 10 40' NB. term iframe sizes and freeze splitter
NB.*                       NB. missing use last value
NB.*    jhsflex ''         NB. unfreeze splitter
NB.* 
jhsflex=: 3 : 0
if. y-:'' do.
 jjs 'framesize([])'
else.
 t=. }:;(<'"1 1 '),each (<'%",'),~each   ":each y
 jjs 'framesize([',t,'])'
end. 
)

NB.* 
NB.* jhsoption - set term menu option(s)
NB.*    jhsoption 'wrap'
NB.*    jhsoption 'term row'
NB.* wrap / nowrap - term log text
NB.* tab  / term   - jpage default tab or term iframe
NB.* row  / column - term iframes
NB.* 
jhsoption=: 3 : 0
r=. ''
for_n. ;:tolower y do.
 select. n=. ;n
 case. 'column' do. t=. 'flowset(1)'
 case. 'row'    do. t=. 'flowset(0)' 
 case. 'wrap'   do. t=. 'wrapset(1)'
 case. 'nowrap' do. t=. 'wrapset(0)'
 case. 'term'   do. t=. 'termset(1)'
 case. 'tab'    do. t=. 'termset(0)'
 case.          do. (n,' not a  menu option')assert 0
 end.
 r=. r,t,';'
end.
jjs r
)

NB.* jcreatetestapp - jcreatetestapp 'test';'app1'
jcreatetestapp=: 3 : 0
'snk src'=. y
f=. snk,src
t=. fread '~addons/ide/jhs/app/',src,'.ijs'
i=. t i. LF
a=. deb i{.t
'src must start with coclass'assert a-:'coclass''',src,''''
b=. a i.''''
t=. ( (b{.a),'''',f,''''),i}.t
t fwrite'~temp/',f,'.ijs'
fn=. '~temp/',f,'.ijs'
edit fn
load fn
echo'   ''',f,''' jpage '''''
)

NB.* jtestall'app' - app/page/demo
NB.*  run all files in folder with jpage
NB.*  test suite for changes
jtestall=: 3 : 0
'bad y'assert (<y)e.'app';'demo';'page'
f=. jpath'~addons/ide/jhs/',y
n=. 1 dir f
xywh=. 10 10 700 700
for_a. n do.
 load a
 b=. (>:#f)}.;a
 b=. (b i.'.'){.b
 echo b
 c=. <b
 try.
  (b,';',":xywh)jpage''
 catch.
  echo 'failed: ',;a
 end. 
 xywh=. xywh+60 20 0 0
end.
i.0 0
)

NB.* 
NB.* jpage - locale=. 'class;show;title' jpage data
NB.*   show: '' JS var defaultopen or '_' no show or 'tab' or 'term' or x y [w h] window location
NB.*   title: tab title -  empty class default
NB.*   if class has ev_create -> create object on class (numbered locale)
NB.*     'jwatch;10 10;abc' jpage '?4 6$100'
NB.*      app/page folder files have ev_create
NB.* 
NB.*  if class does not have ev_create then no object is created and data is ignored
NB.*  jfile/... and demo folder files do not have ev_create
NB.*    'jfile'jpage''
NB.*    'jdemo01'jage''
NB.* 
NB.*  jpage show calls open which calls JS pageopen
NB.* 
jpage=: 4 : 0
d=. dltb each<;._2 x,';'
'c s t'=. 3{.d,'';''
('locale ',c,' must be created first')assert (<c)e. conl 0
NB. class with ev_create not defined does open
s=. fixshow s
if. 3~:nc<'ev_create_',c,'_' do. s open c,'?jpagearg=',jurlencode y return. end. 
r=. conew c
createpage__r (;(''-:t){t;c,'-',;r);s;<y
r
)

createpage=: 3 : 0
LASTY=: y
't s a'=. y
title=: t
ev_create a
if. '_'~:s do. show s end.
)

NB.* jpagedefault - arg jpagedefault defaultarg - default if x is ''
jpagedefault=: 4 : 0
(''-:x){::x;<y
)

NB.* jpageget - jev_get for a page
NB. getv'locale' is a: if request from browser url
NB.              is new locale if request from jpage 
jpageget=: 3 : 0
n=. <getv'jlocale'
if. a:-:n do. NB.!!!!!

 if. Num_j_ e.~ {.;coname'' do.
  NB. jtable with jhot iframe - in object and createpage has run
  title jhrx (getcss''),(getjs''),gethbs''
  return.
 end. 

 NB. browser needs to do what jpage would do
 NB. browser url?sentence="i.5" can pass args to init
 n=. conew ;coname''
 createpage__n  ((;coname''),'-',;n);'_';<''
 NB. title__n=: (;coname''),'-',;n
 NB. create__n'' NB. with default args
end.
cocurrent n NB. run in app locale
title jhrx (getcss''),(getjs''),gethbs''
)

NB.* 

NB. return valid open show
NB. '_' or 'tab' or 'term' or xywh
fixshow=: 3 : 0
s=. deb y
if. (<s) e. ('term';'tab';'';,'_') do. s return. end.
s=. _".s
'invalid show'assert -.(_ e. s)+.(-.0 2 4 e.~#s)+.0><./s
s
)

NB.*
NB.* close - close wid
close=: 3 : 0
jjs_jhs_'jijxwindow.getwindow("',y,'").close();'
)

NB.*
NB.* cbfix - fix ' \ \n from clipboard paste in jijx prompt
cbfix=: 3 : 0
cbdata_jhs_=. y rplc '\n';LF;'\\';'\';'\''';''''
)

NB.*
NB.* focus - focus wid - focus 'jfif' - focus 'jijs?jwid=~temp/sp/spfile.ijs'
focus=: 3 : 0
jjs_jhs_'jijxwindow.getwindow("',y,'").focus();'
)

NB.* doc - doc '' or 'html' or 'js'
doc=: 3 : 0
select. y
case. 'html' do.
 NB. should be changed be simpler util.ijs comments
 r=. ''
 t=. <;.2 LF,~fread '~addons/ide/jhs/utilh.ijs'
 for_n. t do.
  n=. >n
  if. 'NB.* '-:5{.n do.
   n=. 5}.n
   i=. n i.'*'
   if. i~:#n do.
    n=.(10{.i{.n),' ',}.i}.n
   end.
   r=. r,n
  end.
  r
 end.
case. 'js'   do.
 NB. should be expanded and use simpler comments similar to util.ijs
 r=. docjsn
 t=. <;.2 LF,~fread jpath JSPATH,'jscore.js'
 for_n. t do.
  n=. >n
  if. '//* '-:4{.n do.
   n=. 4}.n
   i=. n i.'*'
   if. i~:#n do.
    n=.(10{.i{.n),' ',}.i}.n
   end.
   r=. r,n
  end.
 end.
 r
case.        do.
 t=. <;.2 LF,~fread '~addons/ide/jhs/util.ijs'
 ;5}.each t#~(<'NB.* ')=5{.each t
end.
)

NB. thanks to Raul Miller for this forum contribution
fmt0=:3 :0 L:0
if.#$y do. ,@(,"1&LF)"2^:(_1 + #@$) ":y else. ":y end.
)

NB. jijs  run line - truncated display
tell=: 3 : 0
t=. fmt0 ":y
n=. (t=LF)#i.#t
if. 3>:#n do. t else. t=. ((1{n){.t),LF,'...' end.
)

NB.* jbd - jbd 0 or 1 - select boxdraw
jbd=: 3 : '9!:7[y{Boxes_j_' NB. select boxdraw (PC_BOXDRAW)

NB.* jfe - jfe 0 or 1 - toggle jconsole vs JHS as front end
jfe=: 3 : 0
15!:16 y
i.0 0
)

NB.* jlogoff - jlogoff'' - clear login cookie
jlogoff=: 3 : 'htmlresponse hajaxlogoff'

NB.* jhtml - jhtml'<i>foo</i>' - echo html into jijx log
NB.*    jhtml'&lt;font style="color:red;"&gt;A&lt;/font&gt;'
jhtml=: 3 : 0
a=. 9!:36''
9!:37[ 4$0,1000+#y NB. allow lots of html formatted output
smoutput jmarka_jhs_,y,jmarkz_jhs_
9!:37 a
i.0 0
)

NB.* jhlatex - jhlatex'\frac{1+sin(x)}{x^3}'
jhlatex=: 3 : 0
jhtml_jhs_'<img src="http://latex.codecogs.com/svg.latex?',y,'" border="0"/>'
)

NB.* jselect - jselect 'i.5',LF,'a=:2' - sentences into log for selection
jselect=: 3 : 0
if. 1=L.y do. y=. ;y,each LF end.
jhtml_jhs_'<div class="transient" style="overflow-wrap: break-word; white-space: normal;">',(jhtmlfroma  y),'</div>'
)

NB.* jjs - jjs 'alert("foo");' - eval javascript sentences in ajax response
NB. y starting with ; is run in refresh and in ajax
NB. blank first char is added if there is no ; - indicates run in ajax and refresh
jjs=:3 : 0
jhtml jmarkjsa,((';'={.y){' ;'),y,jmarkjsz
)

NB.* jsfromtable - jsfromtable i.3 4 - javascript table from J table
NB.*    see tablefromjs - does not handel _123
jsfromtable=: 3 : 0
d=. y
if. 0=L.d do. d=. <"0 d end.
d=. enc_json <"1 d
if. d-:'[]' do. d=. '[[]]' end.
)

0 : 0
different kinds of open

J cmd
 'jfif;'       jpage'' - defaultopen
 'jfif;tab'    jpage''
 'jfif;term'  jpage''

 'app07;'      jpage'' - defaultopen
 'app07;tab'   jpage''
 'app07;term' jpage''

menu command
 jfif - defaultopen

url
 jfjf - defaultopen

)

NB.* open - [''/xywh/'tab'/'term'] open url
NB.*  x
NB.*   elided is same as ''
NB.*   '' uses JS var defaultopen
NB.*   xy[wh] - new window location - wh default 500 500
NB.*   'tab' open/reopen in tab
NB.*   'term' open/reopen in term iframe spa page
NB.*
NB.* y 
NB.*  url - class - e.g., jfile/jfif/jdemo01/app01
NB.*   jijs class can have arg - jijs?jwid=foo.ijs
NB.*  jurlencode url is used as window name (allows reopen)
NB.*
NB.*                 open 'jfif' NB. js: var defaultopen - term/tab
NB.* ''              open 'jfif' NB. same as x elided
NB.* 10 10 [500 500] open 'jfif' NB. window at location 10 10
NB.* 'tab'           open 'jfif'
NB.* 'term'         open 'jfif'
NB.*
NB.* tab pages are activated if already open
NB.* term pages are activatd if already open
NB.* tab pages do not look for active term pages
NB.* term pages do not look for active tab pages
NB.*
NB.* jpage creates class object (numbered locale) and calls open with term
open=: 3 : 0
''open y
:
'a b s'=. x pageopenargs y
jjs 'pageopen(''',a,''',''',b,''',''',s,''');'
)

pageopenargs=: 3 : 0
''pageopenargs y
:
if. 0~:L.y do. 'unexpected boxed arg' assert 1[echo y end.
s=. deb x

NB. new or existing term or tab 
a=. b=. y
if. 2~:3!:0 s do.
 'bad xywh' assert (4=3!:0 s+0)*.(1=$$s)*.+./2 4 e.#s
 s=. 'left=<X>,top=<Y>,width=<W>,height=<H>'hrplc 'X Y W H';":each 4{.x,500 500
else.
 NB.! validate s! s=. ''
end.

i=. 1 i.~'?jwid='E.a
if. i<#a do.
 i=. i+6
 NB. JWID=: i}.a NB. used by jpage report
 a=. (i{.a),jurlencode i}.a NB. jurlencode just the parameter
end. 
JWID=: b
b=. jurlencode b
a;b;s
)

NB.* pages - pages'' - report locale wid,tab,class,locale
pages=: 3 : 0
t=. conl 1
t=. t#~;(<'jhs')=>1{each copath each conl 1
loc=. tab=. wid=. class=. ''
for_c. t do.
 if. COCREATOR__c-:<'jhs' do.
  try. tab=. tab,<JTITLE__c catch. tab=. tab,<,'?' end.
  try. wid=. wid,<JWID__c   catch. wid=. wid,<,'?' end.
  loc=. loc,c
  class=. class,{.copath c
 end.
end.
(;:'wid tab class loc'),wid,.tab,.class,.loc
)


NB.* utf8_from_jboxdraw - utf8_from_jboxdraw string - rplc i.11 boxdraw with utf8
utf8_from_jboxdraw=: 3 : 'y rplc (<"0 [11{.16}.a.),.<"1 [11 3$8 u: u:9484 9516 9488 9500 9532 9508 9492 9524 9496 9474 9472'

NB.* printstyle=: 'font-family:"courier new";font-size:16px;'
printstyle=: 'font-family:"courier new";font-size:16px;'

NB.* printwidth=: 80 - truncate long lines with ... 
printwidth=: 80

NB.* print - [x] print 23;noun - x default 1 - x 0 for manual print
print=: 3 : 0
1 print y
:
t=. fmt0 ":y
t=. t,;(LF={:t){LF;''
t=. <;._2 t
c=. ;#each t
t=. (c<.printwidth){.each t
t=. t,each ;(c>printwidth){each <'';'...'
t=. ;t,each LF
t=. utf8_from_jboxdraw jhfroma t
x printsub t
)

NB.* printscript - [x] printscript '~temp/abc.ijs' - x same as for print
printscript=: 3 : 0
1 printscript y
:
y=. spf y
t=. toJ fread y
t=. t,;(LF={:t){LF;''
d=. printwidth foldtext each <;._2 t
d=. (' ',~each 5":each <"0 >:i.$d),each d
d=. d rplc each <LF;LF,9#' '
t=. jhfroma y,LF,;d,each LF
x printsub t
)

printsub=: 4 : 0
s=. printstyle rplc '"';''''
jjs'win=urlopen("");win.document.write("<style type=''text/css''>pre{',s,'}</style><pre>',y,'<pre/>");',x#'win.print();win.close();'
)

NB.* tablefromjs - tablefromjs '[[1,2,3],[4,5,6]]' 
NB.*    see jsfromtable
tablefromjs=: 3 : 0
d=. >dec_json y
b=. d=<'json_null'
if. *./*./b do. i.0 0 return. end.
d=. (>:(*./"1 b)i:0){.d
d=. (>:(*./ b)i:0){."1 d
if. -.2 e. ,>3!:0 each d do. d=. >d end.
d
)

NB.* 
NB.* z locale definitions:
NB.* 

docjsn=: 0 : 0
see ~addons/ide/jhs/utiljs.ijs for complete information

html element ids are mid[*sid] (main id and optional sub id)

functions defined by you:

ev_body_load()   - onload jevload
ev_body_unload() - onunload jevunload
ev_body_focus()  - onfocus jevfocus (menu focus)
  
ev_mid_event() - event handler - click, change, keydown, ...

js event handler:
  jevev is event object
  event ignored if not defined
  jsubmit() runs J ev_mid_event and response is new page
  jdoajax([...],"...") runs J ev_mid_event
    ajax(ts) (if defined) is run with J ajax response
    ev_mid_event_ajax(ts) is run if ajax() not defined
  returns true (to continue processing) or false

documented functions:
)

NB. stadard jpage boilerplate
shown=: 0

NB. jsdata defined indicates new style app
show=: 3 : 0
shown=: 1
c=. coname''
t=. ;(Num_j_ e.~{.;c){(,~c);(;{.copath c),'?jlocale=',;c
y open t
)

destroy=: 3 : 0
if. shown do. close ;coname'' end.
codestroy''
)

ev_close_click=: 3 : 0
jhrajax''
shown=: 0 NB. already closed
destroy''
i.0 0
)

jev_get=: 3 : 0
if. 3=nc<'ev_create' do. jpageget'' else. title jhrx (getcss''),(getjs''),gethbs'' end.
)

create=: [
saveonclose=: [
NB. override jev_get, create, and savonclose to customize app
NB. end jpage boilerplate

coclass'z'


reload=: 3 : 'load RELOAD[echo RELOAD'

NB.* edit - [tab/term/xywh] edit'~temp/abc.ijs
NB.* monadic is '' which is js var defaultopen
edit=: 3 : 0
 '' edit y
:
 ('jijs;',":x)jpage y
)

NB.* jslog - jslog'window.location'
jslog=:   {{ jjs_jhs_'addlog(eval("',y,'"));' }}

NB.* jsalert - jsalert'window.location'
jsalert=: {{ jjs_jhs_'alert(',y,');' }}

NB.* jd3 - jd3''q
jd3=: jd3_jhs_

NB.* decho - decho string - same as echo - easy removal after debugging
decho=: echo_z_

NB.* dechoc - dechoc string - same as echoc - easy removal after debugging
dechoc=: echoc_z_

NB.* echoc - echoc string - echo to console - useful in some kinds of debugging
echoc=: 3 : 0
if. IFJHS do.
 try.
  jbd_jhs_ 1
  jfe_jhs_ 0
  echo y
 catch.
 end.
 jfe_jhs_ 1
 jbd_jhs_ 0
else.
 echo y
end. 
)

NB. in general add new things to jhs locale, not z locale

NB. utils - plot related - not doc documented

NB. f file.png
jhspng=: 3 : 0
d=. fread y
w=. 256#.a.i.4{.16}.d
h=. 256#.a.i.4{.20}.d
t=. '<img width=<WIDTH>px height=<HEIGHT>px src="<FILE><UQS>" ></img>'
jhtml t hrplc_jhs_ 'WIDTH HEIGHT FILE UQS';w;h;y;uqs_jhs_''
)

NB. [TARGET] f URL - url is server page or file with UQS 
jhslink=: 3 : 0
'_blank' jhslink y
:
UQS=. (+./'~/\'e. y){:: '';uqs_jhs_'' NB. ? cache only for file
t=. '<a href="<REF><UQS>" target="<TARGET>" class="jhref" ><TEXT></a>'
t=. t hrplc_jhs_ 'TARGET REF UQS TEXT';x;y;UQS;y
jhtml'<div contenteditable="false">',t,'</div>'
)

jhslinknopu=: 3 : 0
'_blank' jhslinknopu y
:
t=. '<a href="<REF>" target="<TARGET>" class="jhref" ><TEXT></a>'
t=. t hrplc_jhs_ 'TARGET REF TEXT';x;y;y
jhtml'<div contenteditable="false">',t,'</div>'
)

NB. f URL - url is www url
jhslinkurl=: 3 : 0
jhtml'<div contenteditable="false"><a href="http://',y,'" target="_blank">',y,'</a></span>'
)

jhslinkurlx=: 3 : 0
'a b'=. y
jhtml'<div contenteditable="false"><a href="',a,'" target="_blank">',b,'</a>'
)

jhslinkurlxx=: 3 : 0
'a b'=. y
'<div contenteditable="false"><a href="',a,'" target="_blank">',b,'</a>'
)

NB. TARGET f URL
jhsshow=: 3 : 0
'_blank' jhsshow y
:
jjs_jhs_ 'pageshow("',(y,uqs_jhs_''),'","',x,'","tab");' NB. tab is forced
)

plotjijx=: 3 : 0
canvasnum_jhs_=: >:canvasnum_jhs_
canvasname=. 'canvas',":canvasnum_jhs_
d=. fread y
c=. (('<canvas 'E.d)i.1)}.d
c=. (9+('</canvas>'E.c)i.1){.c
c=. c rplc 'canvas1';canvasname
d=. (('function graph()'E.d)i.1)}.d
d=. (('</script>'E.d)i.1){.d
d=. d,'graph();'
d=. d rplc'canvas1';canvasname
jhtml c
jjs_jhs_ ';',d NB. leading ; has sentence run in ajax and in refresh
)

NB. f type;window;width height[;output]
NB. type selects case in plotcanvas/plotcairo
plotdef=: 3 : 0
if. 'cairo'-:_1{::y=. 4{.y,<'canvas' do.
 'CAIRO_DEFSHOW_jzplot_ CAIRO_DEFWINDOW_jzplot_ CAIRO_DEFSIZE_jzplot_ JHSOUTPUT_jzplot_'=: y
else.
 'CANVAS_DEFSHOW_jzplot_ CANVAS_DEFWINDOW_jzplot_ CANVAS_DEFSIZE_jzplot_ JHSOUTPUT_jzplot_'=: y
NB. default output
 JHSOUTPUT_jzplot_=: 'canvas'
end.
i.0 0
)

plotcanvas=: 3 : 0
f=. '~temp/plot.html' NB. CANVAS_DEFFILE
d=. fread f
d=. d rplc'<h1>plot</h1>';''
d=. d rplc'#canvas1 { margin-left:80px; margin-top:40px; }';'#canvas1{margin-left:0; margin-top:0;}'
d fwrite f
w=. CANVAS_DEFWINDOW_jzplot_
select. CANVAS_DEFSHOW_jzplot_
 case. 'show' do. w jhsshow f
 case. 'link' do. w jhslink f
 case. 'jijx' do. plotjijx f
 case. 'none' do.
 case.        do. plotjijx f
end.
i.0 0
)

plotcairo=: 3 : 0
f=. '~temp/plot.png' NB. CAIRO_DEFFILE
w=. CAIRO_DEFWINDOW_jzplot_
select. CAIRO_DEFSHOW_jzplot_
 case. 'show' do. w jhsshow f
 case. 'link' do. w jhslink f
 case. 'jijx' do. jhspng f
 case. 'none' do.
 case.        do. jhspng f
end.
i.0 0
)

jhsuqs=: uqs_jhs_  NB. viewmat
jhtml=: jhtml_jhs_ NB. viewmat
jhlatex=: jhlatex_jhs_
