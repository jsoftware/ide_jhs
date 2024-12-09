coclass'jcopy'
coinsert'jhs'
require'~addons/convert/misc/base64.ijs'

NB.copy files between server and client machines

mkdir_j_ '~/uploads'
'test'fwrite'~/uploads/test.txt'

NB. sentences that define html elements
HBS=: 0 : 0
jhmenu''
'menu0'  jhmenugroup ''
         jhmpage''
'close'  jhmenuitem 'close';'q'
         jhmenugroupz''
jhmpagez''

'puttitle'    jhtitle 'copy client file xxx to server ~/uploads/xxx'
'<input id="fileupload" type="file" name="fileupload" />'
'putf'     jhhidden''
'putrep'   jhdiv'&nbsp;'
'put'      jhb 'put'
'<hr>'
'gettitle'    jhtitle 'copy server file ~/uploads/xxx to client downloads'
'selspan' jhspan 'getsel'jhselect ((#jpath'~/uploads/')}.each 1 dir'~/uploads/');1;0
'refresh'  jhb'refresh select list'
'getrep'   jhdiv'&nbsp;'
'get'      jhb 'get'
)

create=: 3 : 0
'jcopy' jhr ''
)

jev_get=: 3 : 0
create ''
)

ev_put_click=: 3 : 0
d=: frombase64 getv'jdata'
f=. getv'putf'
d fwrite '~/uploads/',f
jhrjson 'put';'OK: ',f
)

ev_get_click=: 3 : 0
f=. getv'getsel'
try.
 jhrjson d__=: 'rep';('OK: ',f);'data';tobase64 fread '~/uploads/',f
catch. 
 jhrjson 'rep';'file does not exist: ',f
end. 
)

ev_refresh_click=: 3 : 0
 jhrjson 'list';'getsel'jhselect ((#jpath'~/uploads/')}.each 1 dir'~/uploads/');1;0
)

ev_downtar_click=: 3 : 0
echo'downtar'
shell'tar -czf taruser.tgz j9.5-user'
jhrjson d__=: 'rep';('OK: taruser.tgz');'data';tobase64 fread 'taruser.tgz'
)

CSS=: 0 : 0
*{font-family:PC_FONTFIXED;}
)

NB. javascript code - initialize page and handle events
JS=: 0 : 0

function ev_put_click(){
var f=fileupload.files[0];
if(undefined==f)
 jbyid('putrep').innerHTML = "no file selected";
else
 {
  jset("putf",fileupload.files[0].name);
  read(fileupload.files[0]);
 }
}

function read(file) {
  const reader = new FileReader();
  reader.addEventListener('load', (event) => {
    s= arrayBufferToBase64(event.target.result);
    jdoajax(["putf"],s);
  });
  reader.readAsArrayBuffer(file);
}

function arrayBufferToBase64( buffer ) {
 var binary = '';
 var bytes = new Uint8Array( buffer );
 var len = bytes.byteLength;
 for (var i = 0; i < len; i++) {
  binary += String.fromCharCode( bytes[ i ] );
 }
 return window.btoa( binary );
}

function ev_put_click_ajax_json(t){
 jbyid('putrep').innerHTML = t.put;}


function ev_refresh_click(){jdoajax(['getsel']);}

function ev_refresh_click_ajax_json(t){jbyid('selspan').innerHTML= t.list;}

function ev_close_click(){winclose();}

)
