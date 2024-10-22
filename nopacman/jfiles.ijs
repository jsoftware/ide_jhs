NB. JHS - recent files
coclass'jfiles'
coinsert'jhs'

HBS=: 0 : 0
jhfcommon'jfiles'
jhresize''
files''
)

jev_get=: 3 : 0
'jfiles'jhr''
)

files=: 3 : 0
addrecent_jsp_''

if. 0=#SPFILES_jsp_ do.
 '</div>',~'<div>The recent files list is empty.'
else.
 '</div>',~'<div>',;fx each SPFILES_jsp_
end. 
)

fx=: 3 : 0
s=. ;shorts_jsp_ y
t=. jshortname y
NB.!f=. ;(1>.10-#s)#<'&nbsp;'
f=. ;(1>.10-#s)#<' '
(('file*',jurlencode t)jhab s,f,t),jhbr
)

CSS=: 0 : 0
*{font-family:PC_FONTFIXED;}
)

JS=: jsfcommon,0 : 0
function ev_body_load(){jresize();}

function ev_file_click(){
 t= 'jijs?jwid='+jsid.value,jsid.value;
 pageopen(t,t); //? nocache???
}

)


