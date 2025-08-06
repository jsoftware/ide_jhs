"use strict";
exports.__esModule = true;
var mover_1 = require("./mover");
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
    var move = (0, mover_1.mover)(separator, horizontal);
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
