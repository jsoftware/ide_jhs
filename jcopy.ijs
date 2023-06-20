coclass'jcopy'
coinsert'jhs'
require'~addons/convert/misc/base64.ijs'

NB.copy files between server and client machines

NB. sentences that define html elements
HBS=: 0 : 0
jhfcommon''
'puttitle'    jhtitle 'copy client file xxx to server ~/uploads/xxx'
'put'      jhb 'put'
'<input id="fileupload" type="file" name="fileupload" />'
'putf'     jhhidden''
'putrep'   jhdiv'&nbsp;'
'<hr>'
'gettitle'    jhtitle 'copy server file ~/uploads/xxx to client downloads'
'get'      jhb 'get'
'selspan' jhspan 'getsel'jhselect ((#jpath'~/uploads/')}.each 1 dir'~/uploads/');1;0
'refresh'  jhb'refresh select list'
'getrep'   jhdiv'&nbsp;'
)

create=: 3 : 0
'jcopy' jhr ''
)

jev_get=: 3 : 0
create ''
)

ev_put_click=: 3 : 0
mkdir_j_ '~/uploads'
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

CSS=: 0 : 0
#jcopy{color:blue}
*{font-family:<PC_FONTFIXED>;}
)

NB. javascript code - initialize page and handle events
JS=: jsfcommon, 0 : 0

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

function saveAs(content,fileName) {
  const a = document.createElement("a");
  const file = createBlob(content);
  const url = window.URL.createObjectURL(file);
  a.href = url;
  a.download = fileName;
  a.click();
  URL.revokeObjectURL(url);
}

function createBlob(data) {
  return new Blob([data], { type: "application/octet-stream" });
}

function ev_get_click(){
 jbyid('getrep').innerHTML='&nbsp;';
 jdoajax(['getsel']);
}

function ev_get_click_ajax_json(t){
 jbyid('getrep').innerHTML=t.rep;
 if(t.data!=undefined){saveAs(base64ToArrayBuffer(t.data),jbyid('getsel').value);} 
}

function base64ToArrayBuffer(base64) {
    var binary_string = window.atob(base64)
    var len = binary_string.length;
    var bytes = new Uint8Array(len);
    for (var i = 0; i < len; i++) {
      bytes[i] = binary_string.charCodeAt(i);
    }
    return bytes.buffer;
}

function ev_refresh_click(){jdoajax(['getsel']);}

function ev_refresh_click_ajax_json(t){jbyid('selspan').innerHTML= t.list;}

)
