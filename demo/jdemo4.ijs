coclass'jdemo4'
coinsert'jhs'

HBS=: 0 : 0
jhma''
'abc'    jhmg'Abc';1;8
 'foo'   jhmab'do foo  d^' NB. d keyboard shortcut
'def'    jhmg'Def';1;8
 'goo'   jhmab'do goo'
'ghi'    jhmg'More stuff';1;8
 'moo'   jhmab'do moo'
 'koo'   jhmab'do koo'
jhmz''

jhh1'Controls with javascript and CSS'
'javascript:'
'which' jhspan''
jhbr,jhbr
'cb0'   jhckb'checkbox 0';'cbgroup';0
'cb1'   jhckb'checkbox 1';'cbgroup';1
jhbr
'rad0'  jhradio'radio one';'radgroup';1
'rad1'  jhradio'radio two';'radgroup';0
jhbr
'sel'   jhsel ('zero';'one';'two';'three';'four');1;0
jhbr
text
jhbr
'blue'  jhb'color blue'
'red'   jhb'color red'
jhbr
desc  
jhdemo''
)

text=: 0 : 0
Now is the <span id="one" class="mark">time</span>
for all <span id="two" class="mark">good</span>
folk to come to the party.
)

create=: 3 : 0
'jdemo4'jhr''
)

jev_get=: create

desc=: 0 : 0
<br/>This page has a few controls with simple javascript event handlers.
)

CSS=: 0 :0
span.mark{color:green;}
)

JS=: 0 : 0
function show(){jbyid("which").innerHTML= JEV;}

// menu commands
function ev_foo_click(){show();}
function ev_goo_click(){show();}
function ev_moo_click(){show();}
function ev_koo_click(){show();}

function ev_d_shortcut(){jbyid("which").innerHTML= "ev_d_shortcut";}

function color(c)
{
 show();
 jbyid("one").style.color=c;
 jbyid("two").style.color=c;
}

// set text span elements blue
function ev_blue_click(){color("blue");}

// set text span elements red
function ev_red_click(){color("red");}

// radio button handlers
function ev_rad0_click(){show();return true;}
function ev_rad1_click(){show();return true;}

// checkbox button handlers
function ev_cb0_click(){show();return true;}
function ev_cb1_click(){show();return true;}

function ev_sel_click()
{
 jbyid("which").innerHTML= JEV+" : "+jbyid("sel").selectedIndex;
}
)