NB. J HTTP Server - jfile app
coclass'jfile'
coinsert'jhs'

HBS=: 0 : 0
jhma''
'action'    jhmg'action';1;12
 'edit'     jhmab'edit'
 'del'      jhmab'delete'
 'deltemps' jhmab'delete temps'
 'copy'     jhmab'copy        c^'
 'cut'      jhmab'cut         x^'
 'paste'    jhmab'paste       v^'
 'rename'   jhmab'rename as...'
 'newfi'    jhmab'new file'
 'newfo'    jhmab'new folder'
 jhjmlink''
jhmz''

'renamedlg'     jhdivadlg''
 'renamedo'     jhb'rename as'
  'renamex'     jhtext'';10
   'renameclose'jhb'X'
'<hr></div>'

'report'    jhdiv'<R>'
shorts''
'path'      jhhidden'<F>'
 'pathd'    jhdiv'<F>'

jhresize''

'sel'       jhdiv'<FILES>'
)

NB. y - error;file
create=: 3 : 0
'r f'=. y
if. 0=#1!:0<(-PS={:f)}.f do. f=. jpath'~temp\' end. NB. ensure valid f
'jfile' jhr 'R F FILES';r;f;(buttons 'files';(2#<folderinfo remlev f),<'<br>') 
)

NB. get file with mid/path opens the file
jev_get=: 3 : 0
if. 'open'-:getv'mid' do.
 ev_edit_click''
else.
 create '&nbsp;';jpath'~temp\'
end.
)

buttons=: 3 : 0
'mid sids values sep'=. y
p=. ''
for_i. i.#sids do.
 id=. mid,'*',>i{sids
 p=. p,sep,~id jhab i{values
end.
)

shorts=: 3 : 0
buttons 'paths';(2#<{."1 UserFolders_j_,SystemFolders_j_),<' '
)

ev_paths_click=: 3 : 0
sid=. getv'jsid'
f=. jpath'~',sid,'/'
jhrajax f,JASEP,buttons 'files';(2#<folderinfo remlev f),<'<br>'
)

NB. folder clicked (file click handled in js)
ev_files_click=: 3 : 0
sid=. getv'jsid'
path=. getv'path'
sid=. sid-.PS
sid=. 6}.sid NB. drop markfolder prefix
if. sid-:'..' do.
 f=. PS,~remlev remlev path 
else.
 f=. (remlev path),PS,sid,PS
end.
jhrajax f,JASEP,buttons 'files';(2#<folderinfo remlev f),<'<br>'
)

nsort=: 3 : 0
y /: (>:;y i: each '.')}. each y
)

markfolder=: <'&nbsp;&nbsp;&nbsp;'

NB. y path - result is folders,files
folderinfo=: 3 : 0
a=. 1!:0 <jpath y,'/*'
n=. {."1 a
d=. 'd'=;4{each 4{"1 a
(markfolder,each'/',~each(<'..'),nsort d#n),nsort (-.d)#n
)

NFI=: 'newfile'
NFO=: 'newfolder'

ev_newfi_click=: 3 : 0
F=. getv'path'
f=. (remlev F),PS,NFI
if. fexist f do.
 r=. NFI,' already exists'
else.
 try. 
  ''1!:2<f
  r=. NFI,' created'
 catch.
  r=. NFI,' create failed'
 end.
end.
create r;f
)

ev_newfo_click=: 3 : 0
F=. getv'path'
f=. (remlev F),PS,NFO,PS
try.
 1!:5<f
 r=. NFO,' created'
catch.
 r=. NFO,' create failed'
end.
create r;f
)

ev_renamedo_click=: ev_renamex_enter

NB.! needs work - e.g. non-empty folders - bad folder name
NB. should use host move/rename facility
ev_renamex_enter=: 3 : 0
F=. getv'path'
n=. getv'renamex'
if. PS-:_1{F do. NB. delete folder
 try.
  smoutput F
  f=. (remlev remlev F),PS,n,PS
  smoutput f
  1!:55 <}:F
  1!:5  <}:f
  r=. n,' new name for folder'
  F=. f
 catch.
  r=. n,' new name for folder failed (folder must be empty)'
 end.
else. NB. delete file
 f=. jpath n
 if. -.PS e. f do. f=. (remlev F),PS,f end.
 if. fexist f do.
  r=. n,' already exists'
 else.
  try.
   d=. 1!:1<F NB. read old
   d 1!:2<f   NB. write new
   1!:55<F    NB. erase old
   r=. n,' new name for file'
   F=. f
  catch.
   r=. n,' new name for file failed'
  end.
 end.
