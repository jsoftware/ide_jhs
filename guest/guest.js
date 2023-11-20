/* jhs proxy server
 Cookie: handled in node to manage logon
 Expect: (chunk) handled in node and complete result passed to client
 see: ~addons/ide/jhs/node.ijs

cookie created by replyc with maxage limit on valid start
 cookie expires at limit - persists over browser restart
 econn... bad(data) gsnums port entry so cookie will be invalid in the future

cookie created by replynoc with maxage maxage on failure
 used to enforce wait before new start

guest session ends when:
 any event marks guest invalid based on limit or time
 bad result (noc)
*/

var t= process.argv[1];
var a= process.argv.slice(2);
const nodeport=a[0];const key=a[1];const jhsport=a[2];
//! a[3] unused - was breakfile
//! a[4] unused - was pem
const guests= parseInt(a[5]); // number of guests allowed
const limit=  parseInt(a[6]); // seconds a session lasts before clearguests clear
const maxage= parseInt(a[7]); // seconds a cookie persists after noc to prevent new session too soon
const idle=   parseInt(a[8]); // seconds idle (time between enters) before clearguests clear

const https  = require('https');
const http   = require('http');
const fs     = require('fs');
const crypto = require("crypto");
const cp     = require('child_process');

const guestbase= 1+parseInt(jhsport);
const NOC= '0+0+0+0';  // token+serial+port+time
const bind= '0.0.0.0'; // anybody
const jhshost= "localhost";
const cookiename= "jhs_cookie";
const token=  crypto.randomBytes(16).toString("hex");

var htmluser=  fs.readFileSync(('/jguest/j/addons/ide/jhs/guest/user.html'),'utf8');
var htmlbad=   fs.readFileSync(('/jguest/j/addons/ide/jhs/guest/bad.html'),'utf8');
var htmlredirect=   fs.readFileSync(('/jguest/j/addons/ide/jhs/guest/redirect.html'),'utf8');


var gstart= Array(guests).fill(0); // 0 or time when port was allocated
var gsnums= Array(guests).fill(0); // 0 or serial number of valid port
var genter= Array(guests).fill(0); // time of last enter
var gcount= Array(guests).fill(0); // request count
var snum=1;

var usersnum=0; // detect user task requires exec to start server

// mark OLD ports (limit) and IDLE ports (idle)  as free
function clearguests(){
 for (let i = 0; i < gstart.length; i++) {
  if(gstart[i]!=0 && Date.now()>(gstart[i]+(1000*limit))){log('limit',i+guestbase,0,gcount[i]);clear(i+guestbase);}
  if(gstart[i]!=0 && Date.now()>(genter[i]+(1000*idle))) {log('idle' ,i+guestbase,0,gcount[i]);clear(i+guestbase);}
 }
}

// mark port as available
function clear(port){
 if(jhsport==port) usersnum= 0; //invalidate user
 else {i= port-guestbase;gstart[i]=0; gsnums[i]=0; genter[i]=0; gcount[i]=0;} // invalidate guest
}

// return free guest port or 0
function getguest(){
 for (let i = 0; i < gsnums.length; i++) {
  if(gsnums[i]==0) return guestbase+i;
 }
 return 0;
}

function markenter(port)  {if(jhsport!=port){ var i= port-guestbase; genter[i]= Date.now(); ++gcount[i];}}

// cookie: token+snum+port+now
function createcookie(port){
 if(port==0) return NOC;
 var now= Date.now();
 snum= 1+snum;
 if(port==jhsport)
  usersnum= snum; 
 else
 {
  let i= port-guestbase;
  gstart[i]= now;
  genter[i]= now;
  snum= 1+snum;
  gsnums[i]= snum;
 }
 return token+'+'+snum+'+'+port+'+'+now;
}

// client reponse with text
function replyx(code,res,p){res.writeHead(code, "OK", {'Content-Type': 'text/html'});res.end(p);}

// client response with cookie and text
function replyc(code,res,p,port)
{
 var cval= createcookie(port);
 var max= (port>=guestbase)? ';Max-Age='+limit : '';
 var c= cval+max+";Secure;Httponly";
 res.writeHead(code, "OK", {'Set-Cookie':cookiename+"="+c,'Content-Type': 'text/html'});
 res.end(p);
}

// code 403 aborts ajax request which sets location /jlogin
// code 200 replies with bad.html
// cookie set to enforce wait
function replynoc(code,res,p,port){
 if(code==200)
  p= htmlbad;
 else
  p= htmlbad.replace('<STATUS>',p);
 var cval= token+'+'+'x'+'+'+port+'+'+Date.now(); // note 'x' for snum
 var max= (port>=guestbase)? ';Max-Age='+maxage : '';
 var c= cval+max+";Secure;Httponly";
 res.writeHead(code, "OK", {'Set-Cookie':cookiename+"="+c,'Content-Type': 'text/html'});
 res.end(p);
}

// client response with headers and body string
function replyhb(code,res,p)
{
  res.writeHead(code, "OK", p['headers']);
  res.end(Buffer.from(p['body'],'binary')) // must be buffer to avoid utf8 stuff
}

const options = {
  key:  fs.readFileSync('/jguest/jkey'),
  cert: fs.readFileSync('/jguest/jcert'),
  'trust proxy': true
};

