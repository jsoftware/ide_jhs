NB. routines to update/install all addons and to create desktop icons

install=: 3 : 0
update_install_all 0
shortcut 0
)

NB. update and install all (base library and addons)
update_install_all=: 3 : 0
require'pacman'
'update'jpkg''
'upgrade'jpkg'all'
'install'jpkg {."1'shownotinstalled'jpkg''
)

NB. create desktop launch icons for jconsole and JHS
shortcut=: 3 : 0
".UNAME,'_jshortcut_'''''
)

coclass'jshortcut'

C=:   hostpathsep jpath'~bin/jconsole'
L=:   hostpathsep jpath'~/Desktop/'
W=:   hostpathsep jpath'~'
A=:   ' ~addons/ide/jhs/config/jhs.cfg'
I=:   hostpathsep jpath'~bin/icons/'
N=:   (1 2 3{9!:14''),;IF64{'-32';''
DS=:  ;(('Win';'Linux';'Darwin')i.<UNAME){'.lnk';'.desktop';'.app'
JHS=: 'jhs',N,DS
JC=:  'jc',N,DS

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
win JHS
win JC
)

win=: 3 : 0
'icon arg'=. ;(y-:JHS){(<'jgray.ico';''),<'jblue.ico';A
f=. jpath '~temp/shortcut.vbs'
(vbs rplc '<N>';(L,y);'<C>';C;'<A>';arg;'<W>';W;'<I>';I,icon) fwrite f
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
Exec=<T> -e "\"<C>\"<A>"
Path=<W>
Icon=<I>
)

Linux=: 3 : 0
linux JHS
linux JC
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

linux=: 3 : 0
'icon arg'=. ;(y-:JHS){(<'jgray.png';''),<'jblue.png';A
f=. L,y
r=. desktop rplc '<T>';getterm'' NB. terminal command to run this session
r=. r rplc '<N>';_8}.y
r=. r rplc '<C>';C
r=. r rplc '<A>';arg
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
darwin JHS
darwin JC
)

NB. 1 jhs - 0 jconsole
darwin=: 3 : 0
if. y-:JHS do.
 i=. fread '~bin/icons/jblue.icns'
 r=. jhsrun
else.
 i=. fread '~bin/icons/jgray.icns'
 r=. '#!/bin/sh',LF,'open "',C,'"'
end. 
f=. jpath'~/Desktop/',y
fpathcreate f,'/Contents/MacOS'
fpathcreate f,'/Contents/Resources'
plist fwrite f,'/Contents/info.plist'
r fwrite f,'/Contents/MacOS/apprun'
i fwrite f,'/Contents/Resources/i.icns'
2!:0'chmod -R +x ',f
)

jhsrun=: 0 : 0 rplc '<COM>';COM;'<C>';C
#!/bin/sh
echo '#!/bin/sh' > "<COM>"
echo '"<C>" ~addons/ide/jhs/config/jhs.cfg' >> "<COM>"
chmod +x <COM>
open "<COM>"
)
