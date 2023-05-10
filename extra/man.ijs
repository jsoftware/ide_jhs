coclass'jman'

base9p=: 'git/base9/'

man_z_=: man_jman_

zloc=: <,'z'

0 :0
   man'pack'
   man'dir'
   man'pandas_load'
   man'notfound'
   man'dquotex'
)
NB. this is the first comment

NB. y is name - abc abc_jd_ abc__c
man=: 3 : 0
n=. dltb y
'__ not allowed in name' assert 0=+./'__'E. n
if. -.'_'={:n do.
 t=. 'nl 1 2 3' doin conl 0
 t=. ;(<<n)e. each t
 t=. t#conl 0
 
 if. zloc e. t do.  NB. remove z if it just points to a defn in another locale
  if. '_'={:5!:5 <n,'_z_' do.
   t=. t -. zloc
  end.
 end.  
 
 if. 0=#t do. 'not found'assert 0 end.
 if. 1<#t do. 
  tt=. (<n),each '_',each '_',~each t
  c=. 'choose',(1=#~.5!:1 tt)#' (they are the same defs)'
  r=. c,LF,;LF,~each(<'   man'''),each '''',~each tt
  return.
 end.
 n=. n,'_',(;t),'_'
end.
i=. 4!:4<n
'not an explicit defn defined by loading a script'assert i>0 
f=. i{4!:3''
t=. jpath'~system/'
if. t-: (#t){.;f do.
 dt=. {."1 dirtree base9p,'*.ijs'
 for_f. dt do.
  r=. (fread f) manx n
  if. -.r-:'not found' do. r break. end.
 end.
else. 
 r=. (fread f) manx n
end.
n,' ',(;f),LF,r
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

if. ')'=;h{bd do. NB. back up over one set of 0 : 0 lines
 t=. h{.bd
 a=. ;+./each (<'0 : 0') E. each t
 a=. a+.;+./each (<'0 :0') E. each t
 
 q__=. t
 
 
 a=. a+.;t=<,')'
 a=. a i: 1
  
  echo a
 
 h=. h-<:((#t)-a)*a<#t
end.

r=. (>:h)}.(>:i){.bdx
;r,each LF
)

doin=: 4 : '(<x)(4 : ''do__y x'')each<"0 y' NB. run sentence in each locale

