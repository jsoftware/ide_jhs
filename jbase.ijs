coclass'jbase'
coinsert'jhs'

NB. browser loads (usually from init) to get jijx in iframe

title=: 'jterm'

INC=: INC_splitter NB. css/js library files to include

HBS=: 0 : 0
'split' jhsplitv 'style="height:100vh;"'
  'jifr-jijx' jhiframe 'jijx';'';'flex:auto;' NB. messes up splitter height:100vh;width:100vw;'
jhdivz NB. close vertical
)
