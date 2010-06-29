NB. J HTTP Server - jfile app
coclass'jfile'
coinsert'jhs'

NB. <input type="file" ...> file browser is limited and has cross browser problems

NB. report nbsp; important as FF disappears empty divs

NB. get file with mid/path parameters opens the file
jev_get=: 3 : 0
if. 'open'-:getv'mid' do.
 ev_open_click''
else.
 create '';jpath'~temp\'
end.
)

B=: 0 : 0 NB. body template
open+edit+newijs jsep del jsep jide
report
path pathd
rfi rp
sel
-
[{'new file:' ;newfile}
 {'new folder';newfolder}
 {'rename:'   ;rename}]
)

BIS=: 0 : 0 NB. body template id-sentence pairs
open      hab'open'
edit      hab'edit'
newijs    hab'newijs'
del       hab'del'
report    '<div id="report"><R>&nbsp;</div>'
path      hh'<F>'
pathd     '<div id="pathd"><F></div>'
rfi       hradio'folders/files';'rad'
rp        hradio'~paths';'rad'
sel       '<div id="sel"></div>'
newfolder ht'';15
newfile   ht'';15
rename    ht'';15
)

createbody=: 3 : 0
(B getbody BIS)hrplc y
)

CSS=: 0 : 0
#report{color:red}
#pathd{color:blue;}
*{font-family:"courier new","courier","monospace";font-size:<PC_FONTSIZE>;}
)

createjs=: 3 : 0
files=. buttons 'files';t,t=. <folderinfo remlev y
paths=. buttons 'paths';t,t=. <{."1 SystemFolders_j_
JSCORE,JS hrplc 'FILES PATHS';jsstring each files;paths
)

NB. y - error;file
create=: 3 : 0
'r f'=. y
if. 0=#1!:0<(-PS={:f)}.f do. f=. jpath'~temp\' end. NB. ensure valid f
hr 'jfile';(css CSS);(createjs f);createbody'R F';r;f 
)

buttons=: 3 : 0
'mid sids values'=. y
p=. ''
for_i. i.#sids do.
 ID=: mid,'*',>i{sids
 p=. p,'<br>',~hab i{values
end.
)

NB. event handlers

ev_newijs_click=: 3 : 0
create_jijs_ jnew_jijs_''
)

ev_paths_click=: 3 : 0
sid=. getv'jsid'
select. sid
case. 'labs' do. f=. jpath'~system/extras/labs/'
case.        do. f=. jpath'~',sid,'/'
end.
ajaxresponse f,ASEP,buttons 'files';t,t=. <folderinfo remlev f
)

ev_files_click=: 3 : 0
sid=. getv'jsid'
path=. getv'path'
sid=. sid-.PS
if. sid-:'..' do.
 f=. PS,~remlev remlev path 
else.
 f=. (remlev path),PS,sid,PS
end.
ajaxresponse f,ASEP,buttons 'files';t,t=. <folderinfo remlev f
)

nsort=: 3 : 0
y /: (>:;y i: each '.')}. each y
)

