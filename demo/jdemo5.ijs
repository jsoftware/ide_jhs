coclass'jdemo5'
coinsert'jhs'
demo=: 'jdemo5.ijs'

B=:  0 : 0
jdemo
'<h1>Plot demo<h1>'
svg pdf sentence
'<PLOT>'
-
openijs ^^
)

BIS=: 0 : 0
svg      hb'svg'
pdf      hb'pdf' 
sentence ht'<SENTENCE>';20
jdemo   href'jdemo'
openijs  hopenijs'Open script: ';(PATH,'demo/',demo);demo;''
)

dosvg=: 3 : 0
t=. '<object type="image/svg+xml" data="<FILE>"></object>'
t hrplc 'FILE';'~temp/svg/plot.svg'
)

dopdf=: 3 : 0
t=. '<object type="application/pdf" data="<FILE>#toolbar=1&navpanes=0&scrollbar=0"></object>'
t hrplc 'FILE';'~temp/pdf/plot.pdf'
)

create=: 3 : 0
hr 'jdemo5';(css CSS);(svgjs,js'');(B getbody BIS)hrplc'SENTENCE PLOT';y
)

dop=: 4 : 0 NB. 'svg' dop sentence
try.
 if. x-:'svg' do.
  ('plot.svg';'title demo';0)jsvgplot__ ".y
  create y;dosvg''
 else.
  ('plot.pdf';'';0)jpdfplot__ ".y
  create y;dopdf''
 end.
catch.
 create y;(13!:12'')rplc LF;'<br>'
end.
)

jev_get=: 3 : 0 NB. browser get request
'svg' dop '10?10'
)

NB. javascript handlers default to post J handlers
ev_sentence_enter=: ev_svg_click

ev_svg_click=: 3 : 0
'svg' dop getv'sentence'
)

ev_pdf_click=: 3 : 0
'pdf' dop getv'sentence'
)

CSS=: 0 : 0
object{margin:0;padding:0;height:300px;width:100%;display:block;border:none;}
)

