NB. routines to create desktop launch icons and to update/install base and addons

NB. shortcut 'jc' or 'jhs' or 'jqt' - create desktop launch icon
shortcut=: 3 : 0
t=. jpath'~/Desktop'
('Desktop folder does not exist: ',t)assert 2=ftype t
".UNAME,'_jinstaller_ y'
)

pre=: '------------------------------------'
good=: pre,'   finished',LF
bad =: pre,'   !!!failed!!!',LF

installer=: 3 : 0
er=. 0
echo'installation can take several minutes',LF
try.
 echo pre,'update and install addons'
 update_install_all 0
 echo good
catch.
 er=. 1
 echo bad
end.

try.
 echo pre,'install Jqt ide'
 install'qtide'
 echo good
catch.
 er=. 1
 echo bad
end.

for_n. 'jc';'jhs';'jqt' do.
 try.
  n=. ;n
  shortcut n
 catch.
  er=. 1
  echo pre,'install ',n,' desktop launch icon failed!!!'
 end.
end.

if. er do. echo LF,'there were errors!!!',LF end.

echo 'double click a desktop icon to run J with the corresponding user interface'
i.0 0
)

NB. update and install all (base library and addons)
update_install_all=: 3 : 0
require'pacman'
'update'jpkg''
'upgrade'jpkg'all'
'install'jpkg {."1'shownotinstalled'jpkg''
)

coclass'jinstaller'

A=:   ' ~addons/ide/jhs/config/jhs.cfg'
L=:   hostpathsep jpath'~/Desktop/'
W=:   hostpathsep jpath'~'
I=:   hostpathsep jpath'~bin/icons/'
N=:   (1 2 3{9!:14''),;IF64{'-32';''
DS=:  ;(('Win';'Linux';'Darwin')i.<UNAME){'.lnk';'.desktop';'.app'

NB. windows
vbs=: 0 : 0
Set oWS=WScript.CreateObject("WScript.Shell")
Set oLink=oWS.CreateShortcut("<N>")
oLink.TargetPath="<C>"
oLink.Arguments="<A>"
oLink.WorkingDirectory = "<W>"
oLink.IconLocation="<I>"
oLink.Save
)

Win=: 3 : 0
select. y
case.'jc' do.
 win'jc' ;'jconsole';'jgray.ico';''
case. 'jhs' do. 
 win'jhs';'jconsole';'jblue.ico';'~addons/ide/jhs/config/jhs.cfg'
case. 'jqt' do.
 win'jqt';'jqt'     ;'jgreen.ico';''
case. do.
 'unknown launch icon type'assert 0
end.
i.0 0
)

win=: 3 : 0
'type bin icon arg'=.y
f=. jpath '~temp/shortcut.vbs'
n=. L,type,N,DS
c=. hostpathsep jpath '~bin/',bin
(vbs rplc '<N>';n;'<C>';c;'<A>';arg;'<W>';W;'<I>';I,icon) fwrite f
r=. spawn_jtask_ 'cscript "',f,'"'
r assert -.'runtime error' E. r
ferase f
i.0 0
)

NB. Linux
desktop=: 0 : 0
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name=<N>
Exec=<E>
Path=<W>
Icon=<I>
)

NB. terminal command used to run this session
NB. trace back through pids to pid 1 init
getterm=: 3 : 0
p=. ":2!:6''
while. 1 do.
 r=.  2!:0'ps -o comm -p ',p
 p=. ;{:<;._2[2!:0'ps -o ppid -p ',p
 if. 1=".p do. break. end.
end. 
;{:<;._2 r
)

Linux=: 3 : 0
select. y
case.'jc' do.
 linux'jc' ;'jconsole';'jgray.png';''
case. 'jhs' do. 
 linux'jhs';'jconsole';'jblue.png';A
case. 'jqt' do.
 linux'jqt';'jqt'     ;'jgreen.png';''
case. do.
 'unknown launch icon type'assert 0
end.
i.0 0
)

linux=: 3 : 0
'type bin icon arg'=.y
n=. type,N
f=. L,type,N,DS
c=. hostpathsep jpath '~bin/',bin
if. type-:'jqt' do.
 e=. '"',c,'"'
else.
 e=. '<T> -e "\"<C>\"<A>"'rplc '<T>';(getterm'');'<C>';c;'<A>';arg
end.
r=. desktop rplc '<N>';n
r=. r rplc '<E>';e
r=. r rplc '<W>';W
r=. r rplc '<I>';I,icon
r fwrite f
2!:0'chmod +x ',f
)

NB. Darwin
plist=: 0 : 0
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>apprun</string>
<key>CFBundleIconFile</key><string>i.icns</string>
<key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
<key>CFBundleName</key><string>j</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleVersion</key><string>1.0</string>
</dict></plist>
)

COM=: jpath'~temp/jhs.command'

Darwin=: 3 : 0
select. y
case.'jc' do.
 darwin'jc' ;'jconsole';'jgray.icns';''
case. 'jhs' do. 
 darwin'jhs';'jconsole';'jblue.icns';A
case. 'jqt' do.
 darwin'jqt';'jqt'     ;'jgreen.icns';''
case. do.
 'unknown launch icon type'assert 0
end.
i.0 0
)

NB. 1 jhs - 0 jconsole
darwin=: 3 : 0
'type bin icon arg'=.y
n=. type,N
f=. L,type,N,DS
c=. hostpathsep jpath '~bin/',bin
select. type
case.'jc' do.
 r=. '#!/bin/sh',LF,'open "',c,'"'
case. 'jhs' do.
 r=. jhsrun
case. 'jqt' do.
 r=.'#!/bin/sh',LF,'"',c,'.command"'
end.
fpathcreate f,'/Contents/MacOS'
fpathcreate f,'/Contents/Resources'
plist fwrite f,'/Contents/info.plist'
r fwrite f,'/Contents/MacOS/apprun'
(fread '~bin/icons/',icon) fwrite f,'/Contents/Resources/i.icns'
2!:0'chmod -R +x ',f
)

jhsrun=: 0 : 0 rplc '<COM>';COM;'<C>';hostpathsep jpath '~bin/jconsole'
#!/bin/sh
echo '#!/bin/sh' > "<COM>"
echo '"<C>" ~addons/ide/jhs/config/jhs.cfg' >> "<COM>"
chmod +x <COM>
open "<COM>"
)
