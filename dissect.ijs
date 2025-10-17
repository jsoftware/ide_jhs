load'~addons/ide/jhs/gl2.ijs' NB. first
load'~addons/ide/jhs/widget/jhjcanvas.ijs'
NB. Jqt dissect code is loaded and modified at the end of this script

dtest=: 3 : 0
select. y
case. 0 do. dissect 'a ([ + (+/ % #)@]) z' [ a =. 6 5 3 [ z =. 3 9 6 */ 1 5 9 2 
case. 1 do. dissect'a+b+a'[a=. b=. i.200 200
end.
)

0 : 0
bugs can leave dissect damaged - possible patch to avoid restart
   dissectionlist_dissect_=:     (,:($0);10 10)

overview of locales

JHS dissect locale
 caller     - locale of dissect main locale
 mcan       - locale of canvas widget
 explocs    - locales of JHS explorer locales
 explorer   - locale of last explorer locale created
 exploresd  - system data from ctrl click as arg to explore button

JHS explorer locale
 caller     - locale of dissect element locale
 mcan       - locale of canvas widget
 parent     - locale of main JHS locale

JHSFORM_z_   - form locale that is wd target
JHSCANVAS_z_ - canvas locale - buffer__JHSCANVAS is target for jsc... and gl... cmds
)


NB. RESIZEHANDLEXYWH_dissect_ =: 2 2 $ _6 _6 12 12

coclass'dissectjhs'
coinsert'jhs'
coinsert'jhjcanvas'

NB. JHS dissect config
NB. JHS uses standard dissect ~config/dissect.ijs
config=: 3 : 0 
c_dxywh=: ":10  10 600 600 NB. dissect paints main based on config % and qscreen
c_exywh=: ":10 720 800 150
c_font=:  '11pt ',PC_FONTFIXED_jhs_
)

config''

NB. create dissect page - y is locale of dissect caller
pcdissect=: {{
t=. 'dissectjhs;',c_dxywh
p=. t jpage''[y 
qd__=: p
caller__p=: y
JHSFORM_z_=: p
}}

NB. create explore page - y is locale of dissect caller
pcexplore=: {{
parent=. JHSFORM
p=. 'dissectjhsexplore;_;explorer'jpage''
explocs__parent=: explocs__parent,p
explorer__parent=: p
caller__p=: y NB. dissect locale that owns this form
parent__p=: parent   NB. main JHS dissect locale 

NB. may need these before load has finished and they are set
new=. mcan__p
old=. mcan__parent
canvasfontheight__new=: canvasfontheight__old
canvasfontwidth__new=:  canvasfontwidth__old

JHSFORM_z_=: p
}}

tutinitial=: 0 : 0
JHS interface to dissect tool<br>
&bull; shift+click element - tutorial<br>
&bull; ctrl+click data and then press explore button<br>
&bull; gentler learning curve if familiar with JHS and Jqt dissect<br>
&bull; hovering does not show tooltips - shift+click required<br>
&bull; right mouse click is not currently supported<br>
&bull; not currently integrated with debug<br>
)

