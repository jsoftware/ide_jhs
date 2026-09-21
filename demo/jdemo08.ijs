coclass'jdemo08'
coinsert'jhs'

0 : 0
Window has 3 parts
title and footer are sized by their contents
m is resized to fill remainging space
)

HBS=: 0 : 0
           jhclose''
'title'    jhh1 'dynamic resize'
jhflex  'm'jhdiv jhfroma toJ fread jpath'~addons/ide/jhs/demo/jdemo08.ijs'
'footer'   jhhn 3;'page footer'
)

create=: 3 : 0
'jdemo08'jhr''
)

jev_get=: create
