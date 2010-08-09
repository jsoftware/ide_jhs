coclass'jdemo4'
coinsert'jhs'
demo=: 'jdemo4.ijs'

B=:  0 : 0
jma abc jijx jfile foo
 def goo
 ghi moo koo
jmz ^^
jdemo
'<h1>Controls with javascript and CSS<h1>'
'javascript: ' which ^^
cb0  cb1             ^
rad0 rad1            ^^
sel                  ^^ 
text                 ^^
blue red
-
openijs              ^^
Ndesc  
)

BIS=: 0 : 0
abc    hmg'Abc'
 jijx    hml'ijx';''
 jfile   hml'open';''
 foo    hmab'do task foo';''
def    hmg'Def'
 goo    hmab'do task goo';''
ghi    hmg'More stuff'
 moo    hmab'do moo stuff';''
 koo    hmab'do koo again';''

which   '<span id="which">&nbsp;</span>'
sel     hsel ('zero';'one';'two';'three';'four');1;0
text    text
blue    hb'color blue'
red     hb'color red'
rad0    hradio'radio one';'radgroup'
rad1    hradio'radio two';'radgroup'
cb0     hc'checkbox 0';'cbgroup'
cb1     hc'checkbox 1';'cbgroup'
jdemo   href'jdemo'
openijs hopenijs'Open script: ';(PATH,'demo/',demo);demo;''
)

CSS=: 0 :0
span.red{color:green;}
)

text=: 0 : 0
Now is the <span id="one" class="red">time</span>
for all <span id="two" class="red">good</span>
folk to come to the party.
)

create=: 3 : 0
hr 'jdemo4';(css CSS);(js JS);B getbody BIS
)

ev_flip_click=: 3 : 0
hrajax (|.getv't1'),ASEP,(|.getv't2')
)

jev_get=: create NB. browser get request

Ndesc=: 0 : 0
This page has a few controls with minimal javascript event handlers.
)

JS=: 0 : 0
function show(){jbyid("which").innerHTML= JEV;}

// menu hide/show
function ev_abc_click(){menuclick();}
function ev_def_click(){menuclick();}
function ev_ghi_click(){menuclick();}

// menu commands
function ev_foo_click(){show();}
function ev_goo_click(){show();}
function ev_moo_click(){show();}
function ev_koo_click(){show();}

// set text span element (by id) blue
function ev_blue_click(){
 show();
 jbyid("one").style.color= "blue";
 jbyid("two").style.color= "blue";
}

// set text span element (by id) blue
function ev_red_click(){
 show();
 jbyid("one").style.color= "red";
 jbyid("two").style.color= "red";
}

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

