//! old menu stuff

// return menu group node n
function jfindmenu(n)
{
 var nodes= document.getElementsByTagName("a");
 var i,node,cnt=0,last,len= nodes.length;
 for(i=0;i<len;++i)
 {
  node= nodes[i];
  if("jhmg"!=node.getAttribute("class")) continue;
  if(n==++cnt) return node;
  last= node;
 }
 return last;
}

// tar is current node
// c is 37 38 39 40 - left up right down
// navigate to node based on c and focus
function jmenunav(tar,c)
{
 var i,n,nn,nc,node,cnt=0,last,len,cl,m=[];
 var nodes=document.getElementsByTagName("a");
 len=nodes.length
 for(i=0;i<len;++i)
 {
  node=nodes[i];
  cl=node.getAttribute("class");
  if("jhmg"==cl||"jhml"==cl||"jhmab"==cl)
  {
   m[m.length]=node;
   if(tar==node)n=i;
  }
 }
 len=m.length;
 nn=m[n];                        // nn node
 nc= m[n].getAttribute("class"); // nc class
 if(c==39) // right
 {
  for(i=n+1;i<len;++i)
   if(jmenunavfocushmg(m,i))return;
  jmenunavfocushmg(m,0); 
 }
 else if(c==37) // left
 {
  for(n;n>=0;--n) // back n up to current group
   if(1==jmenunavinfo(m,n))break;
  for(i=n-1;i>=0;--i)
   if(jmenunavfocushmg(m,i))return;
  for(i=len-1;i>=0;--i) // focus last hmg
   if(jmenunavfocushmg(m,i))return;
 }
 else if(c==38) // up
 {
  if("jhmg"==nc) return;
  if(jmenunavfocus(m,n-1))return;
  else
  {
   for(i=n;i<len;++i) // forward to hmg then back one
    if(2!=jmenunavinfo(m,i))break;
   jmenunavfocus(m,i-1);
   return;
  }
 }
 else if(c==40) // dn
 {
  if("jhmg"==nc)
  {
   jmenuhide();
   nn.focus();
   jmenushow(nn);
  }
  if(jmenunavfocus(m,n+1))return;
  else
  {
   for(i=n;i>=0;--i) // back up to hmg then forward 1
    if(1==jmenunavinfo(m,i))break;
   jmenunavfocus(m,i+1);
   return;
  }
 }
}

// focus,show if hmg - return 1 if focus is done
function jmenunavfocushmg(m,n)
{
 if(1!=jmenunavinfo(m,n))return 0;
 m[n].focus();jmenushow(m[n]);
 return 1;
}

// focus if hml/jmab - return 1 if focus is done
function jmenunavfocus(m,n)
{
  if(2!=jmenunavinfo(m,n))return 0;
  m[n].focus();
  return 1;
}

// return m[n] info - 0 none, 1 hmg, 2 hml or hmab
function jmenunavinfo(m,n)
{
 if(n==m.length)return 0;
 return ("jhmg"==m[n].getAttribute("class"))?1:2
}

// activate menu group n
function jactivatemenu(n)
{
 jmenuhide();
 var node= jfindmenu(n);
 if('undefined'==typeof node) return;
 node.focus(); 
}

var menublock= null; // menu ul element with display:block
var menulast= null;  // menu ul element just hidden 

function jmenuclick(ev)
{
 jmenuhide(ev);
 var e=window.event||ev;
 var tar=(typeof e.target=='undefined')?e.srcElement:e.target;
 var id=tar.id;
 if(id=="adv"){jscdo("advance");return;}
 var idul= id+"_ul";
 jbyid(id).focus(); // required on mac
 if(jbyid(idul).style.display=="block")
 {
  menublock= null;
  jbyid(idul).style.display= "none";
 }
 else
 {
  if(menulast!=jbyid(idul))
  {
   menublock= jbyid(idul);
   menublock.style.display= "block";
  }
 }
}

function jmenushow(node)
{
 jmenuhide();
 var id=node.id;
 var idul= id+"_ul";
 menublock= jbyid(idul);
 menublock.style.display= "block";
}

function jmenuhide()
{
 if(tmenuid!=0) clearTimeout(tmenuid);
 tmenuid= 0;
 menulast= menublock;
 if(menublock!=null) menublock.style.display= "none";
 menublock= null;
 return true;
}

// browser differences
//  safari/chrome onblur on mousedown and onfocus on mouseup
//  onblur will hide the menu 250 after mousedown (no clear)
//  so menu item click needs to be quick

var tmenuid= 0;

function jmenublur(ev)
{
 if(tmenuid!=0) clearTimeout(tmenuid);
 tmenuid= setTimeout(jmenuhide,500)
 return true;
}

function jmenufocus(ev)
{
 if(tmenuid!=0) clearTimeout(tmenuid);
 tmenuid= 0;
 return true;
}

function jmenukeydown(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 return(c>36&&c<41)?false:true;
}

function jmenukeypress(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 return(c>36&&c<41)?false:true;
}

function jmenukeyup(ev)
{
 var e=window.event||ev;
 var c=e.keyCode;
 if(c<37||c>40)return false;
 var tar=(typeof e.target=='undefined')?e.srcElement:e.target;
 jmenunav(tar,c);
 return true;
}