NB. y path - result is folders,files
folderinfo=: 3 : 0
a=. 1!:0 <jpath y,'/*'
n=. {."1 a
d=. 'd'=;4{each 4{"1 a
('/',each'/',~each(<'..'),nsort d#n),nsort (-.d)#n
)

ev_newfile_enter=: 3 : 0
F=. getv'path'
n=. getv'newfile'
t=. 'New file name ',n
r=. ''
if. ''-:n-.' ' do.
 r=. t,' is empty.'
else.
 f=. (remlev F),PS,n
 if. fexist f do.
  r=. t,' already exists.'
 else.
  try. 
   ''1!:2<f
   F=. f
  catch.
   r=. t,' create failed.'
  end.
 end.
end.
create r;F
)

ev_newfolder_enter=: 3 : 0
F=. getv'path'
n=. getv'newfolder'
t=. 'New folder name ',n
r=. ''
if. ''-:n-.' ' do.
 r=. t,' is empty.'
else.
 f=. (remlev F),PS,n,PS
 try.
  1!:5<f NB. catch failure
  F=: f
 catch.
  r=. t,' failed.'
 end.
end.
create r;F
)

NB.! needs work - e.g. allow rename folders
NB. should use host move/rename facility
ev_rename_enter=: 3 : 0
F=. getv'path'
n=. getv'rename'
t=. 'Rename ',n
r=. ''
if. PS-:_1{F do.
 r=. t,' not supported.'
else.
 f=. jpath n
 if. -.PS e. f do. f=. (remlev F),PS,f end.
 if. fexist f do.
  r=. t,' already exists.'
 else.
  try.
   d=. 1!:1<F NB. read old
   d 1!:2<f   NB. write new
   1!:55<F    NB. erase old
   F=. f
  catch.
   r=. t,' failed.'
  end.
 end.
end. 
create r;F
)

ev_del_click=: 3 : 0
f=. getfile F=. jpath getv'path'
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
  d 1!:2    <jpath'~temp/deleted/',getfile F
  1!:55 <F
  create ('Deleted file saved as "',('~temp/deleted/',f),'".');PS,~remlev F
 catch.
  create ('Delete "',f,'" failed.');F
 end.
end.
)

NB.! do not understand what happens with dblclick of folders
NB.  does not seem to be a problem, but is puzzling
ev_files_dblclick=: 3 : 0
ev_open_click''
)

ev_open_click=: 3 : 0
f=. getfile F=. jpath getv'path'
if. f-:'' do.
 create'No file selected to open.';f
else.
 t=. (f i:'.')}.f
 c=. #p=. jpath'~home\'
 select. t
 case. '.pdf' do.
  if. p-:c{.F do.
   pdfresponse_jfilesrc_ '~home/',c}.F
  else.
   OPNREPORT=: 'PDF file must be in ~home path.'
   create''
  end.
 case. '.ijt' do.
  require__'~system/util/lab.ijs'
  LABFILE_jijx_=: F
  create'Lab selected. On jijx press lab button.';F
 case. '.svg' do.
  if. p-:c{.F do.
   svgresponse_jfilesrc_ '~home/',c}.F
  else.
   NB.! all OPNREPORT uses must be fixed
   OPNREPORT=: 'SVG file must be in ~home path.'
   create''
  end.
 case.        do. create_jijs_ F
 end.
end.
i.0 0
)

ev_edit_click=: 3 : 0
f=. getfile F=. getv'path'
if. f-:'' do.
 create'No file selected to edit.';F
else.
 create_jijs_ F
end.
i.0 0
)

remlev=: 3 : '(y i: PS){.y' NB. remove level from path

getfile=: 3 : '(>:y i: PS)}.y' NB. filename from fullname

JS=: hjs 0 : 0
var FILES= "<FILES>";
var PATHS= "<PATHS>";

// jsubmit default for undefined ev_mid_click handlers

function init(){jbyid("rfi").checked= true;jbyid("sel").innerHTML= FILES;}
function repclr(){jbyid("report").innerHTML = "&nbsp;";}
function setpath(t){jform.path.value= t;jbyid("pathd").innerHTML= t;}
function evload(){init();} // body onload -> jevload -> evload
function ev_rfi_click(){repclr();jbyid("sel").innerHTML= FILES;return true;}
function ev_rp_click() {repclr();jbyid("sel").innerHTML= PATHS;return true;}
function ev_paths_click(){repclr();jdoh(["path"]);}
function ctrl_comma(){jev("open","click");}
function ctrl_dot()  {jev("edit","click");}
function ctrl_slash(){jev("newijs","click");}


function ev_files_click() // file select
{
 repclr();
 if('/'!=jform.jsid.value.charAt(0))
 {
  var t= jform.path.value;
  var i= t.lastIndexOf('/');
  setpath(t.substring(0,++i)+jform.jsid.value);
 }
 else
  jdoh(["path"]);
}

function rqupdate() // process folders/paths ajax result
{
 var t= rq.responseText;
 var i= t.indexOf(ASEP);
 setpath(t.substring(0,i));
 FILES= t.substring(++i,t.length)
 init();
}
)

