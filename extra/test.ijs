coclass'test'
coinsert'jhs'

RELOAD__=: '~addons/ide/jhs/extra/test.ijs'

run__=: 3 : 0
 'test;2000 10 400 800'jpage''
)

NB. move 20
move__=: 3 : 0
   jjs_jhs_'{var spacer= allwins[1].jbyid("spacer");var testw= allwins[1]; testw.mover(spacer,false, M);}' rplc 'M';":y
)

manapp=: 'jpage y must be ''''' NB. doc jpage y arg

INC=: INC_splitter NB. css/js library files to include

HBS=: 0 : 0
'split' jhsplitv 'style="height:100vh;"'
 
  NB.jhiframe 'jijx';'';'flex:auto;'
  NB. jhiframe 'jijx';'';'flex: auto;' NB. height works!!! nojumps
  jhclose''

  '<div id="aadiv" style="flex:auto;">aa</div>'

  'spacer' jhsplits ''
  '<div id="bbdiv" style="flex:auto;">bb</div>'

 'cc' jhsplits ''
 '<div id="ccdiv" style="flex:auto;">cc</div>'

 'dd' jhsplits ''
 '<div id="dddiv" style="flex:auto;">dd</div>'
 
jhdivz NB. close vertical
)

NB. jpage (or url) calls to init page for browser
ev_create=: 3 : 0 
manapp assert ''-:y
jhcmds ''
)

