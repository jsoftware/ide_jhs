test=: 3 : 0
'splitter;10 10'jpage''
)

coclass'splitter'
coinsert'jhs'

manapp=: 'jpage y must be ''''' NB. doc jpage y arg

INC=: INC_splitter NB. css/js library files to include

NB. J lines run in jhs locale that define html for the page
HBS=: 0 : 0
  jhsplitv 'style="height:100vh;margin:0;"'
    jhclose ''         NB. menu with close
    jhsplits ''      
    jhiframe 'jfile';'';'max-height:300px'
    jhsplits ''
    jhiframe 'jfif';'';'max-height:300px'
    jhsplits ''
      jhsplith 'style="flex:auto;"'
        jhiframe 'jfile';'';'min-width:100px;max-width:300px'
        jhsplits ''
        jhsplitv 'style="min-width:80px;"'
           '<div style="height: 4em;">min-width: 80px</div>'
           jhsplits ''
           '<div style="flex: auto;">flex: auto</div>'
        jhdivz NB. vertical end

        jhsplits ''
        '<div style="flex: auto;">flex: auto</div>'
        jhsplits ''
        '<div style="min-width:100px;max-width:200px;">min-max</div>'
     jhdivz NB. horizontal end
   jhsplits ''
   '<footer>footer</footer>'
  jhdivz NB. close vertical
)

NB. jpage (or url) calls to init page for browser
ev_create=: 3 : 0 
manapp assert ''-:y
NB. jhcmds 'set t1 *just loaded'  NB. browser command when page loads
jhcmds''
)
