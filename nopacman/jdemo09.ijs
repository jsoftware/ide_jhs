coclass'jdemo09'
coinsert'jhs'

NB. does not use HBS
NB. does not load jscore so jijx esq-q jscdo fails - window.close() instead

jev_get=: 3 : 0
t=. html rplc '<ADDRESS>';gethv_jhs_ 'Host:'
htmlresponse hrtemplate hrplc 'TITLE CSS JS BODY';'jdemo9';'';'';t
)

html=: 0 : 0
 <frameset cols="44%,*">
  <frame src="http://<ADDRESS>/jijx"
   name="ijx",
   scrolling='auto'>
 <frameset rows="77%,*">
  <frame src="http://<ADDRESS>/jijs"
   name="ijs",
   scrolling='auto'>
  <frame src="http://<ADDRESS>/jfile"
   name="files",
   scrolling='auto'>
 </frameset>
 </frameset>
)

info=: 0 : 0
The html result has multiple frames.

Get a similar result by creating file multiple.htm
and loading it in a browser.

*** multiple.htm ***
<html><head><title>multiple</title></head>
)
