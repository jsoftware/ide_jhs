coclass'jsp'

0 : 0
define project verbs

default SPFILE is: ~temp/sp/spfile.ijs
template is: ~addons/ide/jhs/spfile_template.ijs

   man'jhsclosepages'
   man'jhsoption'
   man'jhsflex'
)

p_example=: 3 : 0
jhsclosepages''
jhsoption'term column'
'jfile'jpage''
edit '~Projects/jhs/example/example.ijs'
jhsflex 50
testdata=: i.3 4
)

NB. define your p_name verb here

splist'' NB. echo project sentences