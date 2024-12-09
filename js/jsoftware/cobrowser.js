// Firefox 1.0+
var isFirefox = typeof InstallTrigger !== 'undefined';
// Internet Explorer 6-11
var isIE = /*@cc_on!@*/false || !!document.documentMode;
// Edge 20+
var isEdge = !isIE && !!window.StyleMedia;
// Chrome 1+
var isChrome = !!window.chrome && !!window.chrome.webstore;


var cowdi= [ 150, 230, 100, 300, 480 ];
var cohti= [ 200, 200, 200, 400, 195 ];
var cowd= [ 150, 230, 100, 300, 480 ];
var coht= [ 200, 200, 200, 400, 195 ];

if (isIE || isChrome ) {
 cohti[4] = 211;
 coht[4] = 211;
}

var sizenames= [ "#menu0",  "#menu1",  "#menu2",  "#menu3",  "#textdisp" ];

function jevdo()
{
    if(jform.jmid.value!='body') alert('event');
//    alert('jevdo');
// Modified for Firefox and NonFirefox and jQueryUI
 if (jform.jmid.value == '') {
    alert('huh');
  return false;  // for Edge and Chrome
 }
 var jfmv= jform.jmid.value.substring(0,6);
 if('ui-id-' == jfmv && jform.jtype.value == 'click' ) 
 {
 jform.jmid.value= jevtarget.parentElement.parentElement.id;
 jform.jtype.value= "menuselect";
 alert(jform.jmid.value+' '+jform.type.value); //!
 }
 JEV= "ev_"+jform.jmid.value+"_"+jform.jtype.value;

 if(jform.jmid.value!='body') alert(JEV);

 var rooba;
 var evalret=false;
 try {rooba=eval("typeof "+JEV)}
 // catch(ex){alert(JEV+" failed: "+ex);return false;}
 catch(ex){evalret=true}
 if(('undefined'==rooba) || evalret)
 {
  // undef returns true or does alert and returns false for events that should have handlers 
  if(null==jevtarget)return true;
  if(jform.jtype.value=="click"||jform.jtype.value=="enter"){alert("not defined: function "+JEV+"()");return false;}
  return true;
 }
 try{var r= eval(JEV+"();")}
 catch(ex){alert(JEV+" failed: "+ex);return false;}
 if('undefined'!=typeof r) return r;
 return false;
}
 
function ev_refresh_click(e) {
 jdoajax( ["id"] )
}

