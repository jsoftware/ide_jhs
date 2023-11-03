/* jhs proxy server
 Cookie: handled in node to manage logon
 Expect: (chunk) handled in node and complete result passed to client
 see: ~addons/ide/jhs/node.ijs
*/

/* jhs_cookie
cookie only created once by replyc on valid login
cookie expires at max-age
failure does markinvalid to set gsnums port entry so cookie will be invalid in the future
invalid (but not expired) cookie time prevents new login to soon after previous
*/

var t= process.argv[1];
const guestpath= t.substring(0,t.lastIndexOf('/')+1); // path to guest folder

var a= process.argv.slice(2);
const nodeport=a[0];const key=a[1];const jhsport=a[2];const breakfile=a[3];  //! a[4] unused - was pem
const guests=parseInt(a[5]);const limit=parseInt(a[6]);const maxage=parseInt(a[7]);

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

var logonhtml= fs.readFileSync((guestpath+'guest.html'),'utf8'); // not const to allow dynamic changes

var gtimes= Array(guests).fill(0); // 0 or time when port was allocated
var gsnums= Array(guests).fill(0); // 0 or serial number of valid port
var snum=1;

// mark OLD ports as free
function clearguests(){
 for (let i = 0; i < gtimes.length; i++) {
  if(Date.now()>gtimes[i]+(1000*limit)){ gtimes[i]=0; gsnums[i]=0;}
 }
}

// return free guest port or 0
function getguest(){
 for (let i = 0; i < gsnums.length; i++) {
  if(gsnums[i]==0) return guestbase+i;
 }
 return 0;
}

// cookie: token+snum+port+ontime
function createcookie(port){
 let i= port-guestbase;
 gtimes[i]=Date.now();
 snum= 1+snum;
 gsnums[i]= snum;
 log('cookie',snum+'+'+port);
 return token+'+'+snum+'+'+port+'+'+Date.now();
}

function gethtml(status){return logonhtml.replace("STATUS",status).replace("LIMIT",limit/60)};

// client reponse with text
function replyx(code,res,p){res.writeHead(code, "OK", {'Content-Type': 'text/html'});res.end(p);}

// client response with cookie and text
function replyc(code,res,p,cval)
{
  res.writeHead(code, "OK", {'Set-Cookie':cookiename+"="+cval+";Max-Age="+maxage+";Secure;Httponly",'Content-Type': 'text/html'});
  res.end(p);
}

// code 403 aborts ajax request which sets location /jserver
// code 200 replies with page html with status set as p
function replynoc(code,res,p,port){
 log('noc',code+' '+port+' '+p);
 if(code==200) p= gethtml(p);
 replyx(code,res,p);
}

function markinvalid(port){if(jhsport!=port) gsnums[port-guestbase]= 0;}

// client response with headers and body string
function replyhb(code,res,p)
{
  res.writeHead(code, "OK", p['headers']);
  res.end(Buffer.from(p['body'],'binary')) // must be buffer to avoid utf8 stuff
}

const options = {
  //key: fs.readFileSync(pem+'/key.pem'),
  //cert: fs.readFileSync(pem+'/cert.pem'),
  key:  fs.readFileSync('/jguest/jkey'),
  cert: fs.readFileSync('/jguest/jcert'),
  'trust proxy': true
};

const server = https.createServer(options, (req, res) => {
  logonhtml= fs.readFileSync((guestpath+'guest.html'),'utf8'); //! dynamic changes
  clearguests();
  var cval= get_cookies(req)['jhs_cookie'];
  if(typeof(cval)=='undefined') cval= NOC; 
  var p= cval.split('+');
  if(token!=p[0]){cval=NOC; p=cval.split('+');} // cval reset if from another node instance
  var c= p[0];
  var s= p[1];
  var port= p[2];
  var ontime= parseInt(p[3]); // time session started
  var valid= port!=0 && c==token && s==gsnums[port-guestbase];
  // log('valid',valid+' '+cval);

  var url= decodeURIComponent(req.url);
  var  ip= req.connection.remoteAddress; //! req.ip is express only

  if(req.method == 'POST')
  {
    dopost(req, res, function() {
      let postdata= decodeURIComponent(req.post)
      let i= postdata.indexOf('?')
      let cmd= postdata.substring(0,i);
      let val= postdata.substring(i+1);

      if("jserver-guest"==cmd) // validate log on as guest
      {
         //if already valid guest - continue
         if(valid)
         {
          replyx(200,res,"valid"); // cookie stays the same
          return;
         }
         port= getguest();
         if(port==0)
          replyx(200,res,'full up',port);
         else
         {
          // logon not allowed if last logon was too recent

          var wait=(ontime+((limit+maxage)*1000))-Date.now();
          if(ontime!=0 && wait>0)
          {
           replyx(200,res,'try again in '+(Math.ceil(wait/(60*1000)))+' minutes',port);
           //replyx(200,res,'try again in '+wait+' millis',port);
           return;
          }
          log('guest',port);
          cp.exec('sudo '+guestpath+'guest-sudo-sh jhs '+port+' '+limit);
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
          replyx(200,res,"invalid key",port);
      }
      else if(!valid) replynoc(403,res,'login required',port);
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
  if(url=='/jserver')
  {
   if(valid)
    jhsreq("GET",jhshost,port,"/jijx","",req,res);
   else
    replynoc(200,res,'login required',port)
  }
  else if(url=="/favicon.ico") // favicon allowed even if not logged on
    jhsreq("GET",jhshost,port,url,"",req,res); //! needs work - get node local copy???
  else if(!valid)
   replynoc(200,res,'login required',port);
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
 function bad(data) {markinvalid(port);replynoc(403,res,'request failed',port);} //!
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
