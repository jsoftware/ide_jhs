NB. cobrowser for jhs - David Mitchell
NB. based on Oleg Kobchenko's version for wd, with updates.

NB. hit enter in jijx window to start after running this script.
  
coclass'cobrowser'
coinsert'jhs'

require '~addons/ide/jhs/misc/scriptdoc.ijs'
require '~addons/general/misc/clippaste.ijs'

NB.* jhclose*jhclose'' - cojhs close button and spacer
jhclose=: 3 : 0
'close'jhb'X'
)

TITLE=: 'Class Browser'
TYPES=: ;:'Noun Adverb Conj Verb All'

create=: 3 : 0
boxo=:9!:6''
shown=: 0
title=: 'cobrowser'
CURLOC=: 0{conl 0
menu0=: 0
CURINST=: <''
CURTYPE=: <'All'
CURNAME=: ''
CELLDATAT=:'Noun';'Adverb';'Conj';'Verb';'All'
menu2C=:;('<li><a>',(],&('</a></li>',LF)))&.>CELLDATAT
CUSTOMT=:('<ul id=menu2 class="positionDiv">',LF),menu2C,('</ul>',LF)
gloc_update ''
ginst_update ''
)

show=: 3 : 0
shown=: 1
y open ,~coname''
)

gloc_update=: 3 : 0
  CELLDATAL=: ,.NL=. nl 6
  menu0C=:;('<li><a>',(],&('</a></li>',LF)))&.>CELLDATAL
  CUSTOML=:('<ul id=menu0 class="positionDiv">',LF),menu0C,('</ul>',LF)  
)

gfmt=: 3 : 0
'a b c'=.y
((' ';'&nbsp')&stringreplace ) &.>(' ',~_3{.a);(' ',~_6{.b);c
)

ginst_update=: 3 : 0
  sif=. si=. empty''
  for_ref. inst=. CURLOC ((e. copath)"0 # ]) conl 1 do.
    if. 0=4!:0 <'COCREATOR__ref' do.
      c=. COCREATOR__ref
      n=. ":&.>conouns__c ref
    else. n=. c=. <'' end.
    si=. si,ref,n,c
    sif=. sif,gfmt ref,n,c
  end.
  CELLDATAI=: si,~3#<''
  CELLDATAIC=: sif,~3#<''
  menu1C=:;('<li><a>',(],&('</a></li>',LF)))&.><"1;"1 ('&nbsp&nbsp_';'';''),}.CELLDATAIC
  CUSTOMN=:('<ul id=menu1 class="positionDiv">',LF),menu1C,('</ul>',LF)
  CURINST=:(<0 0){CELLDATAI
  gname_update''
)

gname_update=: 3 : 0
  if. 0=#&>CURINST do. loc=. CURLOC else. loc=. CURINST end.
  NL=. nl__loc (-.CURTYPE-:<'All')#TYPES i.CURTYPE
  CL=. <"1(;2#<'&nbsp'),"0 1~'nacvd '{~ nc__loc NL
  CELLDATAN=: <"1;"1 CELLDATANM=:/:~CL,.NL
   if. #NL do. CURNAME=: {.NL else.CURNAME=: ''end.
  menu3C=:;('<li><a>',(],&('</a></li>',LF)))&.>CELLDATAN
  CUSTOMA=:('<ul id=menu3 class="positionDiv">',LF),menu3C,('</ul>',LF)
  if. 0<#CELLDATANM do. CURNAME=:(<0,1){CELLDATANM end.
  eview_update''
)

fx=: 3 : 0
t=. jhref 'jijs';y;y NB. (jpath y);s
t,'<br>'
)

eview_update=: 3 : 0
  view=: ''
  scr=: '[script]'
  sp=: '[space]'
  sh=: '[shape]'
  9!:7 '+++++++++|-'
  if. #CURNAME do.
    if. 0=#&>CURINST do. loc=. CURLOC else. loc=. CURINST end.
    name=. <(>CURNAME),'__loc'
    ni=. 4!:4 name
    if. 0<:ni do. 
     scr=: fx >ni{4!:3'' 
    else. scr=: 'defined in session' end.
    sp=: 'c'>@(8!:0) 7!:5 name
    if. 0=nc name do.
      if. 2 ((>#@$)*.(=3!:0)) v=. (>name)~ do.
        view=: v
      else. view=: ,,&LF"1((1 1,:_2+$) ];.0 ]) ":<v end.
      sh=: ":$v
    else.
      if. 3=nc name do. sh=. ":(>name)~ b.0 end.
      view=: 5!:5 name
    end.
  end.
  eview=:'<textarea readonly id=textdisp class="positionDiv jcode" spellcheck="false">',view,'</textarea>'
  stscript=:'<div id=stscript class="positionDiv jcode">',scr,'</div>'
  stspace=:'<div id=stspace class="positionDiv jcode">',sp,'</div>'
  stshape=:'<div id=stshape class="positionDiv jcode">',sh,'</div>'
  9!:7 boxo
)

destroy=: 3 : 0
if. shown do. close ;coname'' end.
codestroy''
)

ev_close_click=: 3 : 0
jhrajax''
destroy''
)