function ev_refresh_click_ajax(ts) {
    alert(ts);
 $( "#menu0" ).empty();
 $( "#menu0" ).append(ts[0]);
 $( "#menu0" ).menu("refresh");
 $( "#menu0" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" ); 
 $( "#menu1" ).empty();
 $( "#menu1" ).append(ts[1]);
 $( "#menu1" ).menu("refresh");
 $( "#menu1" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#menu3" ).empty();
 $( "#menu3" ).append(ts[2]);
 $( "#menu3" ).menu("refresh");
 $( "#menu3" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#textdisp" ).html(ts[3]);
 $( "#stscript" ).html(ts[4]);
 $( "#stspace" ).html(ts[5]);
 $( "#stshape" ).html(ts[6])
}

function ev_open_click(e) {
 jdoajax( ["id"] )
}

function ev_open_click_ajax(ts) {
}

function ev_scriptdoc_click(e) {
 jdoajax(["id"] )
}

function ev_scriptdoc_click_ajax(ts) {
document.getElementById('stscript').title = ts;
}

function ev_copyname_click(e) {
 jdoajax( ["id"] )
}

function ev_copyname_click_ajax(ts) {
}

function ev_copypath_click(e) {
 jdoajax( ["id"] )
}

function ev_copypath_click_ajax(ts) {
}

function ev_menu0_menuselect() {
    alert('menu0');
 var d = jform.index;
 jdoajax( ["index"], d );
}

function ev_menu0_menuselect_ajax(ts) {
 $( "#menu1" ).empty();
 $( "#menu1" ).append(ts[0]);
 $( "#menu1" ).menu("refresh");
 $( "#menu1" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#menu3" ).empty();
 $( "#menu3" ).append(ts[1]);
 $( "#menu3" ).menu("refresh");
 $( "#menu3" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#textdisp" ).html(ts[2]);
 $( "#stscript" ).html(ts[3]);
 $( "#stspace" ).html(ts[4]);
 $( "#stshape" ).html(ts[5])
}

function ev_menu1_menuselect() {
 var d = jform.index;
 jdoajax( ["index"], d );
}

function ev_menu1_menuselect_ajax(ts) {
 $( "#menu3" ).empty();
 $( "#menu3" ).append(ts[0]);
 $( "#menu3" ).menu("refresh");
 $( "#menu3" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#textdisp" ).html(ts[1]);
 $( "#stscript" ).html(ts[2]);
 $( "#stspace" ).html(ts[3]);
 $( "#stshape" ).html(ts[4])
}

function ev_menu2_menuselect() {
 var d = jform.index;
 jdoajax( ["index"], d );
}

function ev_menu2_menuselect_ajax(ts) {
 $( "#menu3" ).empty();
 $( "#menu3" ).append(ts[0]);
 $( "#menu3" ).menu("refresh");
 $( "#menu3" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#textdisp" ).html(ts[1]);
 $( "#stscript" ).html(ts[2]);
 $( "#stspace" ).html(ts[3]);
 $( "#stshape" ).html(ts[4]);
}

function ev_menu3_menuselect() {
 var d = jform.index;
 jdoajax( ["index"], d );
}

function ev_menu3_menuselect_ajax(ts) {
 $( "#textdisp" ).html(ts[0]);
 $( "#stscript" ).html(ts[1]);
 $( "#stspace" ).html(ts[2]);
 $( "#stshape" ).html(ts[3]);
}

function menuselect( t, e, ui ) {
        
 // Remove the highlight class from any existing items.
 t.find( "a.ui-state-highlight" )
        .removeClass( "ui-state-highlight" );

 // Adds the "ui-state-highlight" class to the selected item.
 ui.item.find( "> a" )
        .addClass( "ui-state-highlight ui-corner-all" );    
        
 // Calls ev_menu0_select 
 var d = ui.item.index();
 jform.index = d+1; // bug in later || with 0 
 jev(e);
}
    
function positioner() {
 $( ".toolbar" ).position({
  my: "left top",
  at: "left+3 bottom",
  of: "#data"
 });
 $( "#menu0h" ).position({
  my: "left top",
  at: "left bottom",
  of: ".toolbar"
 });
 $( "#menu0" ).position({
  my: "left top",
  at: "left bottom",
  of: "#menu0h"
 });
 if ( isFirefox ) {
 $( "#menu1" ).position({
  my: "left top",
  at: "right top",
  of: "#menu0"
 });
 $( "#menu2" ).position({
  my: "left top",
  at: "right top",
  of: "#menu1"
 });
} else {
 if ( isEdge ) {
 $( "#menu1" ).position({
  my: "left top",
  at: "right+12 top",
  of: "#menu0"
 });
 $( "#menu2" ).position({
  my: "left top",
  at: "right+12 top",
  of: "#menu1"
 });
  } else {
   $( "#menu1" ).position({
    my: "left top",
    at: "right+17 top",
    of: "#menu0"
   });
   $( "#menu2" ).position({
    my: "left top",
    at: "right+17 top",
    of: "#menu1"
   });
  }
 }
  $( "#menu3" ).position({
  my: "left top",
  at: "right top",
  of: "#menu2"
 });
 $( "#menu1h" ).position({
  my: "left bottom",
  at: "left top",
  of: "#menu1"
 });
 $( "#menu2h" ).position({
  my: "left bottom",
  at: "left top",
  of: "#menu2"
 });
 $( "#menu3h" ).position({
  my: "left bottom",
  at: "left top",
  of: "#menu3"
 });
 if ( isEdge ) {
 $( "#textdisp" ).position({
  my: "left top",
  at: "left bottom+12",
  of: "#menu0"
 });
 } else {
 $( "#textdisp" ).position({
  my: "left top",
  at: "left bottom",
  of: "#menu0"
 });
 }
 if ( isIE || isEdge || isChrome ) {
 $( "#stshape" ).position({
  my: "left top",
  at: "left bottom+17",
  of: "#menu3"
 });
 $( "#stspace" ).position({
  my: "right top",
  at: "right-50 bottom+17",
  of: "#menu3"
 });
 $( "#stscript" ).position({
  my: "left top",
  at: "left bottom+17",
  of: "#textdisp"
 });
 } else {
 $( "#stshape" ).position({
  my: "left top",
  at: "left bottom",
  of: "#menu3"
 });
 $( "#stspace" ).position({
  my: "right top",
  at: "right-50 bottom",
  of: "#menu3"
 });
 $( "#stscript" ).position({
  my: "left top",
  at: "left bottom",
  of: "#textdisp"
 });
 }
 $( "#data" ).position({
  my: "left top",
  at: "right top+3",
  of: "#close"
 });
if ( isFirefox ) {
 $( "#resizer" ).position({
  my: "left top",
  at: "right-15 bottom-15",
  of: "#menu3"
 });
} else {
 $( "#resizer" ).position({
  my: "left top",
  at: "right bottom",
  of: "#menu3"
 });
}
}

function ev_body_load(){

 var basicControls = [ "#refresh", "#open", "#scriptdoc", "#copyname", "#copypath" ];
 $( basicControls.join(", ") ).on( "click change selectmenuchange",this.id,jev );

 if (isIE || isChrome ) {
  $( "#close" ).css({ "font-size":"12px" });
  $( "#textdisp" ).css({ "height" : "211" });
 }
 
 var pos1 = [ 0, 0, 0 ];
 var pos2 = [ 0, 0, 0 ];
 var firstpos;
 var gotpos = 0;
 var deltap;
 var resizepos;
 
 $( "#resizer" ).draggable({
  start: function(ev,ui) {
   updateCounterStatus( 0, ui.position );
 },
 drag: function(ev,ui) {
   updateCounterStatus( 1, ui.position );
 },
 stop: function(ev,ui) {
   updateCounterStatus( 2, ui.position );
   deltap = [ (pos1[2]-firstpos.left), (pos2[2]-firstpos.top) ];
   if ( (pos1[2] < firstpos.left) || (pos2[2] < firstpos.top) ) {
    resizepos= "right+"+firstpos.left.text+" bottom+"+firstpos.top.text;
    deltap= [ 0, 0 ];
    $( "#resizer" ).position({
      my: "left top",
      at: resizepos,
      of: "#menu3"
    });
   } 
   deltap = [ 1+deltap[0]/firstpos.left, 1+deltap[1]/firstpos.top ];
   for ( var i = 0; i < 5; i++ ) {    
    $( sizenames[i] ).css({ "width": deltap[0]*cowd[i] });
    $( sizenames[i] ).css({ "height": deltap[1]*coht[i] });
   }
   positioner();
 } 
 });
    
 function updateCounterStatus( i, pos ) {
  if (gotpos == 0) {
   firstpos= pos;
   gotpos= 1;
  }
  pos1[i]= pos.left;
  pos2[i]= pos.top;
 }

 $( "#refresh" ).button({
  icon: "ui-icon-refresh",
  showLabel: false
 });
 $( "#open" ).button({
  icon: "ui-icon-folder-open",
  showLabel: false
 });
 $( "#scriptdoc" ).button({
  icon: "ui-icon-help",
  showLabel: false
 });
 $( "#copyname" ).button({
  icon: "ui-icon-copy",
  showLabel: false
 });
 $( "#copypath" ).button({
  icon: "ui-icon-link",
  showLabel: false
 });
 $( ".toolbar" ).controlgroup();

 $( "#menu0" ).menu({       
     select: function( e, ui ) { menuselect( $( this ), e, ui ); }
 });
 $( "#menu0" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#menu1" ).menu({
      select: function( e, ui ) { menuselect( $( this ), e, ui ); }
 });
 $( "#menu1" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#menu2" ).menu({
      select: function( e, ui ) { menuselect( $( this ), e, ui ); }
 });
 $( "#menu2" ).find( "a:eq(4)" ).addClass( "ui-state-highlight ui-corner-all" );
 $( "#menu3" ).menu({
      select: function( e, ui ) { menuselect( $( this ), e, ui ); }
 });
 $( "#menu3" ).find( "a:eq(0)" ).addClass( "ui-state-highlight ui-corner-all" );
 positioner();
}
