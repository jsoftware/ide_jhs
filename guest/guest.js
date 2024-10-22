/* jhs proxy server
 Cookie: handled in node to manage logon
 Expect: (chunk) handled in node and complete result passed to client
 see: ~addons/ide/jhs/node.ijs

cookie created by replyc
 cookie expires at limit - persists over browser restart
 econn... bad(data) gsnums port entry so cookie will be invalid in the future

guest session ends when:
 any event marks guest invalid based on limit or time
 bad result (noc)

execSync doesn't work because jhs server does not terminate!
 it would work with an ss/netstat/lsof call to check if port is listening

confusion when same browser uses both jquest and juser - switches rather than error 
*/

var t= process.argv[1];
var a= process.argv.slice(2);
const nodeport=a[0];const key=a[1];const jhsport=a[2];
//! a[3] unused - was breakfile
//! a[4] unused - was pem
const guests= parseInt(a[5]); // number of guests allowed
const limit=  parseInt(a[6]); // seconds a session lasts before poll kill
const dulim=  parseInt(a[7]); // limit for du -s -b /home/p?
const idle=   parseInt(a[8]); // seconds idle (time between enters) before poll kill
//! a[9] unused - pgroup limits
const polltime= 60000; // time between poll runs

const https  = require('https');
const http   = require('http');
const fs     = require('fs');
const crypto = require("crypto");
const cp     = require('child_process');

const guestbase= 1+parseInt(jhsport);
const NOC= '0+0+0';  // token+serial+port
const bind= '0.0.0.0'; // anybody
const jhshost= "localhost";
const cookiename= "jhs_cookie";
const token=  crypto.randomBytes(16).toString("hex");

var htmluser=  fs.readFileSync(('/jguest/j/addons/ide/jhs/guest/user.html'),'utf8');
var htmlbad=   fs.readFileSync(('/jguest/j/addons/ide/jhs/guest/bad.html'),'utf8');
var htmlredirect=   fs.readFileSync(('/jguest/j/addons/ide/jhs/guest/redirect.html'),'utf8');

var gstart= Array(guests).fill(0); // 0 or time when port was allocated
var gsnums= Array(guests).fill(0); // 0 or serial number of valid port
var gip=    Array(guests).fill(0); // ip
var genter= Array(guests).fill(0); // time of last enter
var gcount= Array(guests).fill(0); // request count
var snum= 0;

var usersnum=0; // user task serial number - stays at 0 as there is only 1 user (even if task may be restarted)
var userip=0;   // user task ip

var exitmsg= '(Esc-q or idle/session/cpu/storage/... limit or ?)';

process.on('exit', (code) => {
  console.log(`J: exit code: ${code}`);
});

// try to get info on mystery node exits - why does example use fs instead of log
process.on('uncaughtException', (err, origin) => {
  console.log('J: uncaught exception');
  fs.writeSync(
    process.stderr.fd,
    `Caught exception: ${err}\n` +
    `Exception origin: ${origin}`
  );
});

// run periodically to kill tasks using too much storage 
function poll(){
  // log('poll',0);
  clearguests();
  let p= cp.execSync('sudo '+'/jguest/j/addons/ide/jhs/guest/guest-sudo-sh du 0').toString().split('\n');
  for(let i=0; i<p.length-1; i++){ // size tab folder - last one is empty becasue of trailing \n
   q= p[i].split('\t');
   if(parseInt(q[0])>dulim) kill('kill-du',q[1].slice(7),q[0]);
  }   
  setTimeout(poll, polltime);
}

// mark OLD ports (limit and idle) as free
function clearguests(){
 for (let i = 0; i < gstart.length; i++) {
  p= i+guestbase; 
  if(gstart[i]!=0 && Date.now()>(gstart[i]+(1000*limit))) kill('kill-limit',p,0);
  if(gstart[i]!=0 && Date.now()>(genter[i]+(1000*idle ))) kill('kill-idle',p,0);
 }
}

// kill task and user for port
function kill(type,port,xtra){
  if(jhsport==port || 0==port)return;
  log(type,port,'+',xtra);
  cp.execSync('sudo '+'/jguest/j/addons/ide/jhs/guest/guest-sudo-sh kill '+port);
  clear(port);
 }


// clear port info
function clear(port){
 if(jhsport==port || 0==port)return;
 log('clear',port);
 i= port-guestbase;gstart[i]=0; gsnums[i]=0; genter[i]=0; gcount[i]=0; 
}
 
// return free guest port or 0
function getguest(){
 for (let i = 0; i < gsnums.length; i++) {
  if(gsnums[i]==0) return guestbase+i;
 }
 return 0;
}

function markenter(port)  {if(jhsport!=port){ var i= port-guestbase; genter[i]= Date.now(); ++gcount[i];}}

