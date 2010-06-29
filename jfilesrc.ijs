NB. JHS - file source stuff - plot.pdf plot.svg favicon.ico ...
coclass'jfilesrc'
coinsert'jhs'

getfile=: 3 : '(>:y i: PS)}.y' NB. filename from fullname

NB. pdf stuff

pdfbody=: 0 : 0
<body>
<object type="application/pdf" data="<FILE>#toolbar=1&navpanes=0&scrollbar=0"></object>
</body>
)

pdfastyle=: hcss 0 : 0
 html, body, div, object{margin:0; padding:0; height:100%; width:100%;}
 object{display:block; border:none;} 
 form{margin:0; padding:0}
)

NB. y pdf filename - ~home relative
pdfresponse=: 3 : 0
1!:4<jpath y NB. jbad failure if file does not exist
t=. pdfbody rplc '<FILE>';y
hr (getfile y);pdfastyle;'';t
)

pdfhead=: 0 : 0
HTTP/1.1 200 OK
Accept-Ranges: bytes
Content-Type: application/pdf
Content-Length: LENGTH

)

NB. return pdf application/pdf response to object data= request
pdfget=: 3 : 0
d=. 1!:1 <jpath y
htmlresponse d,~pdfhead rplc 'LENGTH';":#d
)

jpdfplot__=: 3 : 0
('plot.pdf';'title plot.pdf';1) jpdfplot y
:
1!:5 :: [ <jpath'~temp\pdf' NB. ensure pdf folder exists
load'~addons/plot/plot.ijs'
'file options link'=. x
t=. 'output pdf "<FILE>" 480 360;<OPTIONS>'
t=. t rplc '<FILE>';(jpath'~temp/pdf/',file);'<OPTIONS>';options 
t plot y
if. 1-:link do. jhtml'<a href="jfile?mid=open&path=~temp/pdf/',file,'">~temp/pdf/',file,'</a>' end.
i.0 0
)

NB.! no longer supported - display troubles in jijx 
xxxjpdfshow__=: 3 : 0
if. (fexist jpath y)*.'.pdf'-:_4{.y do.
 jhtml'<object type="application/pdf" data="',y,'#toolbar=1&navpanes=0&scrollbar=1" width="100%" height="200"></object>'
else.
 'file does not exists or is not .pdf'13!:8[3
end.
)

NB. svg stuff

hsvg=: 0 : 0
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg  viewBox="0 0 1000 1000" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<rect x="20" y="20" width="960" height="960"
style="fill:none;stroke-width:5;
stroke:black"/>

<polyline points="<POINTS>"
style="fill:none;stroke:red;stroke-width:3"/>

</svg> 
)

NB. fill:white;

NB. (file;options;link) jsvgplot data
NB. create ~temp/svg/file
NB. will be full plot output - for now just plot the lines
jsvgplot__=: 3 : 0
('plot.svg';'';1) jsvgplot y
:
'file options link'=. x
1!:5 :: [ <jpath'~temp\svg' NB. ensure svg folder exists
dy=. 950-y*900%>./y
dx=. 50+(i.#y)*900%<:#y
d=. dx,.dy
d=. <.0.5+d
d=. ;' ',each ":each d
d=. hsvg_jfilesrc_ rplc '<POINTS>';d
d fwrite jpath f=. jpath'~temp/svg/',file
if. 1-:link do. jhtml'<a href="jfile?mid=open&path=~temp/svg/',file,'">~temp/svg/',file,'</a>' end.
i.0 0
)

jsvghref__=: 3 : 0
jhtml'<a href="jfile?mid=open&path=~temp/svg/plot.svg">svg</a>'
)

svgbody=: 0 : 0
<body>
<object type=image/svg+xml data="<FILE>" width="100%" height="100%"></object>
</body>
)

NB. y pdf filename - ~home relative
svgresponse=: 3 : 0
t=. svgbody rplc '<FILE>';y
hr (getfile y);'';svgjs;t
)

svghead=: 0 : 0
HTTP/1.1 200 OK
Accept-Ranges: bytes
Content-Type: image/svg+xml
Content-Length: LENGTH

)

NB. return svg response to object data= request
svgget=: 3 : 0
try.
 d=. 1!:1 <jpath y
catch.
 d=. svg404 NB. must return good svg or we hang
end.
 htmlresponse d,~svghead rplc 'LENGTH';":#d
)

NB. not used - jsvgshow insists file exists
svg404=: 0 : 0
<?xml version="1.0"?>
<svg 
version="1.1" 
xmlns="http://www.w3.org/2000/svg"
xmlns:xlink="http://www.w3.org/1999/xlink"
style="background-color: #FF0000;">
</svg>
)

NB.! no longer supported - jijx requires refresh which is unfortunate
NB. y file name (must not be absolute - must have ~home prefix)
NB. x name=value pairs - default 'width=200 height=200'
NB. 'width=100% height=100'
NB. IE must be in body and not in form! (otherwise htc parentnode troubles)
NB. IE7 supports FF type data - older IE requires src classid?
xxjsvgshow__=: 3 : 0
'width=200 height=200' jsvgshow y
:
if. (fexist jpath y)*.'.svg'-:_4{.y do.
 jhtml'<object type=image/svg+xml data="',y,'"',x,'></object>'
else.
 'file does not exists or is not .svg'13!:8[3
end.
)

NB.! inline svg no longer supported
NB. didn't display with ajax update and requires parge refresh
NB. similar problems with pdf
NB. wait for canvas!

NB. similar to jsvgshow, but inline
NB. doesn't display directly in IE or FF
NB. does display on a refresh
NB. presumably would take width and height 
jsvginline__=: 3 : 0
d=. fread jpath y
d=. d}.~1 i.~'<svg' E. d
jhtml '<script type="image/svg+xml">',d,'</script>'
)

gsrchead=: 0 : 0
HTTP/1.1 200 OK
Server: JHS
Last-Modified: Mon, 01 Mar 2010 00:23:24 GMT
Accept-Ranges: bytes
Content-Length: <LENGTH>
Keep-Alive: timeout=15, max=100
Connection: Keep-Alive
Content-Type: <TYPE>

)

NB. y is svg.js htc swf - x is content-type
gsrcf=: 4 : 0
d=. 1!:1<jpath '~addons/ide/jhs/src/',y
htmlresponse d,~gsrchead rplc '<TYPE>';x;'<LENGTH>';":#d
)

jev_getsrcfile=: 3 : 0
if. y-:'favicon.ico' do.
 favicon 0 
elseif. '.pdf'-:_4{.y do.
 pdfget y
elseif. '.svg'-:_4{.y do.
 svgget y
elseif. '.js'-:_3{.y do.
 'application/x-javascript'gsrcf y
elseif. '.htc'-:_4{.y do.
 'text/x-component'gsrcf y
elseif. '.swf'-:_4{.y do.
 'application/x-shockwave-flash'gsrcf y
elseif. 1 do.
 smoutput 'do not get files of type: ',y
end. 
)

favicon=: 3 : 0
htmlresponse htmlfav,1!:1 <jpath'~bin\icons\favicon.ico'
)

htmlfav=: 0 : 0
HTTP/1.1 200 OK
Server: J
Accept-Ranges: bytes
Content-Length: 1150
Keep-Alive: timeout=15, max=100
Connection: Keep-Alive
Content-Type: image/x-icon

)