myedit=: 3 : 0
'n s'=. y
file=. {.,getscripts_j_ s
dat=. 1!:1 :: _1: file
if. dat -: _1 do.
  'file read error: ',,>file return.
end.
dat=. toJ dat
dat=. < @ (;: :: <) ;._2 dat,LF
ndx=. I. (1: e. (n;'=:')&E.) &> dat
if. 0 = #ndx do.
  m=. }:(2<:+/\.n='_')#n
  ndx=. I. (1: e. (m;'=:')&E.) &> dat
end.
edit MYOPEN=:>file
)

ev_menu0_menuselect=: 3 : 0
menu0=:<:0".getv'jdata' NB. remove bug fix +1
CURLOC=:0{menu0{CELLDATAL
ginst_update''
jhrajax JASEP joinstring menu1C; menu3C; view; scr; sp; sh
)

ev_menu1_menuselect=: 3 : 0
menu1=:<:0".getv'jdata' NB. remove bug fix +1
CURINST=:(<menu1,0){CELLDATAI
gname_update''
jhrajax JASEP joinstring menu3C; view; scr; sp; sh
)

ev_menu2_menuselect=: 3 : 0
menu2=:<:0".getv'jdata' NB. remove bug fix +1
CURTYPE=:menu2{CELLDATAT
gname_update''
jhrajax JASEP joinstring menu3C;view; scr; sp; sh
)

ev_menu3_menuselect=: 3 : 0
menu3=:<:0".getv'jdata' NB. remove bug fix +1
CURNAME=:(<menu3,1){CELLDATANM
eview_update''
jhrajax JASEP joinstring view; scr; sp; sh
)

ev_refresh_click=: 3 : 0
menu0=:0
gloc_update''
CURLOC=:0{menu0{CELLDATAL
ginst_update''
jhrajax JASEP joinstring menu0C; menu1C; menu3C; view; scr; sp; sh
)

curname=: 3 : 0
  if. 0=#CURNAME do. ''return. end.
  if. 0=#&>CURINST do. loc=. CURLOC else. loc=. CURINST end.
  if. 0>ni=. 4!:4 name=.<(>CURNAME),'_',(>loc),'_'do. ''return. end.
  name
)

ev_open_click=: 3 : 0
 if. 0<#ni=. 4!:4 name=. curname'' do. 
  myedit CURNAME,ni{4!:3''
 end.
jhrajax ''
)

ev_scriptdoc_click=: 3 : 0
  if. 0<#ni=. 4!:4 name=. curname'' do. 
   sdtxt=:>scriptdocsum_jscriptdoc_ >ni{4!:3''
  else.
   sdtxt=:'None'
  end.
jhrajax sdtxt
)

curname=: 3 : 0
  if. 0=#CURNAME do. ''return. end.
  if. 0=#&>CURINST do. loc=. CURLOC else. loc=. CURINST end.
  if. 0>ni=. 4!:4 name=.<(>CURNAME),'_',(>loc),'_'do. ''return. end.
  name
)

ev_copyname_click=: 3 : 0
 if. IFWIN do. setcliptext >curname'' end.
 jhrajax ''
)

ev_copypath_click=: 3 : 0
 if. 0<ni=. 4!:4 name=. curname'' do.  
  if. IFWIN do. setclipfiles ni{4!:3'' end.
 end.
jhrajax ''
)

HBS=: 0 : 0
jhclose''
'<div id="data" class="jcode"><TEXT></div>'
'<div id=tb class="toolbar positionDiv ">'
'<button id="refresh" title=Refresh></button>'
'<button id="open" title=Open></button>'
'<button id="scriptdoc" title=Scriptdoc></button>'
'<button id="copyname" title="Copy Name"></button>'
'<button id="copypath" title="Copy Path"></button>'
'</div>'
'<div id=menu0h class="positionDiv jcode">Locales</div>'
'<div id=menu1h class="positionDiv jcode">&nbsp # │ Name │ At </div>'
'<div id=menu2h class="positionDiv jcode">Types</div>'
'<div id=menu3h class="positionDiv jcode">&nbsp │Names</div>'
CUSTOML
CUSTOMN
CUSTOMT
CUSTOMA
eview
stshape
stspace
stscript
)

