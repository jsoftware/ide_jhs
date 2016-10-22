coclass'jwatch'
coinsert'jhs'

HBS=: 0 : 0
'run'jhb''
'sentence'jhtext'<SENTENCE>';30
'<div id="data" class="jcode"><TEXT></div>'
)

CSS=: 0 : 0
form{margin:20px;}
#sentence{width:80%;}
)

NB. thanks to Raul Miller for this forum contribution
fmt0=:3 :0 L:0
  if.#$y do.
    ,@(,"1&LF)"2^:(_1 + #@$) ":y
  else.
    ":y
  end.
)

NB. rplc to convert boxdraw (11{16}.a.) to utf8
ab=: (<"0 [11{.16}.a.),.<"1 [11 3$8 u:9484 9516 9488 9500 9532 9508 9492 9524 9496 9474 9472

calc=: 3 : 0
try. r=. ":do__ y catch. r=. 13!:12'' end. 
ab rplc~ jhtmlfroma fmt0 r
)

jev_get=: 3 : 0
s=. gd_get''
(getv'jwid') jhrx (getcss''),(getjs''),gethbs'SENTENCE TEXT';s;calc s
)

ev_run_click=: 3 : 0
s=. getv'sentence'
gd_set s
jhrajax calc s
)

JS=: 0 : 0
function ev_run_click(){jdoajax(["sentence"]);}
function ev_run_click_ajax(ts){jbyid("data").innerHTML=ts[0];}
function ev_sentence_enter(){jscdo("run");}
)