const server = https.createServer(options, (req, res) => {
  // htmluser=  fs.readFileSync(('/jguest/j/addons/ide/jhs/guest/user.html'),'utf8');
  // htmlbad=   fs.readFileSync(('/jguest/j/addons/ide/jhs/guest/bad.html'),'utf8');
  clearguests();
  var cval= get_cookies(req)['jhs_cookie'];
  if(typeof(cval)=='undefined') cval= NOC; 
  var p= cval.split('+');
  if(token!=p[0]){cval=NOC; p=cval.split('+');} // cval reset if from another node instance
  var c= p[0];
  var s= p[1];
  var port= p[2];
  var ontime= parseInt(p[3]); // time session started
  var valid= port!=0 && c==token && s==(  (port!=jhsport)?gsnums[port-guestbase]:usersnum );
  var url= decodeURIComponent(req.url);
  var  ip= req.connection.remoteAddress;
  if(req.method == 'POST')
  {
    dopost(req, res, function() {
      let postdata= decodeURIComponent(req.post)
      let i= postdata.indexOf('?')
      let cmd= postdata.substring(0,i);
      let val= postdata.substring(i+1);

      if("jserver-user"==cmd) // validate logon key
      {
         if(5>val.length || key!=val){replyx(200,res,"invalid key",jhsport); return;}
         if(port==jhsport && usersnum==s){replyx(200,res,"valid",jhsport); return;}
         log('user',jhsport,ip);
         cp.exec('sudo '+'/jguest/j/addons/ide/jhs/guest/guest-sudo-sh user '+jhsport+' '+process.env.USER);
         replyc(200,res,"valid",jhsport);
      }
      else if(!valid) replynoc(403,res,'login required',port);
      else if("jbreak"==cmd)
      {
       cp.exec('sudo '+'/jguest/j/addons/ide/jhs/guest/guest-sudo-sh break '+port);
       replyx(200,res,'break signalled');
      }
      else
      jhsreq("POST",jhshost,port,url,req.post,req,res); // pass to JHS
    });
     return;
  }

  // get
  if(url=='/juser') replyx(200,res,htmluser);
  else if(url=='/jguest')
  {
   var wait= Math.ceil((maxage-((Date.now()-ontime)/1000))/60); // minutes to wait
   if(valid) jhsreq("GET",jhshost,port,'/jijx',"",req,res);
   else if(token==c && wait>0)
   {
     // waiting for replynoc cookie to expire
     log('wait',port,ip,0,wait);
     replyx(200,res,htmlbad.replace('<STATUS>','try again in '+wait+' minutes'));
     return;
   }
   else
   {
     port= getguest();
     if(port==0)
     {
       log('full');
       replyx(200,res,'full');
     }
     else
    {
     log('guest',port,ip);
     cp.exec('sudo '+'/jguest/j/addons/ide/jhs/guest/guest-sudo-sh guest '+port+' '+limit);
     replyc(200,res,htmlredirect,port);
    }
   }
  }
  else if(url=='/jlogoff') replyc(200,res,htmlbad,0);
  else if(url=='/jlogin')  replyx(200,res,htmlbad);
  else if(url=="/favicon.ico") jhsreq("GET",jhshost,port,url,"",req,res);
  else if(!valid) replynoc(200,res,'login required',port);
  else jhsreq("GET",jhshost,port,url,"",req,res);
});

server.listen(nodeport, bind, () => {log('start',`${nodeport}`);});

var get_cookies = function(request) {
  var cookies = {};
  if (typeof(request.headers.cookie) == "undefined") return cookies;
  request.headers && request.headers.cookie.split(';').forEach(function(cookie) {
    var parts = cookie.match(/(.*?)=(.*)$/)
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

function jhsresponse(res,data){return {'headers': res.headers,'body':data}}

let toString = obj => Object.entries(obj).map(([k, v]) => `${k}: ${v}`).join(', ');

async function jhsreq(gp,host,port,url,body,req,res){
 markenter(port);
 let promise= dorequest(gp,host,port,url,body,req);
 promise.then(good,bad);
 function good(data){replyhb(200,res,data);}
 function bad(data){
  log('baddata',port,0,0,0,data);
  if(typeof(data)=='string' && data.includes('ECONNRE')){ // ECONNRESET ECONNREFUSED
   if(jhsport!=port) log('econnre',port,0,gcount[port-guestbase]); // jhsport
   clear(port);
   replynoc(403,res,data,port);
  }
  else
   replyx(403,res,data+''); // data+'' necessary
 }
}

function dorequest(gp,host,port,url,body,req){
    let h= req.headers
    h["node-jhs"]= 1
    return new Promise(function(resolve, reject) {
     let options = {hostname: host,port: port,path: url,method: gp, headers: h
    }
    http
      .request(options, res => {
        var data = ""
        res.setEncoding('binary') // critical to get binary data uncompressed
        res.on("data", d => {data += d;})
        res.on("end", () => {resolve(jhsresponse(res,data))})
      })
      .on("error",  (error) => {reject(JSON.stringify(error));})
      .end(body)
  });
}

// LCAT LTS LTYPE LPORT LIP LCOUNT LWAIT LX
function log(type,val){
 var d= 'jhs '+Date.now()+' '+type.padEnd(7);
 for (var i = 1; i < arguments.length; i++) {
  d= d+' '+arguments[i];
 }
 console.log(d);
}
