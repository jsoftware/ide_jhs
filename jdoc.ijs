coclass'jdoc'
coinsert'jhs'

HBS=: 0 : 0
jhclose''
'title'jhtitle'JHS framework'
'jhs locale - utils - verbs/nouns/... for creating apps'
jhbr
mfix '~addons/ide/jhs/form.ijs'
mfix '~addons/ide/jhs/utilh.ijs'
mfix '~addons/ide/jhs/util.ijs'
)

CSS=: 0 : 0
form{margin:10px;}
.defn{white-space:pre;font-family:<PC_FONTFIXED>;color:blue;}
.html1{white-space:pre;font-family:<PC_FONTFIXED>;font-size:200%;border:solid 1px black;}
.html2{white-space:pre;font-family:<PC_FONTFIXED>;font-size:150%;border:solid 1px black;}
.html3{white-space:pre;font-family:<PC_FONTFIXED>;font-size:100%;border:solid 1px black;}
.doc{white-space:pre;font-family:<PC_FONTFIXED>;padding-left:3em;}
)

fix=: 3 : 0
t=. man y
NB. t=. t rplc '<';'&lt;'

NB. mark =: lines
bd=. <;.2 t

NB. NB.*< html
mskhtml=. (<'NB.*.')=5{.each bd
a=. mskhtml#i.#bd
z=. dltb each 5}.each a{bd
class=. {.each z
z=. jhfromax each dltb each }.each z
bd=. ((<'<span class="html'),each class,each (<'">') ,each z,each<'</span>') a}bd

NB. NB.*
msknb=. (-.mskhtml)*.(<'NB.')=3{.each bd
a=. msknb#i.#bd
z=. 4}.each a{bd
z=. jhfromax each z
bd=. ((<'<span class="doc">'),each,z,each<'</span>') a}bd

NB. defn
mskdefn=. -. mskhtml +. msknb
a=. mskdefn#i.#bd
z=. dltb each a{bd
z=. jhfromax each z
bd=. ((<'<span class="defn">'),each,z,each<'</span>') a}bd

t=. ;bd
)

mfix=: 3 : 0
t=. ''jhline''
t=. t,''jhhn 3;y
t=. t,''jhdiv fix y
t
)

jev_get=: 3 : 0
'jdoc'jhr''
)

