coclass'testapp01'
coinsert'jhs'

0 : 0
app (browser page) with a few hmtl elements and event handlers
)

manapp=: 'jpage y must be ''''' NB. doc jpage y arg


NB. J lines run in jhs locale that define html for the page
HBS=: 0 : 0
        jhclose ''          NB. menu with close
'title' jhh1    'overview'
'b1'    jhb     'button-one'
jhbr
't1'    jhtext  ''
jhbr

'<div id="select">'
 'a1' jhb 'a1'
 jhbr
 'a2' jhb 'a2'
 jhbr
 'a3' jhb 'a3'
'</div>'

'<div onkeydown="alert("asdf");" ><button id="abc" name="abc" class="jhb" onclick="return jev(event)" >def</button> </div>'
)

NB. jpage (or url) calls to init page for browser
ev_create=: 3 : 0 
manapp assert ''-:y
jhrcmds ''
)

cnt=: 0

NB. click b1 -> ev_b1_click -> jhrcmds returns cmd to browser -> browser runs cmd
ev_b1_click=: {{
  q__=: NV
  jhrcmds 'set t1 *b1 clicked: ',":cnt=: cnt+1
}}

ev_a1_click=: {{
  q__=: NV
  jhrcmds 'set t1 *a1 clicked: ',":cnt=: cnt+1
}}


ev_a2_click=: {{
  q__=: NV
  jhrcmds 'set t1 *a2 clicked: ',":cnt=: cnt+1
}}

ev_za1_click=: {{
  q__=: NV
  jhrcmds 'set t1 *za1 clicked: ',":cnt=: cnt+1
}}

ev_za2_click=: {{
  q__=: NV
  jhrcmds 'set t1 *za2 clicked: ',":cnt=: cnt+1
}}



CSS=: 0 : 0
.highlight { background-color:#ff0; }
)

JS=: 0 : 0

function ev_body_load(){

jbyid('a1').focus();

var li= jbyid("select").children;
var liz= [];
for (var i= 0 ; i<li.length ; i++) { // remove br elements
    if (li[i].tagName == "BUTTON") {
        liz.push(li[i]);
    }
}
li= liz;

// Set up a counter to keep track of which <li> is selected
var currentLI = 0;

// Initialize first li as the selected (focused) one:
li[currentLI].classList.add("highlight");


// Set up a key event handler for the document
jbyid("select").addEventListener("keydown", function(event){
  
  // Check for up/down key presses
  switch(event.keyCode){
  
    case 38: // Up arrow    
      // Remove the highlighting from the previous element
      li[currentLI].classList.remove("highlight");
      
      currentLI = currentLI > 0 ? --currentLI : 0;     // Decrease the counter      
      li[currentLI].classList.add("highlight"); // Highlight the new element
      li[currentLI].focus();
      break;
    case 40: // Down arrow
      // Remove the highlighting from the previous element
      li[currentLI].classList.remove("highlight");
      
      currentLI = currentLI < li.length-1 ? ++currentLI : li.length-1; // Increase counter 
      li[currentLI].classList.add("highlight");       // Highlight the new element
      li[currentLI].focus();
      break;    
  }
  //  return false; ?
});

}

)