whvals=: ":each<"0[ 5 10 20 30 40 50 60 70 80
fpvals=: ":each<"0[ 1+i.9

HBS=: 0 : 0
        jhmenu ''
'menu0' jhmenugroup ''
'help'  jhmenuitem'help'
'pref'  jhmenuitem'preferences'
'using'    jhmenuitem'using dissect'
'learning' jhmenuitem'learning dissect'
'wikidissect' jhmenuitem 'Dissect wiki'
'wikinuvoc'   jhmenuitem 'NuVoc wiki'
'close' jhmenuitem 'close';'q'
        jhmenugroupz''

'prefs' jhdiva''
jhtablea 
jhtr '% data width:'      ; 'dx' jhselect whvals;1;1
jhtr '% data height:'     ; 'dy' jhselect whvals;1;1
jhtr '% explore width:'   ; 'ex' jhselect whvals;1;1
jhtr '% explore height:'  ; 'ey' jhselect whvals;1;1
jhtr 'float precision'    ; 'fp' jhselect fpvals;1;1
jhtablez
'fmshowcompmods'   jhchk   'show full compound-name'
jhbr
'fmshowstructmods' jhchk   'show @ @: hook fork etc'
jhbr
'fmautoexpand2'    jhchk   'Show u/ on 2 items as dyad'
jhbr
'fmshowfillcalc'   jhchk   'Show when frame replaced by fills'
jhdivz
        
'reset' jhb'<<'
'undo'  jhb'<' NB. dissect_fmbwd_button
'redo'  jhb'>'
'explore' jhb'explore'
NB. test'  jhb'test'
'stat'  jhspan'statline'
'tut'   jhdiv tutinitial
'</div>' NB. enable flex
'mcan'  jhiframe (;'mcan'~);'';'flex:auto;' 
'<div>'  NB. restart main div
)

CSS=: 0 : 0
#mcan{width:100vw;height:100vh;border: 2px solid red;}
#tut{position:absolute;top:4em;left:0;background-color:lightblue;width:50vw;max-height:50vh;
 overflow-y:auto;word-wrap:normal;padding:15px;border:solid 2px black;}
#prefs{position:absolute;top:4em;left:0;background-color:lightblue;display:none;border:solid 2px black;}
.jhchk{background-color:lightblue;}
)

ev_create=: 3 : 0
wdcmds=: ''
explocs=: '' NB. explorer locales
mcan=: 'jhjcanvas;_'jpage ''
setrefresh__mcan jsxnew jscfont jsxucp c_font

NB. shown=: 1
)

destroy=: 3 : 0
destroy__mcan'' NB.destroy locale - do not need to close iframe window
destroy__explorer''    NB. destroy explorer windows

NB. should destroy all explorer locales
if. shown do. close ;coname'' end.
codestroy''
)

qshow=: 3 : 0
jwd'setproperty <ID> display *block' rplc'<ID>';y
)

qhide=: 3 : 0
jwd'setproperty <ID> display *none' rplc'<ID>';y
)

ev_pref_click=: 3 : 0
qhide'tut'
qshow'prefs'
dmax=. <.100*maxnoundisplayfrac__caller
emax=. <.100*MAXEXPLORERDISPLAYFRAC__caller
emax=. emax,(1=#emax)#emax
jwd'set dx *',":1{dmax
jwd'set dy *',":0{dmax
jwd'set ex *',":1{emax
jwd'set ey *',":0{emax
jwd'set fp *',":displayprecision__caller
jwd'set fmshowcompmods *',  ":displayshowcompmods__caller
jwd'set fmshowstructmods *',":displayshowstructmods__caller
jwd'set fmautoexpand2 *',   ":displayautoexpand2__caller
jwd'set fmshowfillcalc *',  ":displayshowfillcalc__caller
jhrcmds''
)

dochange=: 3 : 0
dissect_dissectisi_paint__caller 1 NB. internal call does recalc
paint''
)

ev_dy_change=: ev_dx_change=: 3 : 0
d=. 0.01*;10".each getvs'dy dx'
maxnoundisplayfrac__caller=: d
dochange''
)

ev_ey_change=: ev_ex_change=: 3 : 0
d=. 0.01*;10".each getvs'ey ex'
MAXEXPLORERDISPLAYFRAC__caller=: d
dochange''
)

ev_fp_change=: 3 : 0
displayprecision__caller=: 2".getv'fp'
dochange''
)

ev_fmshowcompmods_click=: 3 : 0
displayshowcompmods__caller=: 0".getv'fmshowcompmods'
dochange''
)

ev_fmshowstructmods_click=: 3 : 0
displayshowstructmods__caller=: 0".getv'fmshowstructmods'
dochange''
)

ev_fmautoexpand2_click=: 3 : 0
displayautoexpand2__caller=: 0".getv'fmautoexpand2'
dochange''
)

ev_fmshowfillcalc_click=: 3 : 0
displayshowfillcalc__caller=: 0".getv'fmshowfillcalc'
dochange''
)

