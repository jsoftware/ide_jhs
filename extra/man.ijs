coclass'jman'
man_z_=: man_jman_
zloc=: <,'z'

NB. y is name - abc abc_jd_ abc__c or locale - _jhs_
NB. display comments before definition in defining script
NB. if defining script is in ~system it looks for source script in base9
man=: 3 : 0
n=. dltb y
if. '_'={.n do.
 t=. ('nl',n)~1 2 3
 t=. ;LF,~each(<''''),~each(<'   man'''),each t,each<n
 return.
end.
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
  r=. ;LF,~each(<'   man'''),each '''',~each tt
  return.
 end.
 n=. n,'_',(;t),'_'
end.
i=. 4!:4<n
'not an explicit defn defined by loading a script'assert i>0 
f=. i{4!:3''
t=. jpath'~system/'
if. t-: (#t){.;f do.
 if._1=nc<'base9p' do.
  d=. dirpath'~'
  base9p=: ;{.(;+./each (<'/base9') E. each d)#d NB. look for folder named base9 for ~system source
 end. 
 if. 0=#base9p do. echo 'install git base9 source for ~system script defn comments' return.  end.
 dt=. {."1 dirtree base9p,'/*.ijs'
 for_f. dt do.
  r=. (fread f) manx n
  if. -.r-:'not found' do. r break. end.
 end.
else. 
 r=. (fread f) manx n
end.
'   ',n,LF,('   edit''',(;f),''''),LF,(LF={.r)}.r
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
