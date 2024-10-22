coclass'handlers'
coinsert'jhs'

run__=: 'handlers'&jpage
ld__=:  [: load '~addons/ide/jhs/' , ]

NB. test html jh... event handlers

section=: 3 : 'jhhr,''<font style="color:red;">'',y,''</font>'',jhbr'

HBS=: 0 : 0
jhclose''
'clr'   jhb'clr'
'jstext' jhtext'';20
'jtext'  jhtext'';20
section'jhb buttons'
'b01'   jhb 'b01 js only'
'b02'   jhb 'b02 js jdoajax jhrajax'
'b03'   jhb 'b03 js jdoajax jhrjson'
'b04'   jhb 'b04 js jdoajax jhrcmds'
'b05'   jhb 'b05 j only jhrcmds'
'b09'   jhb 'b09<b>bbb,</b>def'
'b10'   jhb 'b10c<b>bbb</b>def';'jhb';'='
'b11*1' jhb 'b11*1'
'b11*2' jhb 'b11*2'
'b12'   jhb 'b12 no js and ~ option';'';'~'
section'jhb with errors'
'b06'   jhb 'b06 jev not defined'
'b07'   jhb 'b07 jev error'
'b08'   jhb 'b08 jev no ajax response'
section'jhchk/jhrad with default js calling j handler'
'cx01'  jhchk 'cx01'
'cx02'  jhchk 'cxo2'
'rx01'  jhrad 'rx01';0;'rd0'
'rx02'  jhrad 'rx02';1;'rd0'
section'jhchk/jhrad without handlers ~ option'
'c01' jhchk 'c01';0;'';'';'~'         NB. 'jhchk';default_marks;'~'
'c02' jhchk 'co2';0;'';'';'~'
'r01' jhrad 'rad1';'r01';0;'';'';'~'  NB. 'jhrad';default_marks;'~'
'r02' jhrad 'rad1';'ro2';1;'';'';'~'
section'jhab'
'a01' jhab 'a01'
'a02' jhab 'a02'
'a03' jhab 'a<b>b</b>c'
section'jhselect'
jhhr
's01' jhselect ('s01 abc';'d<b>B</b>c';'ghi');0;0
's02' jhselect ('s02 123';'456';'789');0;0;'';'~' NB. size;selected;class;options
section'jhtext'
't01'   jhtext 't01 handler'
't02'   jhtext 't02 <b>"</b>';'';'';'~' NB. size;class;'~'
'b30'   jhb'b30'
'p01'   jhpassword '<password>'
'p02' jhpassword '<password>';'';'';'~' NB. size;class;'~'
section'jhtable'
'table' jhtable''
 jhtr 'longer label:' ; ('tab00'jhtext'') ; 'a:'     ; 'tab01'jhtext''
 jhtr 'medium:'       ; 'plain text'      ; 'bbbb:'  ; 'tab11'jhtext''
 jhtr 'short:'        ; 'tab20'jhtext''
 jhtr ''              ; ''                ; 'dd:'    ; 't31'jhb'button'           
jhtablez
)

ev_create=: 3 : 0
jhrcmds''
)

NB. jev_get=: jpageget         NB. called by browser to load page

cmds=: {{
 q__=:NV
 t=. 'set jtext *',getv'jmid'
 if. 0~:#getv'jstext' do. t=. t;'set jstext *' end.
 jhrcmds t
}}

ev_b02_click=: {{ jhrajax 'b02 ajax''"<b>x' }}
ev_b03_click=: {{ jhrjson 'text';'b03 json' }}
ev_b04_click=: cmds 
ev_b05_click=: cmds

ev_cx01_click=: cmds
ev_cx02_click=: cmds
ev_rx01_click=: cmds
ev_rx02_click=: cmds

ev_b07_click=: {{ +a.}}
ev_b08_click=: {{ a=. 5 }}

ev_s01_change=: cmds

ev_t01_enter=: cmds
ev_p01_enter=: cmds

ev_a01_click=: cmds
ev_a02_click=: cmds
ev_a03_click=: cmds

CSS=: 0 : 0
table, th, td {border: 1px solid;}
)

NB. javascript code - initialize page and handle events
JS=: 0 : 0

function ev_clr_click(){clr();}

function  clr(){jset('jstext','');jset('jtext','');}
function  set(){clr();jset('jstext',jform.jid.value);}
function setx(){set();jdoajax([]);}

function  xxxset(){clr();jset('jstext',jform.jid.value);}

function ev_b01_click(){xxxset();}

function ev_b02_click(){setx();}
function ev_b02_click_ajax(ts){jset('jtext',ts[0]);}

function ev_b03_click(){setx();}
function ev_b03_click_ajax_json(t){jset('jtext',t.text);}

function ev_b04_click(){setx();} // ajaxcmds runs automatically

function ev_b09_click(){set();}
function ev_b10_click(){set();}
function ev_b11_click(){set();}

)