CSS=: 0 : 0
textarea {
  resize: none;
}

.toolbar {
  font-size: .75em;
}
button.ui-button-icon-only
{
    width: 32px !important;
    height: 32px !important;
}
#close{ padding-left:3px }
form{margin:2px;}
#menu0{ width: 150px; height: 200px; overflow: auto }
#menu1{ width: 220px; height: 200px; overflow: auto  }
#menu2{ width: 80px; height: 200px; overflow: auto  }
#menu3{ width: 300px; height: 400px;overflow: auto  }
#textdisp{ width: 462px; height: 195px;overflow: auto }
#stspace{ width:50; text-align:right }
#stscript{ font-size: 0.7em }
.positionDiv {
position: absolute;
}
/* jQuery UI theme settings */
.ui-menu .ui-menu-item {
    margin: 1px;
    border: 1px solid transparent;
}

.ui-menu .ui-menu-item a.ui-state-highlight { 
    font-weight: normal; 
    margin: -1px; 
}
.ui-menu-item-wrapper {
    font-family: courier new,courier,monospace;
}
)

jev_get=: 3 : 0
title jhrx (getcss''),(getjs ''),gethbs'NAME TEXT';'data';'<p class=jcode positionDiv>J Class Browser</p>'
)

JS=: 0 : 0
 
function ev_refresh_click(e) {
 jdoajax( ["id"] )
}

