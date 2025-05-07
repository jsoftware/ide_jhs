coclass'jbase'
coinsert'jhs'

NB. browser loads (usually from init) to get jijx in iframe

title=: 'jterm'

NB. J lines run in jhs locale that define html for the page
HBS=: 0 : 0
jhdivz
'<iframe src="jijx"  id="jifr-jijx"></iframe>'
jhdiva''
)
