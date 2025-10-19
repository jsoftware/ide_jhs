coclass'jman'
man_z_=: man_jman_
zloc=: <,'z'

base9install=: 0 : 0
~system/base9 does not exist
manual install:
$ cd j9.6/system - jpath'~system'
$ git clone https://github.com/jsoftware/base9 base9
)

NB. y is name - abc abc_jd_ abc__c or locale _abc_
NB. finds script where name is defined
NB.  and displays NB. lines that are before the defn
NB. the NB. is removed and no other formating is done
NB. lines starting with *-+ probably indicate scriptdoc lines
NB. if defined in multiple scripts they are listed
NB. if script is in ~system - look for source script in base9
NB. man'_abc_' displays man lines for each name in the locale
NB. would be nice to support f* to return all matches
NB. finds a=:b=: 123 but does not find 'a b c'=: ... 
NB. perhaps base9 (<500k) should be included in base library
NB. 
NB. base library and JHS have NB. conventions that
NB.  allow extracting documention from scripts
NB. 
NB. base library convention has NB. lines
NB.  with first char *-+ for formatting
NB. 
NB. JHS convention is all NB. line before =: line
man=: 3 : 0
r=.  getman y
NB. remove NB.*blank and NB.blank 
r=. <;.2 r
b=. ;(<'NB.')=3{.each r
r=. (b*3)}.each r
jselect_jhs_ ;r
)

getman=: 3 : 0
n=. dltb y
if. '_'={.n do.
 t=. ('nl',n)~0 1 2 3
 t=. ;LF,~each(<''''),~each(<'   man'''),each t,each<n
 return.
end.
if. 0~:+./'__'E. n do. '__ not allowed in name' return. end.
if. -.'_'={:n do.
 t=. 'nl 0 1 2 3' doin conl 0
 t=. ;(<<n)e. each t
 t=. t#conl 0
 
 if. zloc e. t do.  NB. remove z if it just points to a defn in another locale
  if. '_'={:5!:5 <n,'_z_' do.
   t=. t -. zloc
  end.
 end.  
 
 if. 0=#t do. 'not found' return. end.
 if. 1<#t do. 
  tt=. (<n),each '_',each '_',~each t
  r=. ;LF,~each(<'   man'''),each '''',~each tt
  return.
 end.
 n=. n,'_',(;t),'_'
end.
i=. 4!:4<n
if. i<:0 do. 'not an explicit defn defined by loading a script' return. end. 
f=. i{4!:3''
t=. jpath'~system/'
if. t-: (#t){.;f do.
 NB. look for defn in base9
 p=. jpath'~system/base9'
 if. -.fexist p do. base9install return. end.
 dt=. {."1 dirtree p,'/*.ijs'
 for_f. dt do.
  r=. (fread f) manx n
  if. -.r-:'not found' do. r break. end.
 end.
else. 
 r=. (fread f) manx n
end.
r=. '   ',n,LF,('   edit''',(;f),''''),LF,(LF={.r)}.r
)

manx=: 4 : 0
d=. x
p=. ('_'={:y){::y; ((}:y)i:'_'){.y 
nna=. '(^|[^[:alnum:]_])'
nnz=. '($|[^[:alnum:]_])' NB. .: removed
gass=. '[[:space:]]*=:'
p=. nna,p,gass
b=. p rxmatches_jregex_ d
select. #b
case. 0 do. 'not found' return.
case. 1 do. 
case.   do. 'found: ',":#b
end.
bdx=. <;._2 d,LF
bd=. dltb each bdx

i=. {.{:{:b
i=. i+LF=i{d
i=. +/LF=i{.d

t=. i{.bd
a=. (;(<'NB.')=3{.each t)+.0=;#each t
h=. a i: 0

if. 0*.')'=;h{bd do. NB. back up over one set of 0 : 0 lines
 t=. h{.bd
 a=. ;+./each (<'0 : 0') E. each t
 a=. a+.;+./each (<'0 :0') E. each t
 a=. a+.;t=<,')'
 a=. a i: 1
 h=. h-<:((#t)-a)*a<#t
end.

r=. (>:h)}.(>:i){.bdx
;r,each LF
)

doin=: 4 : '(<x)(4 : ''do__y x'')each<"0 y' NB. run sentence in each locale

