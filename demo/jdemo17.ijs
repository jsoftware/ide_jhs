coclass'jdemo17'
coinsert'jhs'
NB. play with csscore overrides ffor size (padding) for iphone

NB. 'jdemo17'jpage''
NB. JEVIDS=: jhjevids'pswd gn*sp gn*uc gn*di gn*sim gn*fan'

title=: 'jdemo16'

NB. html form definition for different events
HBS=:  0 : 0
NB. '<div>how now</div><br/>'
           jhclose''

NB. 'fuabr'jhb 'asdf'

NB.'<div class="menu">'
NB.'<span style="z-index:100"><span><a href="#" id="fool" name="fool" class="jhmg" onclick="return jmenuclick(event);" onblur="return jmenublur(event);" onfocus="return jmenufocus(event);" onkeyup="return jmenukeyup(event);" onkeydown="return jmenukeydown(event);" onkeypress="return jmenukeypress(event);">fool&#9660;&nbsp;</a></span><ul id="tool_ul">'
NB. '</ul></span></div><br/>'

NB. jhhr
NB. jhbr


jhma''
'mule'  jhmg'mule';1;16
'app'   jhmab'app'
'demo'  jhmab'demo'
'tour'  jhmg'tour';1;9
'over'  jhmab'overview'
'chart' jhmab'chart'
jhmz''

jhhr


'header'jhhn 3;'pswd app - no javascript' NB. header size 3
'pswd'  jhspan 'this is the password'
        jhhr                           NB. html horizonatal rule
'len'   jhspan'length: ',":10
'gn*up' jhb'▲'                         NB. button to increase length
'gn*dn' jhb'▼'
'epy'   jhspan'entropy: '
        jhbr                           NB. html line break
'gn*sp' jhcheckbox'%^& etc';0
'gn*uc' jhcheckbox'uppercase';0
'gn*di' jhcheckbox'digits';0
        jhbr
'gn'    jhb'generate'
'copy'  jhb'copy to clipboard'
        jhhr
'gn*sim'jhradio'simple css';1;'cssset' NB. csset radio button group
'gn*fan'jhradio'fancy css' ;0;'cssset'
        jhbr
        desc                         NB. desriptive text
        jhdemo''                     NB. link to open source script
)

menu=: 0 : 0
           jhma''
'tool'     jhmg'tool';1;16
 'app'     jhmab'app'
 'demo'    jhmab'demo'
'tour'     jhmg'tour';1;9
 'over'   jhmab'overview'
 'chart' jhmab'chart'
jhmz''
)

NB. count <xxx and </xxx
hcnt__=: 4 : 0
(+/('<',x) E. y),+/('</',x) E. y
)

CSS=: 0 : 0
.jhb  {margin: 2px; padding: 0px; background-color: <PC_BUTTON>;border: 2px solid black;}
.jhb  {margin: 2px; padding: 0px; background-color: <PC_BUTTON>;border: 2px solid black;padding:4px;padding-top:20px;padding-bottom:20px;}


/*.menu li{display:block;white-space:nowrap;padding:2px;color:#000;background:#eee;font-family:<PC_FONTFIXED>;}*/
/*.menu li{padding-top:20px;padding-bottom:20px;}*/

  .jhmab{display:block;height:40px;}

/*
  .jhmg {display:inline-block;height:40px;}
  .jhmg a:hover {cursor:pointer;color:#000;background:<PC_MENU_HOVER>;width:100%;}
*/

/*.menu ul{position:absolute;top:100%;left:0%;display:none;list-style:none;border:1px black solid;margin:0;padding: 0;}*/

/*.menu a{font-family:<PC_FONTFIXED>;padding:0px;}*/
  .menu a{padding-top:0px;padding-bottom:0px}*/

/*.menu a:hover{cursor:pointer;color:#000;background:<PC_MENU_HOVER>;width:100%;}

/*.menu span{float:left;   position:relative;}*/
  .menu span{float:left;   position:relative;margin:0;background-color:#eee;padding-top:20px;padding-bottom:20px;}
  .menu span{float:none;   position:relative;  margin:0;background-color:#eee;padding-top:20px;padding-bottom:20px;}


)


JS=: ''
