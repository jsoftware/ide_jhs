coclass'chkrad'
coinsert'jhs'

HBS=: 0 : 0
'get' jhb   'get'
'abc' jhchk 'ev_abc_click';0
'def' jhchk 'ev_jhchk_click';0
'ghi' jhchk 'ev_ghi_click';0
'jjj' jhchk 'only 1 arg'
'kkk' jhchk 'kkk';1;'ny'
'q*12'jhchk 'asdf'
jhbr
'xr1'  jhrad 'a00';0;'r1'
'xr2'  jhrad 'a11';1;'r1' 
'xr3'  jhrad 'a22';0;'r1'
jhbr NB. old style that need arg adjust
'r0'     jhrad  'r0 Aa'   ;1;'rg1'
'r1'     jhrad  'r1 /...' ;0;'rg1'
'r2'     jhrad  'r2 lines';0;'rg1'
'getchk' jhb  'get this button';0
'fubar'  jhb 'plain no jdoajax'
)

create=: 3 : 0
'test' jhrx (getcss''),(getjs''),gethbs''
)

NB. called when browser gets this page
jev_get=: create

ev_get_click=: 3 : 0
echo NV
jhrajax''
)

ev_getchk_click=: 3 :  0
echo NV
jhrajax''
)

CSS=: ''

JS=: 0 : 0

function ev_get_click(id){jdoajax(["abc","xr1"]);}

function ev_get_click_ajax(){;}


function ev_abc_click(id){jflipchk(id);}

function ev_ghi_click(id){jflipchk(id);} // ghi*foo

function ev_qqq_click(){alert([...document.querySelectorAll('[id]')].map(e => e.id).join(", "));jdoajax([]);}
function ev_qqq_click_ajax(){;};

function ev_r0_click(){jsetchk(jform.jid.value,1);} /* jform.jid.value is r0 */
function ev_r1_click(){jsetchk(jform.jid.value,1);}
function ev_r2_click(){jsetchk(jform.jid.value,1);}

function ev_getchk_click(){
 id= "r0";
 alert('getchk');
 alert(jbyid(id).getAttribute("data-jhscheck"));
 alert(jgetchk(id));
} 
 
function ev_getchk_click_ajax(){alert('ajax');}

function ev_fubar_click(){;}
)

