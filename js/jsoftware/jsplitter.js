/*
 splitter src code has bug when resizing with more than 2 panes 
 tsc utility convert src mover.ts and pointer.ts to js files
 include those files in JS (with module stuff removed)
 add bug fix moverfix call to mover
*/

// pointer.js - change mover1 
//var mover_1 = require("./mover");
addEventListener("pointerdown", function (pointerDownEvent) {
    var separator = pointerDownEvent.target;
    var container = separator.parentElement;
    if (!container || !pointerDownEvent.isPrimary || pointerDownEvent.button !== 0 || separator.getAttribute("role") !== "separator") {
        return;
    }
    var horizontal = container.hasAttribute("data-flex-splitter-horizontal");
    if (!horizontal && !container.hasAttribute("data-flex-splitter-vertical")) {
        return;
    }
    var pointerId = pointerDownEvent.pointerId;
    var move = (0, mover)(separator, horizontal); //! mover1
    var onPointerMove = horizontal
        ? function (event) { return event.pointerId === pointerId && move(event.clientX - pointerDownEvent.clientX); }
        : function (event) { return event.pointerId === pointerId && move(event.clientY - pointerDownEvent.clientY); };
    var onLostPointerCapture = function (event) {
        if (event.pointerId === pointerId) {
            separator.removeEventListener("pointermove", onPointerMove);
            separator.removeEventListener("lostpointercapture", onLostPointerCapture);
        }
    };
    onPointerMove(pointerDownEvent);
    separator.addEventListener("lostpointercapture", onLostPointerCapture);
    separator.addEventListener("pointermove", onPointerMove);
    separator.setPointerCapture(pointerId);
    pointerDownEvent.preventDefault();
});

// mover.js - add moverfix call
var mover = function (separator, horizontal) {
    var _a;
    var pane1 = separator.previousElementSibling;
    var pane2 = separator.nextElementSibling;
    var parentStyle = getComputedStyle(separator.parentElement);
    if ((parentStyle.flexDirection.indexOf("reverse") !== -1 ? -1 : 1) * (horizontal && parentStyle.direction === "rtl" ? -1 : 1) === -1) {
        _a = [pane2, pane1], pane1 = _a[0], pane2 = _a[1];
    }
    var pane1ComputedStyle = getComputedStyle(pane1);
    var pane2ComputedStyle = getComputedStyle(pane2);

  if (horizontal) {
        var pane1InitialSize_1 = pane1.offsetWidth;
        var totalSize_1 = pane1InitialSize_1 + pane2.offsetWidth;
        var pane1MinSize_1 = Math.max(parseInt(pane1ComputedStyle.minWidth, 10) || 0, totalSize_1 - (parseInt(pane2ComputedStyle.maxWidth, 10) || totalSize_1));
        var pane1MaxSize_1 = Math.min(parseInt(pane1ComputedStyle.maxWidth, 10) || totalSize_1, totalSize_1 - (parseInt(pane2ComputedStyle.minWidth, 10) || 0));
        return function (movement) {
            var pane1Size = Math.round(Math.min(Math.max(pane1InitialSize_1 + movement, pane1MinSize_1), pane1MaxSize_1));

            moverfix(pane1,pane2); // ebi fix

            pane1.style.width = pane1Size + "px";
            pane2.style.width = totalSize_1 - pane1Size + "px";
            pane1.style.flexShrink = pane2.style.flexShrink = 1;
        };
    }
    else {
        var pane1InitialSize_2 = pane1.offsetHeight;
        var totalSize_2 = pane1InitialSize_2 + pane2.offsetHeight;
        var pane1MinSize_2 = Math.max(parseInt(pane1ComputedStyle.minHeight, 10) || 0, totalSize_2 - (parseInt(pane2ComputedStyle.maxHeight, 10) || totalSize_2));
        var pane1MaxSize_2 = Math.min(parseInt(pane1ComputedStyle.maxHeight, 10) || totalSize_2, totalSize_2 - (parseInt(pane2ComputedStyle.minHeight, 10) || 0));
        return function (movement) {
            var pane1Size = Math.round(Math.min(Math.max(pane1InitialSize_2 + movement, pane1MinSize_2), pane1MaxSize_2));

            moverfix(pane1,pane2); // ebi fix

            pane1.style.height = pane1Size + "px";
            pane2.style.height = totalSize_2 - pane1Size + "px";

            pane1.style.flexShrink = pane2.style.flexShrink = 1;
        };  
    }
};

function moverfix(pane1,pane2){
  const es= document.querySelectorAll('[role="separator"]');
  es.forEach(e => {
   let p= e.previousElementSibling;
    if(p!=pane1 && p!=pane2) {p.style.height= p.offsetHeight+'px';}
  });

  var q= es[es.length-1].nextElementSibling;
  if(q!=pane1 && q!=pane2) {q.style.height= q.offsetHeight+'px';}
}