end. 
create r;F
)

ev_del_click=: 3 : 0
f=. jgetfile F=. jpath getv'path'
if. PS={:F do.
 NB. delete folder
 try.
  1!:55 <}:F
  create'Deleted folder.';PS,~remlev remlev F
 catch.
  create'Delete folder failed (folder must be empty).';F
 end.
else.
 NB. delete file
 try.
  d=. 1!:1<jpath F
  1!:5 :: [ <jpath'~temp/deleted'
  d 1!:2    <jpath'~temp/deleted/',jgetfile F
  1!:55 <F
  create ('Deleted file saved as "',('~temp/deleted/',f),'".');PS,~remlev F
 catch.
  create ('Delete "',f,'" failed.');F
 end.
end.
)

ev_deltemps_click=: 3 : 0
t=.{."1[1!:0 jpath'~temp/*ijs'
n=. (_4}.each t)-.each<'0123456789'
t=.(-.n~:<'')#t
t=. (<jpath'~temp/'),each t
for_f. t do. 1!:55 f end. 
create '&nbsp;';jpath'~temp\'
)

NB.! folder dblclick??? not a problem, but is puzzling
ev_files_dblclick=: ev_edit_click

ev_edit_click=: 3 : 0
f=. jgetfile F=. getv'path'
if. f-:'' do.
 create'No file selected to edit.';F
else.
 create_jijs_ F
end.
)

copy=: _1 NB. _1 not ready, 0 copy, 1 cut 

copycut=: 3 : 0
copy=: y
srcfile=: getv'path'
create 'Ready for paste';srcfile
)

ev_copy_click=: 3 : 'copycut 0'
ev_cut_click=:  3 : 'copycut 1'

NB.! paste folder support
ev_paste_click=: 3 : 0
F=. jpath getv'path'
f=. jgetfile srcfile
if. ''-:f                do. create 'Paste: folder not implemented.';F  return. end.
d=. fread srcfile
i=. f i: '.'
a=. i{.f
z=. i}.f
c=. 0
while. fexist snkfile=. (remlev F),PS,f do.
 c=. >:c
 f=. a,'-Copy(',(":c),')',z
end.
if. _1=copy              do. create 'Paste: no copy or cut.';F          return. end.
if. _1-:d                do. create 'Paste: read source file failed.';F return. end.
if. _1-:d fwrite snkfile do. create 'Paste: write newfile failed.';F    return. end.
if. copy=1 do. try. 1!:55 <srcfile catch. end. end.
create ('Paste: ',f,' created.');F
)

remlev=: 3 : '(y i: PS){.y'    NB. remove level from path

CSS=: 0 : 0
#report{color:red}
#pathd{color:blue;}
*{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
)

JS=: 0 : 0
function evload(){jresize();}

function repclr(){jbyid("report").innerHTML = "&nbsp;";}
function setpath(t){jform.path.value= t;jbyid("pathd").innerHTML= t;}
function ev_paths_click(){repclr();jdoajax(["path"],'');}

function ev_x_shortcut(){jscdo("cut");}
function ev_c_shortcut(){jscdo("copy");}
function ev_v_shortcut(){jscdo("paste");}
function ev_2_shortcut(){jbyid("sel").childNodes[0].focus();}

function ev_files_click() // file select
{
 repclr();
 if('/'!=jform.jsid.value.charAt(jform.jsid.value.length-1))
 {
  var t= jform.path.value;
  var i= t.lastIndexOf('/');
  setpath(t.substring(0,++i)+jform.jsid.value);
 }
 else
  jdoajax(["path"],"");
}

function ev_files_dblclick(){jsubmit();}

function ev_renamedo_click(){jsubmit();}
function ev_renamex_enter(){jsubmit();}
function ev_rename_click()     {jdlgshow("renamedlg","renamex");}
function ev_renameclose_click(){jhide("renamedlg");}

function ev_edit_click(){jsubmit();}
function ev_del_click(){jsubmit();}
function ev_deltemps_click(){jsubmit();}
function ev_copy_click(){jsubmit();}
function ev_cut_click(){jsubmit();}
function ev_paste_click(){jsubmit();}
function ev_newfi_click(){jsubmit();}
function ev_newfo_click(){jsubmit();}

function ajax(ts)
{
 if(2!=ts.length) alert("wrong number of ajax results");
 setpath(ts[0]);
 jbyid("sel").innerHTML= ts[1];
}

)

