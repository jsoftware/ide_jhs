coclass'jd3'
coinsert'jhs'

NB. css/js library files to include
INC=: INC_d3_basic 

NB. J sentences - create html body
HBS=: 0 : 0
'ga'jhd3_basic'' NB. ga,ga_... divs for d3_basic plot
)

NB. additional CSS
CSS=: 0 : 0
#ga_title{text-align:center;font-size:22pt;}
)

NB. J handlers for app events
jev_get=: 3 : 0
jwid=. getv'jwid'
'jd3'jhrx(getcss''),(getjs'TABDATA';(jwid,'_tabdata')~),gethbs''
)

NB. javascript
JS=: 0 : 0

tabdata="<TABDATA>"; // set by J jev_get handler

function ev_body_load()
{
document.title= window.name;
resize();
window.onresize= resize;
}

function resize()
{
jbyid("ga_box").style.width=window.innerWidth-20+"px";
jbyid("ga_box").style.height=window.innerHeight-20+"px";
plot("ga",tabdata);
}
