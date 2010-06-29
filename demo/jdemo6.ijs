NB. jdemogrid app
coclass'jdemo6'
coinsert'jhs'
demo=: 'jdemo6.ijs'

B=:  0 : 0
jdemo jsep jide
'<h1>Grid Demo<h1>'
grid0   ^^
grid1
-
openijs ^^
desc
)

BIS=: 0 : 0
      
grid0   gridnumedit'g0';'';'';'gdata0__'
grid1   gridnumedit'g1';'';'';'gdata1__'
jdemo   href 'demo'
openijs hopenijs 'Open script: ';(PATH,'demo/',demo);demo;''
desc    desc
)

create=: 3 : 0
g0css=. gridnumeditcss'g0';'80px'
g1css=. gridnumeditcss'g1';'40px'
hr 'jdemo6';(css g0css,g1css);(js JS);B getbody BIS
)

jev_get=: create NB. browser get request

ev_g0_dd_enter=: gup
ev_g1_dd_enter=: gup

gup=: 3 : 0
mid=. getv'jmid'
sid=. getv'jsid'
gid=. mid{.~mid i.'_'
name=. getv gid,'_hh'
r=. (sid i.'*'){.sid
c=. (>:sid i.'*')}.sid
v=. {.0".getv gid,'_vv' NB. new grid cell value
d=. ".name 
d=. v (P=: <(".r);".c)}d
".name,'=: d'
ctotal=. ":(".c){+/d
rtotal=. ":(".r){+/"1 d
d=. mid,'*',sid,ASEP,(":v),ASEP,gid,'_cf*0*',c,ASEP,ctotal,ASEP,gid,'_rf*',r,'*0',ASEP,rtotal
htmlresponse d,~hajax rplc '<LENGTH>';":#d
)

desc=: 0 : 0
Edit global nouns gdata0__ and gdata1__.<br><br>

The grid numeric editor uses ajax. When a cell value is
changed, just 3 numbers (value,row,column) are sent to
to the server. The server updates the noun, calculates
new totals, and sends back 3 numbers
(possibly corrected value,new column total,new row total),
and then javascript updates just the affected cells.
)


JS=: 0 : 0
function gup()
{
 var t= jform.jmid.value;
 var gid= t.substring(0,t.indexOf("_"));
 jform.jtype.value= 'enter'; // change becomes enter
 jbyid(gid+"_vv").value= jbyid(gid+"_dd*"+jform.jsid.value).value;
 jdoh([gid+"_hh",gid+"_vv"]);
}

function ev_g0_dd_enter(){gup();}
function ev_g1_dd_enter(){gup();}

// leaving changed cell (tab,mouse,...)
// process as enter and return true to continue tab or ...
function ev_g0_dd_change(){gup();return true;}

function ev_g1_dd_change(){gup();return true;}

function rqupdate()
{
 var t= rq.responseText.split(ASEP);
 if(6!=t.length) alert("wrong number of ajax results");
 jbyid(t[0]).value=t[1];
 jbyid(t[2]).value=t[3];
 jbyid(t[4]).value=t[5];
}
)

