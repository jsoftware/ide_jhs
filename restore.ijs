
rest1=: 0 : 0
100 100 200 200 edit      '~addons/ide/jhs/util.ijs'
edit      '~/t1.ijs'
edit      '~/t1.ijs'
300 300 500 500 openx_jhs_ 'jfif'
open_jhs_ 'jfile'
load    :: fail  't1.ijs'
load    :: fail  'fubar'
load      '~addons/ide/jhs/util.ijs'
edit   :: fail   '~/wonderbread'
)

rest2=: 0 : 0
edit_jhs_ '~/t1.ijs'
open_jhs_ 'jfile'
open_jhs_ 'jfiles'
open_jhs_ 'jdebug'
)

NB.  ".each   <;._2 rest1

run=: 3 : 0
".each   <;._2 y
)

NB. following works in firefox but not in chrome
NB. jjs_jhs_'w= window.open("","jijx");setTimeout(function (){w.focus();},100);'



NB. jjs_jhs_'w=window.open("","jfif");if(null!=w)w.close();'


fail=: 3 : 0
echo 'failed: ',y
)

restore=: 3 : 0
edit :: fail '~addons/ide/jhs/util.ijs'
edit :: fail '~/t1.ijs'
edit :: fail '~/t1.ijs'
open_jhs_ :: fail'jfif'
open_jhs_ :: fail'jgrudge'
load :: fail 't1.ijs'
load :: fail 'fubar'
load :: fail '~addons/ide/jhs/util.ijs'
edit '~/wonderbread'
)