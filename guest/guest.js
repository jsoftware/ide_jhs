/* jhs proxy server
 Cookie: handled in node to manage logon
 Expect: (chunk) handled in node and complete result passed to client
 see: ~addons/ide/jhs/node.ijs
*/

var t= process.argv[1];
const guestpath= t.substring(0,t.lastIndexOf('/')+1); // path to guest folder

var args= process.argv.slice(2);
const nodeport=args[0];const key=args[1];const jhsport=args[2];const breakfile=args[3];const pem=args[4];

//! should be start params
const guests= 3;
var howlong= 1000*60*0.1; // x minutes

const https  = require('https');
const http   = require('http');
const fs     = require('fs');
const crypto = require("crypto");
const cp     = require('child_process');

const NOC= '0+0+0';
const bind= '0.0.0.0';  // anybody
const jhshost= "localhost";
const cookiename= "jhs_cookie";
const token=  crypto.randomBytes(16).toString("hex");

var logonhtml= fs.readFileSync((guestpath+'guest.html'),'utf8'); // not const to allow dynamic changes

var gtimes= Array(guests+1).fill(0); // 0 or time when port was allocated
var gsnums= Array(guests+1).fill(0); // 0 or serial number of valid port
var snum=1;

// mark OLD ports as free
function clearguests(){
 for (let i = 1; i < gtimes.length; i++) {
  if(Date.now()>gtimes[i]+howlong){ gtimes[i]=0; gsnums[i]=0;}
 }
}

// return free guest port or 0
function getguest(){
 for (let i = 1; i < gtimes.length; i++) {
  if(gtimes[i]==0) return parseInt(jhsport)+i;
 }
 return 0;
}

function createcookie(port){
 let i= port-jhsport;
 gtimes[i]=Date.now();
 snum= 1+snum;
 gsnums[i]= snum;
 log('cookie',snum+'+'+port);
 return token+'+'+snum+'+'+port;
}

function gethtml(status){return logonhtml;} // .replace("STATUS",status

// client reponse with text
function replyx(code,res,p){res.writeHead(code, "OK", {'Content-Type': 'text/html'});res.end(p);}

// client response with cookie and text
function replyc(code,res,p,cval)
{
  res.writeHead(code, "OK", {'Set-Cookie':cookiename+"="+cval+";Secure;Httponly",'Content-Type': 'text/html'});
  res.end(p);
}

// 403 aborts ajax request
function replynoc(code,res,p,port){
 log('noc',code+' '+port+' '+p);
 if(code==200) p= gethtml(p);
 replyc(code,res,p,NOC); // no cookie
}

// client response with headers and body string
function replyhb(code,res,p)
{
  res.writeHead(code, "OK", p['headers']);
  res.end(Buffer.from(p['body'],'binary')) // must be buffer to avoid utf8 stuff
}

const options = {
  key: fs.readFileSync(pem+'/key.pem'),
  cert: fs.readFileSync(pem+'/cert.pem'),
  'trust proxy': true
};

const server = https.createServer(options, (req, res) => {
 logonhtml= fs.readFileSync((guestpath+'guest.html'),'utf8'); //! allow dynamic changes - change to const when stable
  clearguests();
  var port=jhsport;
  var c= get_cookies(req)['jhs_cookie'];
  if(typeof(c)=='undefined') c= NOC;
  var ca= c.split('+');
  c= ca[0];
  var s= ca[1];
  var port=ca[2];

  var url= decodeURIComponent(req.url);
  //  var ip = req.connection.remoteAddress; // could avoid logon for localhost
  var  ip= req.ip;

  if(req.method == 'POST')
  {
    dopost(req, res, function() {
      let postdata= decodeURIComponent(req.post)
      let i= postdata.indexOf('?')
      let cmd= postdata.substring(0,i);
      let val= postdata.substring(i+1);

      if("jserver-guest"==cmd) // validate log on as guest
      {
         port= getguest();
         if(port==0)
          replynoc(200,res,'full up',port);
         else
         {
          cp.exec('sudo '+guestpath+'guest-sudo-sh jhs '+port);
          replyc(200,res,"valid",createcookie(port));
         }
      }
      else if("jserver-user"==cmd) // validate logon key
      {
         port= jhsport;
         log('user',postdata.substring(7));
         if(key==val)
          replyc(200,res,"valid",createcookie(port));
         else
          replynoc(200,res,"invalid key",port);
      }
      else if(c!=token ||  s!=gsnums[port-jhsport])
       replynoc(403,res,'logon required',port);
      else if("jbreak"==cmd)
      {
       cp.exec('sudo '+guestpath+'guest-sudo-sh break '+port);
       replyx(200,res,'break signalled');
      }
      else
      jhsreq("POST",jhshost,port,url,req.post,req,res); // pass to JHS
    });
     return;
  }

  // get
  if(url=="/favicon.ico") // favicon allowed even if not logged on
    jhsreq("GET",jhshost,port,url,"",req,res);
  if(url=="/jlogoff")
  {
   gtimes[port-jhsport]= 0;
   replynoc(200,res,'jlogoff',port)
  }
  else if(c!=token ||  s!=gsnums[port-jhsport])
   replynoc(200,res,'logon required',port);
  else
    jhsreq("GET",jhshost,port,url,"",req,res);
});

server.listen(nodeport, bind, () => {
  console.log(`JHS node proxy server running at https://${bind}:${nodeport}/`);
});

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

async function jhsreq(gp,host,port,url,body,req,res)
{
 let promise= dorequest(gp,host,port,url,body,req);
 promise.then(good,bad);
 function good(data){replyhb(200,res,data);}
 function bad(data) {replynoc(403,res,'request failed');}
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

function log(type,val){
  console.log('jhs '+Date.now()+' '+type+' '+val);
}