ev_help_click=: 3 : 0
qhide'prefs'
qshow'tut'
jhrcmds'set tut *',tutinitial
)

ev_learning_click=: 3 : 0
qshow'tut'
jhrcmds'set tut *',helptext_dissecthelplearning_
)

ev_using_click=: 3 : 0
qshow'tut'
jhrcmds'set tut *',helptext_dissecthelpusing_
)

ev_wikidissect_click=: 3 : 0
jhrcmds'urlopen *','https://code.jsoftware.com/wiki/Vocabulary/Dissect',LF,''
)

ev_wikinuvoc_click=: 3 : 0
jhrcmds'urlopen *','https://code.jsoftware.com/wiki/NuVoc',LF,''
)

NB. take over the destroy stuff
ev_close_click=: 3 : 0
destroy__caller'' NB. destroy dissect locales
destroy__mcan'' NB.destroy locale - do not need to close iframe window

for_c. explocs do.
 jwd'close ',;c
end. 

shown=: 0 NB. already closed
codestroy''
jhrcmds''
i.0 0
)

ev_reset_click=: 3 : 0
dissect_fmshowerror_button__caller ''
paint''
)

ev_undo_click=: 3 : 0
dissect_fmbwd_button__caller ''
paint''
)

ev_redo_click=: 3 : 0
dissect_fmfwd_button__caller ''
paint''
)

ev_explore_click=: 3 : 0
JHSFORM_z_=: coname''        NB.psel
JHSCANVAS_z_=: mcan__JHSFORM NB. gsel

qhide'prefs'
qhide'tut'

start=. JHSFORM
erase'explorer' NB. kludge communicate through global
if. 0~:nc<'exploresd' do. exploresd=: ":12#0 end.
sysdata__caller=: ":exploresd
dissect_dissectisi_mbrdown__caller ''
exploresd=: ":12#0

NB. no psel done so not a valid explore
if. start=JHSFORM do.
  qshow'tut'
  jhrcmds 'set tut *',jhfromax'data area to explore not selected',LF,'select data area with ctrl+click and then press explore again'
  return.
end. 

NB. runexplorer did not create new one so show old one
if. _1=nc<'explorer' do. jhrcmds 'show ',(":;JHSFORM),' *' return. end.

NB. runexplorer created new one
c=. explorer
t=. ;(Num_j_ e.~{.;c){(,~c);(;{.copath c),'?jlocale=',;c
t=. (0".c_exywh) pageopenargs t
c=. 'pageopen *',}:;t,each LF
jhrcmds c
)

ev_test_click=: 3 :0
jhrcmds''
)

NB. all canvas events come here - fan out to handler
ev_mcan_canvas=: 3 : 0
NB. ensure we are wd and gl targets
wd_dissect_'psel ',;coname''
glsel 'mcan'
sysdata__caller=: ":eventdata__mcan

if. eventtype__mcan-:'down' do.
 qhide'tut'
 qhide'prefs'
end. 

select. eventtype__mcan
case. 'resize' do. ev_mouse_resize''
case. 'move'   do. ev_mouse_move''
case. 'down'   do. ev_mouse_down''
case. 'up'     do. ev_mouse_up''
case.          do. jhrcmds''
end.
)


ev_mouse_down=: 3 : 0
sd=. eventdata__mcan
if. 1=7{sd do. NB. shift key is request for tutorial
  (0 1 ; sd) hoverstart__caller 1 0{sd
  tut=. hoverdo__caller ''
  hoverend__caller''
  if. #tut do.  qshow'tut' end.
  jhrcmds'set tut *',jhfromax tut
  return.
end. 

if. 1=6{sd do. NB. ctrl key is request for explorer
 sd=. 0 (6})sd
 exploresd=: sd
 jhrcmds''
 return.
end.

dissect_dissectisi_mbldown__caller ''
jhrcmds''
)

ev_mouse_up=: 3 : 0
dissect_dissectisi_mblup__caller ''
paint''
)

ev_mouse_move=: 3 : 0
dissect_dissectisi_mmove__caller ''
paint''
)

