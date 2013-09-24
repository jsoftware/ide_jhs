require'~addons/convert/json/json.ijs'

coclass'jtable'
coinsert'jhs'

HBS=: 0 : 0
'<link rel="stylesheet" href="~addons/ide/jhs/js/jquery/smoothness/jquery-ui.custom.css" />'
'<script src="~addons/ide/jhs/js/jquery/jquery-2.0.3.min.js"></script>'
'<script src="~addons/ide/jhs/js/jquery/jquery-ui.min.js"></script>'
'<script rel="stylesheet" href="~addons/ide/jhs/js/jquery/jquery-ui.css"></script>'
'<script src="~addons/ide/jhs/js/jquery/handsontable.js"></script>'
'<link rel="stylesheet" href="~addons/ide/jhs/js/jquery/handsontable.css">'
jhma''
jhjmlink''
jhmz''
'<button type="button" id="edit">edit</button>'
'<input type="text" id="nam" name="nam" value="name_of_table_to_edit" autofocus="autofocus" size="22"/>'
'<button type="button" id="save">save</button>'
'example' jhdiv ''
'<div id="dialog" title="Table Editor Error"></div>'
)

ercom=: '<br/><br/>see jhelp for more info'

jev_get=: 3 : 0
'jtable'jhr''
)

getnam=: 3 : 0
n=. dltb getv'nam'
n,>('_'={:n){'__';''
)

ev_edit_click=: 3 : 0
try.
 n=. getnam''
 assert 0=nc<n
 d=. n~
 assert 2=$$d
 assert 2>L.d
 if. 0=L.d do. d=. <"0 d end.
 d=. enc_json <"1 d
 if. d-:'[]' do. d=. '[[]]' end.
catch.
 d=. (getv'nam'),' not valid table for editing',ercom
end. 
jhrajax d
)

ev_save_click=: 3 : 0
try.
 n=. getnam''
 d=. getv'jdata'
 if. '[[]]'-:d do. jhrajax 'nothing to save',ercom return. end.
 d=. _1 _1}.>dec_json d
 if. -.2 e. ,>3!:0 each d do. d=. >d end.
 (n)=: d
 d=. ''
catch.
 d=. 'save failed',ercom
end. 
jhrajax d
)

CSS=: ''   NB. styles

JS=: 0 : 0 NB. javascript
var data= [[]];
 
// must use JHS framework load handler instead of jquery - $(document).ready(function() 
function ev_body_load()
{
 $(function(){$("#dialog").dialog({autoOpen:false,modal:true});});
 bindedit();
 bindenter();
 bindsave();
}

function bindedit(){$('body').on('click','button[id=edit]',function(){jscdo("edit");});}

function bindsave(){$('body').on('click','button[id=save]',function(){jscdo("save");});}

function bindenter()
{
 $(document).on("keypress","#nam",function(e)
 {
  if (e.which == 13)
  {
   jscdo("edit");
   return false; // critical - avoid default form enter event
  }
 });
}

function ev_edit_click(){jdoajax(["nam"]);}

function ev_save_click(){jdoajax("nam",JSON.stringify(data));}

function ajax(ts)
{
 if(0==ts[0].length)return;
 if('['!=(ts[0].charAt(0))) 
 {
     $("#dialog").html(ts[0]);
     $("#dialog").dialog("open");
     return;
 }
 var sf= (ts[0].indexOf('"')===-1)?"numeric":null; 
 console.log(sf);
 data= eval(ts[0]);
 $('#example').handsontable({
  data: data,
  minSpareRows: 1,
  minSpareCols: 1,
  colHeaders: true,
  rowHeaders: true,
  contextMenu: true,
  type: sf,
  undo: true
 });
}
)
