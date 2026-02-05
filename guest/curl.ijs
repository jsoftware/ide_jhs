tmplate=: 'curl -k -<BC> cookies.txt -o curl.txt https://<URL>:65101/'
NB. curl access to JHS node server

localurl=: '10.0.0.161'
serverurl=: 'server.jsoftware.com'

NB. init localurl or serverurl
init=: 3 : 0
cc=: tmplate hrplc_jhs_ 'BC URL';'c';y
cb=: tmplate hrplc_jhs_ 'BC URL';'b';y
)
curl=: 3 : 0
ferase 'cookies.txt';'curl.txt'

run cc,'jguest'
echo  ;{:<;.2 fread 'cookies.txt'

6!:3[1

run cb,'jbase'
run cb,'favicon.ico'
)


run=: 3 : 0
shell y
echo 100{.(fread 'curl.txt')-.CRLF
)