ev_mouse_resize=: 3 : 0
dissect_dissectisi_paint__caller 1
paint''
)

paint_explorer=: 3 : 0
c=. ''
for_e. explocs do.
 a=. mcan__e NB. canvas locale
 if. 0=#buffer__a do. continue. end. NB. only if there is new buffer data 
 NB. clear out old stuff - clearRect - MAXEXPLORERDISPLAYFRAC changed
 NB. 
 c=. c,<'canvasjs ',(;e),'+mcan  *',jsxarg 0 9 35 102 102 48 48 48 48 102 102 6 0 9 4 0 0 ,canvaswidth__a,canvasheight__a,7 0 8 0
 bufferresize__a=: buffer__a
 c=. c,<'canvasjs ',(;e),'+mcan  *',jsxarg buffer__a
 buffer__a=: '' NB. JHSCANVAS might not be set
end.
c
)

paint=: 3 : 0
jwd'canvasjs ','mcan',' *',jsxarg jsxnew''

for_wdc. wdcmds do.
  b=. ;wdc
  t=.  'set fmstatline *'
  if. t-:(#t){.b do.
    status=. (#t)}.b
    jwd'set stat *',status
  end. 

  t=.  'set tut *'
  if. t-:(#t){.b do.
    t=. jhfromax_jhs_ (#t)}.b
    qshow'tut'
    jwd'set tut *',t
 end.
  
end.  
wdcmds=: '' NB. wd commands have been done

jwd paint_explorer''
jhrcmds''
)

NB. explorer ----------------------------------------------------------------------

coclass'dissectjhsexplore'
coinsert'jhs'
coinsert'jhjcanvas'

HBS=: 0 : 0
jhclose 9}.title NB. wd pn - drop Exploring
NB. 'test' jhb'test'
'</div>' NB. enable flex
'mcan'   jhiframe (;'mcan'~);'';'flex:auto;'
'<div>'  NB. restart main div
)

CSS=: 0 : 0
#mcan{width:100vw;height:100vh;border: 2px solid red;}
)

ev_create=: 3 : 0
mcan=: 'jhjcanvas;_'jpage ''
setrefresh__mcan jsxnew jscfont jsxucp c_font_dissectjhs_ NB.! c_font should come from main
NB. shown=: 1
)

NB. explorer window is closed with jhrcmds in parent
destroy=: 3 : 0
destroy__mcan'' NB.destroy canvas locale - do not need to close iframe window
if. shown do. close ;coname'' end.
codestroy''
)

NB. all explorer canvas events come here - fan out to handler
ev_mcan_canvas=: 3 : 0
NB. ensure we are wd and gl targets
wd_dissect_'psel ',;coname''
glsel 'mcan'
sysdata__caller=: ":eventdata__mcan
select. eventtype__mcan
case. 'resize' do. ev_mouse_resize''
case. 'move'   do. ev_mouse_move''
case. 'down'   do. ev_mouse_down''
case. 'up'     do. ev_mouse_up''
case.          do. jhrcmds''
end.
)

ev_close_click=: 3 : 0
if. caller e. conl 1 do.
 destroyexplorer__caller'' NB. destroy dissect locale info on this form
 explocs__parent=: explocs__parent -. coname''
end.
destroy''
shown=: 0 NB. already closed
jhrcmds''
i.0 0
)

ev_test_click=: 3 : 0
jhrcmds''
)

ev_mouse_down=: 3 : 0
explorer_dissectisi_mbldown__caller ''
jhrcmds''
)

NB. click to select new value won't update until update triggered by main form
ev_mouse_up=: 3 : 0
explorer_dissectisi_mblup__caller ''
paint''
)

ev_mouse_move=: 3 : 0
if. 1~:4{eventdata__mcan do. jhrcmds'' return. end.
explorer_dissectisi_mmove__caller ''
paint''
)

ev_mouse_resize=: 3 : 0
if. 0=nc<'bufferresize__JHSCANVAS' do. buffer__JHSCANVAS=: bufferresize__JHSCANVAS end.
paint''
)

