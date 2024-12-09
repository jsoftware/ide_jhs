coclass'jdemo04'
coinsert'jhs'

HBS=: 0 : 0
jhclose'' NB. standard menu with close
jhh1'Controls with javascript and CSS'
'javascript:'
'which' jhspan'this is the which text'
jhbr,jhbr
'cb0'   jhchk 'chb 0';0
'cb1'   jhchk 'chk 1';1
jhbr
'rad0'  jhrad 'rad one';1;'radgroup'
'rad1'  jhrad 'rad two';0;'radgroup'
jhbr
'sel'   jhselect ('zero';'one';'two';'three';'four');1;0
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
<hr>This page has a few controls with simple javascript event handlers.
)

CSS=: 0 : 0
span.mark{color:green;}
)

JS=: 0 : 0
function show(){jbyid("which").innerHTML= JEV;}

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
function ev_rad0_click(){show();jsetchk(jform.jid.value,1);}
function ev_rad1_click(){show();jsetchk(jform.jid.value,1);}

// checkbox button handlers
function ev_cb0_click(){show();jflipchk(jform.jid.value);}
function ev_cb1_click(){show();jflipchk(jform.jid.value);}

function ev_sel_change()
{
 jbyid("which").innerHTML= JEV+" : "+jbyid("sel").selectedIndex;
}
)
