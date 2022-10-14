coclass'tictactoe'
coinsert'jhs'

man=: 0 : 0
load'~addons/ide/jhs/react/tictactoe/addj/tictactoe.ijs'
c=: conew'tictactoe'
open_jhs_ c
)

name=: ;coname''

src=: '~addons/ide/jhs/react/',name,'/'
snk=: '~temp/jhs/react/',name,'/'

NB. create ~temp folder with all files from src/dist/
NB.  and then all files (possibly replacing) from src/adj/
3 : 0''
echo 'create: ',snk
mkdir_j_ snk

n=. {."1 [1!:0 <jpath src,'dist/*'
(fread each (<src,'dist/'),each n) fwrite each (<snk),each n

n=. {."1 [1!:0 <jpath src,'addj/*'
(fread each (<src,'addj/'),each n) fwrite each (<snk),each n
(fread src,'addj/',name,'.js') fwrite snk,'script.js'
)

NB. fix css/script path - if tictactoe locale, do conew and add location change
fixhtml=: 3 : 0
d=. y rplc './';snk
if. ('tictactoe'-:;coname'') do.
 t=. 'location.href= "http://localhost:65001/',(;conew'tictactoe'),';'
 d=. d rplc '<script>';'<script>',LF,t
end. 
d
)

jev_get=: 3 : 0
d=. fixhtml fread snk,'index.html'
htmlresponse d,~fsrchead rplc '<TYPE>';'text/html' 
)

winners=: 0 4 8, 6 4 2, (i. 3 3), (|: i. 3 3)

NB. x is X or Y ; y is board
getplays=: 4 : 0
c=. +/y='*'
i=. (y='*')#i.9
plays=. ( <"0 each <"1 (i.c),.i)
x plays } (c,9)$y
)

NB. x is X or Y ; y is board
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
 echo'X has won'
 NB. X has won
 i=. 9
 a=. 1
else.

 NB. play to win
 i=. 'O' getwinner q
 if. i<9 do.
  echo 'Y has won'
  a=. 2
 else.
  NB. play to block
  i=. 'X' getwinner q
  if. i=9 do.
   NB. play random
   i=. q i. '*' NB.! should be more random
  end.
 end.  
end. 
if. i<#q do. q=. 'O' i}q end.
last=: q
jhrajax enc_json_jhs_ |:2 2$'oplay';i;'winner';a
)
