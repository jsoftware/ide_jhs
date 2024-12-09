NB. browser for jhs
NB. based on Oleg Kobchenko's version for j6 wd
NB. modified to run with Jqt
NB. modified by David Mitchell for JHS with jquery
NB. this modification to run for JHS without javascript
  
coclass'jlocale'
coinsert'jhs'

TITLE=: 'jlocale'

MAXDEF=: 20000 NB. max size to display in def div

fx=: 3 : 0
jhref 'jijs';y;y NB. (jpath y);s
)

NB. y is exclude 0 or 1 - initialize all
init=: 3 : 0
t=. conl 0
if. y do. t=. ('j'~:;{.each t)#t end.
d=.   <'set locsdiv *','locsdiv'  jhdiv 'locs'  jhselect t;5;0
d=. d,<'set atsdiv *','ats'   jhselect (cobinst {.t);5;0
d=. d,<'set namesdiv *', 'names' jhselect (cobnames ({.t);0 1 2 3);5;0
d=. d,<'set rep *undefined'
d=. d,<'set def *'
)

cobfmt=: 3 : 0
'a b c'=.y
a,' ',b,' ',c
)

NB. y is loc - return ats contents
cobinst=: 3 : 0
  sif=. <'_'
  for_ref. inst=. y ((e. copath)"0 # ]) conl 1 do.
    if. 0=4!:0 <'COCREATOR__ref' do.
      c=. COCREATOR__ref
      n=. ":&.>conouns__c ref
    else. n=. c=. <'X' end.
    sif=. sif,<cobfmt ref,n,c
  end.
  sif
)

cobview=: 3 : 0
 'name loc'=. y
  rep=. 'undefined'
  undef=. '';'undefined';''
  if. '_'={.name do. undef return. end.
  name=. <name,'_',loc,'_'
  if. _1=nc name do. undef return. end.
    ni=. 4!:4 name
    if. 0<:ni do. sc=. fx >ni{4!:3'' else. sc=. 'defined in session' end.
    sp=. 'c'>@(8!:0) 7!:5 name
    if. 0=nc name do.
      v=. (>name)~
      rep=. datatype v
      view=. utf8_from_jboxdraw jhtmlfroma fmt0 ":v
      rep=. rep,' shape:',(":$v),' space:',sp
    else.
      rep=. >(<:nc name){'adverb';'conjunction';'verb'
      rep=. rep,' space:',sp
      view=. 5!:5 name
    end.
  if. MAXDEF<7!:5 name do. view=. 'too big...',LF,'...' end.
  view;((>name),' ',rep);sc
)


cobdef=: 3 : 0
'c a n'=. getvs'locs ats names'
if. '_'~:{.a do. c=. <(a i.' '){.a end.
'view rep sc'=. cobview n;c
 a=. (jhtmlfroma rep),' ',sc,'<br>'
('set rep *',a);'set def *',jhtmlfroma view
)

getnlarg=: 3 : 0
0 1 2 3#~;0".each getvs'nl*noun nl*adverb nl*conj nl*verb'
)


cobnames=: 3 : 0
'c a'=. y
'_';nl__c a
)

NB. runs as class STATIC instance (no object)
NB. to run as OBJECT - define ev_create and remove jev_get 
xev_create=: 3 : 0
jhcmds init 0
)

jev_get=: 3 : 0
jhcmds init 0
TITLE jhr''
)

ev_locs_change=: 3 : 0
c=. <getv'locs'
d=. 'set namesdiv *','names'  jhselect (cobnames c;getnlarg'');5;0
t=. cobinst c
d=. (cobdef''),d;'set atsdiv *','ats' jhselect t;5;0
jhrcmds d
)

ev_ats_change=: 3 : 0
d=. getv'ats'
c=. <(d i.' '){.d
if. c-:<,'_' do.  c=. <getv'locs' end.
jhrcmds (cobdef''),<'set namesdiv *','names' jhselect (cobnames c;getnlarg'');5;0
)

ev_names_change=: 3 : 0
jhrcmds cobdef''
)

ev_nl_click=: ev_ats_change

ev_exclude_click=: 3 : 0
jhrcmds init 0".getv'exclude'
)

HBS=: 0 : 0
jhmenu''
'menu0'  jhmenugroup ''
         jhmpage''
'close'  jhmenuitem 'close';'q'
         jhmenugroupz''

jhmpagez''

'nl*noun'   jhchk 'noun';1
'nl*adverb' jhchk 'adverb';1
'nl*conj'   jhchk 'conjunction';1
'nl*verb'   jhchk 'verb';1
'exclude'   jhchk 'exclude j...';0
'locsdiv'   jhdiv ''
'atsdiv'    jhdiv ''
'namesdiv'  jhdiv ''
'rep'       jhdiv ''
jhhr
'def'       jhdiv ''
)

CSS=: 0 : 0
*.jhdiv,select,option{<PS_FONTCODE>}
select{min-width:100px;max-width:200px;float:left;min-height:300px;}
hr{clear:both;}
#rep{clear:both;float:left;}
#def{clear:both;float:left;min-width:300px;}
)
