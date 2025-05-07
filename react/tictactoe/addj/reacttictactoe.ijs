coclass'reacttictactoe'
coinsert'jhs'

NB. src - path to find other bits
src=: '~addons/ide/jhs/react/tictactoe/addj/'

NB. fix css/script path
fixhtml=: 3 : 0
y rplc './';src
)

jev_get=: 3 : 0
d=. fixhtml fread src,'index.html'
htmlresponse d,~fsrchead rplc '<TYPE>';'text/html' 
)

winners=: 0 4 8, 6 4 2, (i. 3 3), (|: i. 3 3)

NB. x is X or Y ; y is board
getplays=: 4 : 0
c=. +/y='*'
i=. (y='*')#i.9
plays=. <"1 (i.c),.i
x plays } (c,9)$y
)

NB. x is X or O ; y is board
getwinner=: 4 : 0
d=. x getplays y
i=. 3 i.~ >./"1 +/"1 x=winners {"_ 1 d
if. i=#d do. 9 return. end.
t=. i{d
(t~:y)i.1
)

NB. 'cmd' getval table_from_json
getval=: 4 : 0
i=. ({.y)i.<x
>i{{:y
)

NB. NV has json of cmd: and board:
NB. return oplay: as O move and winner: as 0/1/2 for no/X/Y winner
jev_post_raw=: 3 : 0
v=. dec_json_jhs_ NV
c=. 'cmd'getval v
s=. {:'squares'getval v
B=: q=. ;s rplc each <'json_null';'*'
a=. 0 NB. assume no winner

if. 3 e. +/"1 'X'=winners{q do.
 i=. 9
 a=. 1 NB. X wins
else.

 NB. play to win
 i=. 'O' getwinner q
 if. i<9 do.
  a=. 2 NB. Y wins
 else.
  NB. play to block
  i=. 'X' getwinner q
  if. i=9 do.
   t=. (q='*')#i.#q
   if. 0=#t do. i=. q i.'O' else. i=. (?#t){t end. NB. random play
  end.
 end.  
end. 
if. i<#q do. q=. 'O' i}q end.
last=: q
NB. error before here - no jhrajax response - J crash
jhrajax jsencode 'oplay';i;'winner';a{'0XO'
)
