NB. J HTTP Server - ijs app
coclass'jijs'
coinsert'jhs'

jev_get=: 3 : 0
create jnew''
) 

B=: 0 : 0 NB. body template
'<div id="z">'
 run + save jsep jide
 report
 filename filenamed
'</div>'
textarea
)

BIS=: 0 : 0 NB. body template id-sentence pairs
report    '<div id="rep"></div>'
filename  hh'<FILENAME>'
filenamed '<div id="filenamed"><FILENAME></div>'
run       hab'run'
save      hab'save'
textarea  htarea'<DATA>'
)

createbody=: 3 : 0
(B getbody BIS)hrplc y
)

CSS=: 0 : 0
#rep{color:red}
#filenamed{color:blue;}
textarea{width:100%;}
*{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
)

NB. y if fullfilename
create=: 3 : 0
try. d=. 1!:1<y catch. d=. 'file read failed' end.
hr (getfile y);(css CSS);(JSCORE,JS);createbody 'FILENAME DATA';y;d
)

save=: 3 : 0
if. #USERNAME do.
 fu=. jpath'~user'
 'save only allowed to ~user paths' assert fu-:(#fu){.y
end.
(toHOST getv'textarea')1!:2<y
)

ev_save_click=: 3 : 0
f=. jpath getv'filename'
try.
 save f
 ajaxresponse 'saved without error'
catch.
 ajaxresponse htmlfroma 13!:12''
end.
)

ev_run_click=: 3 : 0
f=. jpath getv'filename'
try.
 save f
 load__ f
 ajaxresponse 'ran saved without error'
catch.
 ajaxresponse htmlfroma 13!:12''
end.
)

NB. new ijs temp filename
jnew=: 3 : 0
d=. 1!:0 jpath '~temp\*.ijs'
a=. 0, {.@:(0&".)@> _4 }. each {."1 d
a=. ": {. (i. >: #a) -. a
f=. <jpath'~temp\',a,'.ijs'
'' 1!:2 f
>f
)

getfile=: 3 : '(>:y i: PS)}.y' NB. filename from fullname

JS=: hjs 0 : 0
window.onresize= resize;
window.onfocus= xfocus;
var fixedh; var saved; var ta; var but;

function evload() // body onload->jevload->evload
{
 ta= document.j.textarea;
 but= document.j.jbutton;
 resize();
 saved= ta.value;
 ta.focus();
}

function xfocus(){ta.focus();}

function ctrl_comma(){jev("run","click");}
function ctrl_dot()  {jev("save","click")}

function ev_save_click(){jdoh(["filename","textarea"]);}
function ev_run_click(){jdoh(["filename","textarea"]);}

function rqupdate(){jbyid("rep").innerHTML= rq.responseText;}

function resize(){
 var a= gpwindowh();      // window height
 a-= gpbodymh();          // body margin h (top+bottom)
 a-= gpdivh("z");         // div z height
 a=  a<10?0:a;            // - not allowed
 ta.style.height= a+"px"; // size ta to fit
}
)