// cookie: token+snum+port
function createcookie(port,ip){
 if(port==0) return NOC;
 var now= Date.now();
 if(port==jhsport){
  userip= ip;
  log('user',port);
 } 
 else
 {
  snum= 1+snum;
  let i= port-guestbase;
  gstart[i]= now;
  genter[i]= now;
  gsnums[i]= snum;
  gip[i]= ip;
  log('guest',port);
 }
 var n= (port==jhsport)?0:snum;
 return token+'+'+n+'+'+port; //+'+'+now;
}

// client reponse with text
function replyx(code,res,p){res.writeHead(code, "OK", {'Content-Type': 'text/html'});res.end(p);}

// client response with cookie and text
function replyc(code,res,p,port,ip)
{
 var cval= createcookie(port,ip);
 var max= (port>=guestbase)? ';Max-Age='+limit : '';
 var c= cval+max+";Secure;Httponly";
 res.writeHead(code, "OK", {'Set-Cookie':cookiename+"="+c,'Content-Type': 'text/html'});
 res.end(p);
}

// 403 reply will set location to /jlogin - guest cookie set to enforce waitx
function replynoc(res,p,port){
 log('403',port,'+',p);
 kill('kill-403',port,0);
 var cval= token+'+'+'x'+'+'+port+'+'+Date.now(); // note 'x' for snum
 //var max= (port>=guestbase)? ';Max-Age='+waitx : '';
 var c= cval+";Secure;Httponly";
 res.writeHead(403, "OK", {'Set-Cookie':cookiename+"="+c,'Content-Type': 'text/html'});
 res.end(p);
}

// client response with headers and body string
function replyhb(code,res,p)
{
  res.writeHead(code, "OK", p.headers);
  res.end(Buffer.from(p.body,'binary')); // must be buffer to avoid utf8 stuff
}

const options = {
  key:  fs.readFileSync('.ssh/jserver/key.pem'),
  cert: fs.readFileSync('.ssh/jserver/cert.pem'),
  'trust proxy': true
};

const server = https.createServer(options, (req, res) => {
  // htmluser=  fs.readFileSync(('/jguest/j/addons/ide/jhs/guest/user.html'),'utf8');
  // htmlbad=   fs.readFileSync(('/jguest/j/addons/ide/jhs/guest/bad.html'),'utf8');
  var cval= get_cookies(req).jhs_cookie;
  if(typeof(cval)=='undefined') cval= NOC; 
  var p= cval.split('+');
  if(token!=p[0]){cval=NOC; p=cval.split('+');} // cval reset if from another node instance
  var c= p[0];
  var s= p[1];
  var port= p[2];
  var valid= port!=0 && c==token && s==(  (port!=jhsport)?gsnums[port-guestbase]:usersnum );
  var url= decodeURIComponent(req.url);
  var  ip= req.connection.remoteAddress;

  if(valid)
   log('valid',port,req.method+url);
  else
   log('invalid','+',req.method+url); 


  if(req.method == 'POST')
  {
    dopost(req, res, function() {
      let postdata= decodeURIComponent(req.post);
      let i= postdata.indexOf('?');
      let cmd= postdata.substring(0,i);
      let val= postdata.substring(i+1);
      let restart= "jserver-user-restart"==cmd;

      if(url=="/jsurvey")
      {
        // save survey postdata to file
        const d= new Date();
        fs.appendFileSync('jsurvey/data',d.toISOString()+' '+ip+' '+postdata+'\0');
        replyx(200,res,'survey recorded');
      }

      if("jserver-user"==cmd || restart) // validate key
      {
       //! add code here to throw error for testing
       if(key!=val){replyx(200,res,"invalid key",jhsport); return;}
         cp.exec('sudo '+'/jguest/j/addons/ide/jhs/guest/guest-sudo-sh user '+jhsport+' '+process.env.USER+' '+restart);
         replyc(200,res,"valid",jhsport,ip);
      }
      else if(!valid) replynoc(res,'login-post',port);
      else if("jbreak"==cmd)
      {
       log('break',port); 
       cp.exec('sudo '+'/jguest/j/addons/ide/jhs/guest/guest-sudo-sh break '+port);
       replyx(200,res,'break signalled');
      }
      else
      {
       //jdo=   jgp\'testtest\'&jtype=enter&jmid=log&jsid=&jdata=&jwid=jijx 
       if(postdata.includes("jgp")) // avoid regex test for most sentences
       {
        let t= postdata.split('&')[0];
        if(/jdo= *jgp *'[a-zA-Z0-9]+' *$/.test(t)){
         let p= t.split("'")[1];
         if(7<p.length){ 
          log('restore',port,p); 
          cp.execSync('sudo '+'/jguest/j/addons/ide/jhs/guest/guest-sudo-sh restore '+port+' '+p);
         }
        }
       }
       jhsreq("POST",jhshost,port,url,req.post,req,res); // pass to JHS
      }
    });
     return;
  }

  // get
  if(url=='/jsurvey')
  {
    t= fs.readFileSync('jsurvey/survey.html','utf8');
    replyx(200,res,t);
  }
  if(url=='/jcrash'&&port==jhsport)
  {
    replyc(200,res,htmlbad,0);
    process.exit(1);
  }
  else if(url=='/juser') replyx(200,res,htmluser);
  else if(url=='/jguest')
  {
   if(valid && port!=jhsport)
    jhsreq("GET",jhshost,port,'/jijx',"",req,res);
   else
   {
     port= getguest();
     if(port==0)
     {
       log('full',0);
       replyx(200,res,htmlbad.replace('<STATUS>','all ports busy<br/>try again later'));
     }
     else
    {
     cp.exec('sudo '+'/jguest/j/addons/ide/jhs/guest/guest-sudo-sh guest '+port);
     replyc(200,res,htmlredirect,port,ip);
    }
   }
  }
  else if(url=='/jlogoff') replyc(200,res,htmlbad,0);
  else if(url=='/jlogin')  replyx(200,res,htmlbad.replace('<STATUS>',exitmsg));
  else if(url=="/favicon.ico") jhsreq("GET",jhshost,port,url,"",req,res);
  else if(!valid) replynoc(res,'login-get',port);
  else jhsreq("GET",jhshost,port,url,"",req,res);
});

