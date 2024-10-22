coclass'app03'
coinsert'jhs'

0 : 0
study CSS=: lines to see how they change html look and feel
CSS can be complicated
online validators or visual studio code can help
CSS is powerful - cut/paste can get you a long ways
but serious use requires study of the exensive online resources
)

how=: 0 :  0
cautiously change CSS in textarea at bottom and press set (e.g., change first line salmon to red and press set)</br></br>

css errors are generally forgiving (perhaps not the desired effect, but not a crash)</br></br>

css is a rich language and is well documented on the web</br></br>

css statment is:</br>
selector { property : value ;}</br>
selector #abc applys to element with id abc</br>
selector .jhb applys to elements with class jhb</br></br>

selector can select more than 1 element and there can be multiple property:value pairs</br></br>

try out a few simple changes to get a feel for things</br>
)
      
NB. sentences that define html elements
HBS=: 0 : 0
jhclose''
'title'  jhh1  'css custmizing look and feel'
'how'    jhdiv   how
'hr'     jhline''
'e*text' jhtext 'text'
'e*pswd' jhpassword '<password>'
'e*b0'   jhb'lots of extra text'
'e*b1'   jhb'less text'
         jhbr
'e*bg2' jhb 'first'
'e*bg3' jhb 'second'
'set'    jhb'set css'
'ta'     jhtextarea ''
)

NB. <PS_FONTCODE> is replaced by:
NB.  font-family:"courier new","courier","monospace";font-weight:550;white-space:pre;

CSS=: 0 : 0
#set{background-color:salmon;}
#set{display:block;margin:auto;width:50%;}
#text{background-color: lightblue;}
#text:focus{background-color: yellow;}
#pswd:hover{background-color: pink;}
/* jhb class with id prefix e*bg */
.jhb[id^="e*bg"]{width: 20em; color:red;}
#hr{background-color:black;height:1em;}
#ta{<PS_FONTCODE>} 
#ta{width:100%;height:24em;}
#how{background-image:
  linear-gradient(pink,plum,aqua);}
)

manapp=: 'jpage y must be '''''

ev_create=: 3 : 0 NB. called by page or browser to initialize locale
manapp assert ''-:y
jhrcmds 'set ta *',CSS
)

ev_set_click=: {{
jhrcmds 'css *',getv'ta'
}}

ev_e_click=: {{
'mid sid type'=. getvs'jmid jsid jtype'
jhrcmds 'set e*text *',mid,'*',sid,' ',type
}}

ev_e_enter=: ev_e_click

