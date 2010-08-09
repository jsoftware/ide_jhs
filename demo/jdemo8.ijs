coclass'jdemo8'
coinsert'jhs'
demo=: 'jdemo8.ijs'

NB. do not use <h1> if resizing
NB. FF and IE get extra body background which
NB. throws off calcualations

NB. giving body and each div a different background color
NB. can be useful in figuring this stuff out

B=:  0 : 0
'<div id="a">'
 jdemo ^
 'Dynamic resize' ^^
'</div>'

'<div id="m">'
 Ndata
'</div>'

'<div id="z">'
 ^ openijs     ^^
 Ndesc
'</div>'
)

BIS=: 0 : 0
jdemo   href'jdemo'
openijs hopenijs'Open script: ';(PATH,'demo/',demo);demo;''
)

CSS=: 0 : 0
#m{overflow:scroll;border:solid;border-width:1px;}
)

create=: 3 : 0
hr 'jdemo8';(css CSS);(js JS);B getbody BIS
)

jev_get=: create

Ndata=: htmlfroma toJ fread PATH,'demo/',demo

Ndesc=: 0 : 0
Window has 3 divs.<br>
Divs a and z are sized by their contents.<br>
Div m is resized to fill the window.
)

JS=: 0 : 0
window.onresize= resize;

function evload(){resize();} // body onload->jevload->evload

function resize(){
 var a= gpwindowh(); // window height
 a-= gpbodymh();     // body margin h (top+bottom)
 a-= gpdivh("a");    // div a height
 a-= gpdivh("z");    // div z height
 a-= 2               // 1px div border (top+bottom)
 a=  a<0?0:a;        // negative causes problems
 document.getElementById("m").style.height= a+"px";
}
)