paint=: 3 : 0
NB. maybe just exit if buffer is empty???
if. 0~:#buffer__JHSCANVAS do. bufferresize__JHSCANVAS=: buffer__JHSCANVAS end. NB. resize uses last painted buffer

jwd'canvasjs ','mcan',' *',jsxarg jsxnew buffer__JHSCANVAS

NB. may need to paint main form canvas
a=. mcan__parent
if. 0~:#buffer__a do.
 jwd'canvasjs ',(":;parent),'+mcan  *',jsxarg buffer__a
 buffer__a=: '' NB. clear away what has been painted
end.

jhrcmds''
)

NB.$ load Jqt dissect and define our versions

NB. override htmltoplain before it is used in the load
htmltoplain_dissecthelplearning_=: htmltoplain_dissecthelpusing_=: [

load'~addons/debug/dissect/dissect.ijs'

reflowtooltip_dissect_=: 4 : 'y' NB. avoid converting tooltip to pixels

hoverstart_dissect_=: 4 : 0
'opts sd' =. x
'isexp writestat' =. opts
hoverinitloc=: y
hoverisexp=: isexp
if. writestat do. statlinedo y end.
)

hoverdo_dissect_=: 3 : 0
  NB. Get the locale of the object.  If we are on an explorer, it's just that; if on the main, we have to
  NB. look for the pickrect
  if. hoverisexp do.
    pickloc =. coname''
    yx =. hoverinitloc
  else.
    if. #pr =. locpickrects (_1 findpickhits) hoverinitloc do.
      'l yx' =. {. pr
      pickloc =. l { picklocs
    else.
      pickloc =. ''
NB.?lintonly yx =. 0 0
    end.
  end.
NB.?lintonly pickloc =. <'dissectobj'
  hstring=. ''
  if. #pickloc do.
QP^:DEBMOUSE'hoverdo:hwnd=?winhwnd wd''qhwndp'' hoverisexp pickloc '
    if. 3 = 4!:0 <'hoverDO__pickloc' do.
      hstring =. hoverDO__pickloc hoverisexp;yx
    end.
  end.  
  hstring
)

hoverend_dissect_=: 3 : 0
hoverinitloc =: $0
)

drawtooltip_dissect_=: [

NB. list of wd cmds that echo - only first cmd - psel;pshow sees only psel
wdlist__=: ;:'' NB. pc qhwnd ...

NB. JHS dissect wd stuff
NB. wd command can be single command or multiple commands delimited by ;
NB. for now we only handle up to first ;
wd_dissect_=: 3 : 0
c=. (y i.' '){.y
if. (<c)e.wdlist__ do. echo 'wd: ',60{.,y rplc LF;'' end.
select. c
case. 'pc' do.
 t=. deb (y i.';'){.y
 if. t-:'pc dissect' do.
  pcdissect_dissectjhs_ coname''
 elseif. t-:'pc explorer' do.
  pcexplore_dissectjhs_ coname''
 elseif. do.
  'unnknown pc'assert 0
 end. 

case. 'psel'        do.
  t=. deb (y i.';'){.y
  JHSFORM_z_=:   <0".5}.t NB. form locale for wd cmds
  JHSCANVAS_z_=: mcan__JHSFORM NB. psel gets default target - sometimes no gsel

case. 'pshow'       do. ''

case. 'qscreen'     do. '0 0 ',":2{.0".getv_jhs_'jinfo' NB. screen.availableWidth height
case. 'qchildxywhx' do. '0 0 ',":glqwh''
case. 'qform'       do. '0 0 ',":glqwh'' 
case. 'qformx'      do. '0 0 ',":glqwh''
case. 'qhwndp'      do. ;JHSFORM
case. 'set'         do. wdcmds__JHSFORM=: wdcmds__JHSFORM,<y
case. 'pn'          do. title__JHSFORM=: (>:y i.'*')}.y
case. 'setenable'   do. ''
case. 'timer'       do.  
case.               do. NB. echo 'no wd defn'
end.
)
