coclass'jdoc'
coinsert'jhs'

HBS=: 0 : 0
jhclose''
'title'jhh1'verbs/... _jhs_ for creating apps'
'<a href="#form">HBS</a> <a href="#utilh">events</a> <a href="#util">misc</a>'

jhflexa
 'all'jhdiva''
 '<div class="html1" id="form">~addons/ide/jhs/form.ijs</div>'
 'form'  jhdiv getmans '~addons/ide/jhs/form.ijs'
 '<div class="html1" id="utilh">~addons/ide/jhs/utilh.ijs</div>'
 'utilh' jhdiv getmans '~addons/ide/jhs/utilh.ijs'
 '<div class="html1" id="util">~addons/ide/jhs/util.ijs</div>'
 'util'  jhdiv getmans '~addons/ide/jhs/util.ijs'
 jhdivz
jhflexz
)

CSS=: 0 : 0
*.div{white-space:pre;font-family:<PC_FONTFIXED>;}
.html1{font-size:300%;}
#all{<PS_FLEX>}
)

getmans=: 3 :0
t=. man y
a=. deb each <;._2 t
b=. <;._2 a
i=. /:{:each b
c=. i{<;._2 <;.2 t NB. preserve blanks
c=. c,each <<LF
d=. ;c
b=. (<'NB.')=3{.each d
i=. b#i.#d
r=. ;3{each i{d
p=. 3+('*'=r)+.' '=r
d=. ((<'      '),each p}.each i{d) i}d
d=. jhfroma ;d
)

jev_get=: 3 : 0
'jdoc'jhr''
)