function ev_refresh_click_ajax(ts) {
 $( "#menu0" ).empty();
 $( "#menu0" ).append(ts[0]);
 $( "#menu0" ).menu("refresh");
 $( "#menu0" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" ); 
 $( "#menu1" ).empty();
 $( "#menu1" ).append(ts[1]);
 $( "#menu1" ).menu("refresh");
 $( "#menu1" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#menu3" ).empty();
 $( "#menu3" ).append(ts[2]);
 $( "#menu3" ).menu("refresh");
 $( "#menu3" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#textdisp" ).html(ts[3]);
 $( "#stscript" ).html(ts[4]);
 $( "#stspace" ).html(ts[5]);
 $( "#stshape" ).html(ts[6])
}

function ev_open_click(e) {
 jdoajax( ["id"] )
}

function ev_open_click_ajax(ts) {
}

function ev_scriptdoc_click(e) {
 jdoajax(["id"] )
}

function ev_scriptdoc_click_ajax(ts) {
document.getElementById('stscript').title = ts;
}

function ev_copyname_click(e) {
 jdoajax( ["id"] )
}

function ev_copyname_click_ajax(ts) {
}

function ev_copypath_click(e) {
 jdoajax( ["id"] )
}

function ev_copypath_click_ajax(ts) {
}

function ev_menu0_menuselect() {
 var d = jform.index;
 jdoajax( ["index"], d );
}

function ev_menu0_menuselect_ajax(ts) {
 $( "#menu1" ).empty();
 $( "#menu1" ).append(ts[0]);
 $( "#menu1" ).menu("refresh");
 $( "#menu1" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#menu3" ).empty();
 $( "#menu3" ).append(ts[1]);
 $( "#menu3" ).menu("refresh");
 $( "#menu3" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#textdisp" ).html(ts[2]);
 $( "#stscript" ).html(ts[3]);
 $( "#stspace" ).html(ts[4]);
 $( "#stshape" ).html(ts[5])
}

function ev_menu1_menuselect() {
 var d = jform.index;
 jdoajax( ["index"], d );
}

function ev_menu1_menuselect_ajax(ts) {
 $( "#menu3" ).empty();
 $( "#menu3" ).append(ts[0]);
 $( "#menu3" ).menu("refresh");
 $( "#menu3" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#textdisp" ).html(ts[1]);
 $( "#stscript" ).html(ts[2]);
 $( "#stspace" ).html(ts[3]);
 $( "#stshape" ).html(ts[4])
}

function ev_menu2_menuselect() {
 var d = jform.index;
 jdoajax( ["index"], d );
}

function ev_menu2_menuselect_ajax(ts) {
 $( "#menu3" ).empty();
 $( "#menu3" ).append(ts[0]);
 $( "#menu3" ).menu("refresh");
 $( "#menu3" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#textdisp" ).html(ts[1]);
 $( "#stscript" ).html(ts[2]);
 $( "#stspace" ).html(ts[3]);
 $( "#stshape" ).html(ts[4]);
}

function ev_menu3_menuselect() {
 var d = jform.index;
 jdoajax( ["index"], d );
}

function ev_menu3_menuselect_ajax(ts) {
 $( "#textdisp" ).html(ts[0]);
 $( "#stscript" ).html(ts[1]);
 $( "#stspace" ).html(ts[2]);
 $( "#stshape" ).html(ts[3]);
}

function menuselect( t, e, ui ) {
        
    // Remove the highlight class from any existing items.
    t.find( "a.ui-state-highlight" )
             .removeClass( "ui-state-highlight" );
 
    // Adds the "ui-state-highlight" class to the selected item.
    ui.item.find( "> a" )
           .addClass( "ui-state-highlight ui-corner-all" );    
           
    // Calls ev_menu0_select 
    var d = ui.item.index();
    jform.index = d+1; // bug in later || with 0
    jev(e);
}
    
function ev_body_load(){
 var basicControls = [ "#refresh", "#open", "#scriptdoc", "#copyname", "#copypath" ];
 $( basicControls.join(", ") ).on( "click change selectmenuchange",this.id,jev );
    
 $( "#refresh" ).button({
  icon: "ui-icon-refresh",
  showLabel: false
 });
 $( "#open" ).button({
  icon: "ui-icon-folder-open",
  showLabel: false
 });
 $( "#scriptdoc" ).button({
  icon: "ui-icon-help",
  showLabel: false
 });
 $( "#copyname" ).button({
  icon: "ui-icon-copy",
  showLabel: false
 });
 $( "#copypath" ).button({
  icon: "ui-icon-link",
  showLabel: false
 });
 $( ".toolbar" ).controlgroup();

 $( "#menu0" ).menu({       
     select: function( e, ui ) { menuselect( $( this ), e, ui ); }
 });
 $( "#menu0" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#menu1" ).menu({
      select: function( e, ui ) { menuselect( $( this ), e, ui ); }
 });
 $( "#menu1" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#menu2" ).menu({
      select: function( e, ui ) { menuselect( $( this ), e, ui ); }
 });
 $( "#menu2" ).find( "a:eq(4)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#menu3" ).menu({
      select: function( e, ui ) { menuselect( $( this ), e, ui ); }
 });
 $( "#menu3" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 
 $( ".toolbar" ).position({
  my: "left top",
  at: "left bottom",
  of: "#data"
 });
 $( "#menu0h" ).position({
  my: "left top",
  at: "left bottom",
  of: ".toolbar"
 });
 $( "#menu0" ).position({
  my: "left top",
  at: "left bottom",
  of: "#menu0h"
 });
 $( "#menu1" ).position({
  my: "left top",
  at: "right top",
  of: "#menu0"
 });
 $( "#menu2" ).position({
  my: "left top",
  at: "right top",
  of: "#menu1"
 });
 $( "#menu3" ).position({
  my: "left top",
  at: "right top",
  of: "#menu2"
 });
 $( "#menu1h" ).position({
  my: "left bottom",
  at: "left top",
  of: "#menu1"
 });
 $( "#menu2h" ).position({
  my: "left bottom",
  at: "left top",
  of: "#menu2"
 });
 $( "#menu3h" ).position({
  my: "left bottom",
  at: "left top",
  of: "#menu3"
 });
 $( "#textdisp" ).position({
  my: "left top",
  at: "left bottom",
  of: "#menu0"
 });
 $( "#stshape" ).position({
  my: "left top",
  at: "left bottom",
  of: "#menu3"
 });
 $( "#stspace" ).position({
  my: "right top",
  at: "right-50 bottom",
  of: "#menu3"
 });
 $( "#stscript" ).position({
  my: "left top",
  at: "left bottom",
  of: "#textdisp"
 });
 $( "#data" ).position({
  my: "left top",
  at: "right top+3",
  of: "#close"
 });

}
)

INC=: 0 : 0
~addons/ide/jhs/js/jquery/smoothness/jquery-ui.custom.css
~addons/ide/jhs/js/jquery-ui-1.12.1.hc3-custom/jquery-ui.min.css"
~addons/ide/jhs/js/jquery-ui-1.12.1.hc3-custom/jquery-ui.theme.min.css
~addons/ide/jhs/js/jquery-ui-1.12.1.hc3-custom/jquery-3.2.1.min.js
~addons/ide/jhs/js/jquery-ui-1.12.1.hc3-custom/jquery-ui.min.js
)

'cobrowser'cojhs ''
