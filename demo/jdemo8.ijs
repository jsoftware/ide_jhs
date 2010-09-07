coclass'jdemo8'
coinsert'jhs'

NB. do not use <h1> if sizing
NB. FF and IE get extra body background which
NB. throws off calcualations

NB. giving body and each div a different background color
NB. can be useful in figuring this stuff out

HBS=: 0 : 0
'a' jhdiv 'Dynamic resize'
'm' jhdiv jhfroma toJ fread jpath'~addons/ide/jhs/demo/jdemo8.ijs'
'z' jhdiv jhdemo''
)

CSS=: 0 : 0
#m{overflow:scroll;border:solid;border-width:1px;}
)

create=: 3 : 0
'jdemo9'jhr''
)

jev_get=: create

0 : 0
Window has 3 divs.<br>
Divs a and z are sized by their contents.<br>
Div m is resized to fill the window.
)

JS=: 0 : 0
window.onresize= resize;

function evload(){resize();} // body onload->jevload->evload

function resize(){
 var a= jgpwindowh(); // window height
 a-= jgpbodymh();     // body margin h (top+bottom)
 a-= jgpdivh("a");    // div a height
 a-= jgpdivh("z");    // div z height
 a-= 2               // 1px div border (top+bottom)
 a=  a<0?0:a;        // negative causes problems
 jbyid("m").style.height= a+"px";
}
)