server.listen(nodeport, bind, () => {log('start',`${nodeport}`);poll();})

var get_cookies = function(request) {
  var cookies = {};
  if (typeof(request.headers.cookie) == "undefined") return cookies;
  request.headers && request.headers.cookie.split(';').forEach(function(cookie) {
    var parts = cookie.match(/(.*?)=(.*)$/);
    cookies[ parts[1].trim() ] = (parts[2] || '').trim();
  });
  return cookies;
};

function dopost(req, res, callback) {
  var postdata = "";
      req.on('data', function(data) {
          postdata += data;
          if(postdata.length > 1e6) {
              postdata = "";
              res.writeHead(413, {'Content-Type': 'text/plain'}).end();
              req.connection.destroy();
          }
      });
      req.on('end', function() {
          req.post = postdata;
          callback();
      });
  }

function jhsresponse(res,data){return {'headers': res.headers,'body':data};}

let toString = obj => Object.entries(obj).map(([k, v]) => `${k}: ${v}`).join(', ');

async function jhsreq(gp,host,port,url,body,req,res){
 markenter(port);
 let promise= dorequest(gp,host,port,url,body,req);
 promise.then(good,bad);
 function good(data){replyhb(200,res,data);}
 function bad(data){
  log('badres',port,req.method+decodeURIComponent(req.url),data); 
  if(typeof(data)=='string')
  {
   if(data.includes('ECONNREFUSED'))
   {
    // refused - redirect.html does sleep in browser - avoid sync in node
    //log('refused',port,req.method+decodeURIComponent(req.url),data);
    if(req.method=='GET')
    {
     // kludge to quit after too many redirects
     if(port!=jhsport && gcount[port-guestbase]>30){replynoc(res,'bad refused',port);return;}
     replyx(200,res,htmlredirect);
    }
    else 
     replynoc(res,'bad refused',port);
   }
   else if(data.includes('ECONNRESET'))
    replynoc(res,'bad reset',port);
  }
  else
  {
   // log('bad',port,0,data);
   //replyx(200,res,data+'');
   replynoc(res,'bad',port);
  }
 }
}

function dorequest(gp,host,port,url,body,req){
    let h= req.headers;
    h["node-jhs"]= 1;
    return new Promise(function(resolve, reject) {
     let options = {hostname: host,port: port,path: url,method: gp, headers: h
    };
    http
      .request(options, res => {
        var data = "";
        res.setEncoding('binary'); // critical to get binary data uncompressed
        res.on("data", d => {data += d;});
        res.on("end", () => {resolve(jhsresponse(res,data));});
      })
      .on("error",  (error) => {reject(JSON.stringify(error));})
      .end(body);
  });
}

// LCAT LTS LTYPE LPORT LSNUM LIP LCOUNT LWAIT LX
function log(type,port,val){
 var d= 'jhs '+Date.now()+' '+type+' ';
 if(port==jhsport)
  d+= port+' '+usersnum+' '+userip+' + ';
 else if(port>=guestbase && port<(guestbase+guests)){
  let i= port-guestbase;
  d+= port+' '+gsnums[i]+' '+gip[i]+' '+gcount[i];
 }
 else
  d+= port+' + + + + ';

 for (var i = 2; i < arguments.length; i++) {
  d= d+' '+arguments[i];
 }
 console.log(d);
}
