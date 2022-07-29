coclass'jwatch'
coinsert'jhs'

HBS=: 0 : 0
jhclose''
'run'jhb'run'
'sentence'jhtext'<SENTENCE>';30
'<div id="data" class="jcode"><TEXT></div>'
)

NB. cojhs boilerplate from util.ijs and overrides

create=: 3 : 'sentence=: y'

jev_get=: 3 : 0
title jhrx (getcss''),(getjs''),gethbs'SENTENCE TEXT';sentence;calc sentence
)

calc=: 3 : 0
try. r=. ":do__ y catch. r=. 13!:12'' end. 
if. 2=$$r do. r=. ,r,.LF end.
utf8_from_jboxdraw jhtmlfroma fmt0 r
)

ev_run_click=: 3 : 0
sentence=: getv'sentence'
jhrajax calc sentence
)

CSS=: 0 : 0
form{margin:0px 2px 2px 2px;}
#sentence{width:50%;}
)

JS=: 0 : 0
function ev_run_click(){jdoajax(["sentence"]);}
function ev_run_click_ajax(ts){jbyid("data").innerHTML=ts[0];}
function ev_sentence_enter(){jscdo("run");}
function ajax(ts){;}

)
