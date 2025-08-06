man=: 0 : 0
tools for debugging javascript dom

  jlogopen'' NB. opens app with jlog textarea
 
function jlog(text) // adds text to end of jlog

)

load'~addons/ide/jhs/extra/jlog.ijs'

NB. jbxtra is included in NV - but better way is jlog to jlog app textarea

NB. open app with textarea for log
NB. function jlog(text) adds text to the text area
jlogopen=: 3 : 0
load'~addons/ide/jhs/extra/jlog.ijs'
'jlog;10 10'jpage''
)

run=:  3 : 0
:
jjs_jhs_ x rplc 'A0';":y
)


NB. get total height
geth=: 3 : 0
 jsalert'allpages[0].frameElement.parentNode.offsetHeight'
)

fixheight=: 0 : 0
{
  let f= allpages[A0].frameElement;
  f.style.height= f.offsetHeight+"px"
  ;
}
)

report=: 0 : 0
{
  let r= "";
  let w= allwins[1];

  let e= allwins[1].jbyid("aadiv");
  r+= e.height+' '+e.offsetHeight+' '+getComputedStyle(e).height+'\n';

  e= allwins[1].jbyid("bbdiv");
  r+= e.height+' '+e.offsetHeight+' '+getComputedStyle(e).height+'\n';

  e= allwins[1].jbyid("ccdiv");
  r+= e.height+' '+e.offsetHeight+' '+getComputedStyle(e).height+'\n';

  jlog(r);
}
)

atts=: 0 : 0
{
  let r= "";
  let f= allpages[A0].frameElement;
  let d= f.attributes;
  for (let i = 0; i < d.length; i++) {
    r+= d[i].name+" "+d[i].value+"\n";
  }
  r+= 'style h w: '+f.style.height+' '+f.style.width+'\n'
  r+= 'offset h w: '+f.offsetHeight+' '+f.offsetWidth+'\n';
  let s= getComputedStyle(f); r+= "computed h w:"+s.getPropertyValue("height")+" "+s.getPropertyValue("width")+"\n";
  jlog(r);
}
)

get_page_wh=: 0 : 0
{ let r= "";
  let e= getComputedStyle(allpages[0].frameElement.nextElementSibling);
  r= e.getPropertyValue("width")+" "+e.getPropertyValue("height")+"\n";
  let d= allpages;
  for (let i = 0; i < d.length; i++) {
    let s= getComputedStyle(allpages[i].frameElement);
    s.getPropertyValue("width")+" "+s.getPropertyValue("height")+"\n";
  }
jlog(r+"\n");
}
)

reverse=: 0 : 0
{
  let p= allpages;

  let a= getComputedStyle(allpages[0].frameElement).getPropertyValue("height");
  let b= getComputedStyle(allpages[1].frameElement).getPropertyValue("height");
  
  allpages[0].frameElement.style.height= b;
  allpages[1].frameElement.style.height= a;
}
)

reset=: 0 : 0
  let d= allpages;
  for (let i = 0; i < d.length; i++) {
    let s= getComputedStyle(allpages[i].frameElement);
    allpages[i].frameElement.style= s.getPropertyValue("height");
  }

)





last=: 3 : 0
d=. <;._2 fread 'jbxtra.txt'
>{:d
)


0 : 0
  const myElement = document.getElementById('myId');
    const attributes = myElement.attributes;
    for (let i = 0; i < attributes.length; i++) {
        console.log(`${attributes[i].nodeName}: ${attributes[i].nodeValue}`);
    }
)    