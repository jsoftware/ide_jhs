var ta, rep, readonly, saveasx, cm;

function ev_body_load() {
  ce = jbyid("ijs");
  window.cm6_creat(ce.value, document.getElementById("cm6_editor"));
  rep = jbyid("rep");
  ta = jbyid("textarea");
  saveasx = jbyid("saveasx");
  ce.focus();
  // obsolete
  /*cm = CodeMirror.fromTextArea(ce,
    {
      lineNumbers: true,
      mode: "j",
      tabSize: 1,
      gutter: false,
      styleActiveLine: { nonEmpty: true },
      extraKeys: {
        "Ctrl-S": function (instance) { setTimeout(TOsave, 1); },
        "Ctrl-R": function (instance) { setTimeout(TOrunw, 1); }
      }
    }
  );
  cm.on("change", setdirty);
  ro(0 != ce.innerHTML.length);
  */
  dresize();
}

// obsolete
//function TOsave() { jscdo("save"); } // firefox needs ajax outside of event
//function TOrunw() { jscdo("runw"); }

window.onresize = dresize;
/*
function dresize() {
  // IE resize multiple frames sometimes gets id as null
  if (jbyid("jresizea") == null || jbyid("jresizeb") == null) return;
  var a = jgpwindowh(); // window height
  a -= jgpbodymh();     // body margin h (top+bottom)
  a -= jgpdivh("jresizea"); // header height
  a -= 5               // fudge extra
  a = a < 0 ? 0 : a;        // negative causes problems
  cm.setSize(window.innerWidth, a);
}
*/
function dresize() { /* Empty. */ }

function setdirty() { jbyid("filenamed").style.color = "red"; dirty = true; }
function setclean() { jbyid("filenamed").style.color = "blue"; dirty = false; }

function setnamed() { jbyid("filenamed").innerHTML = jbyid("filename").value; }

// obsolete
/*
function ro(only) {
  readonly = only;
  cm.setOption('readOnly', readonly ? true : false)
  cm.getWrapperElement().style.background = readonly ? "lightgray" : "#fff";
  ce.focus();
}
*/
function click() {
  // obsolete
  /* cm5 version 
  ta.value= cm.getValue().replace(/\t/g,' ');
  s= cm.doc.listSelections();
  t= (dirty?"dirty":"clean")+JASEP;
  t= t+s[0].anchor.line+' '+s[0].anchor.ch+' '+s[0].head.line+' '+s[0].head.ch+JASEP;
  */

  t = (dirty ? "dirty" : "clean") + JASEP;
  // TODO 
  t = t + 0 + ' ' + 0 + ' ' + 0 + ' ' + 0 + JASEP; //! need proper caret/selection values

  jdoajax(["filename", "textarea", "saveasx",], t);
}

function ev_save_click() { click(); }
function ev_runw_click() { click(); }
function ev_runwd_click() { click(); }
function ev_line_click() { click(); }
function ev_lineadv_click() { click(); }
function ev_sel_click() { click(); }
function ev_chelp_click() { click(); }

function ev_undo_click() { window.cm6_undo(); }
function ev_redo_click() { window.cm6_redo(); }
function ev_find_click() { window.cm6_findAll(); }
function ev_next_click() { window.cm6_findNext(); }
function ev_previous_click() { window.cm6_findPrev(); }
function ev_replace_click() { window.cm6_replaceNext(); }
function ev_repall_click() { window.cm6_replaceAll(); }

function ev_saveasdo_click() { click(); }
function ev_saveasx_enter() { click(); }

function ev_saveas_click() {
  saveasx.value = jbyid("filename").value;
  jdlgshow("saveasdlg", "saveasx");
  dresize();
}

function ev_saveasclose_click() { jhide("saveasdlg"); dresize(); }

function ev_ro_click() { window.cm6_changeReadOnly(); }
function ev_numbers_click() { window.cm6_changeLineNumbers(); }

// ajax response - ts[0] error ; ts[1] sentence ; advance_line ts[2]
function ajax(ts) {
  rep.innerHTML = ts[0];
  jhide("saveasdlg");
  if (0 != ts[0].length) return;
  setclean(); // no report means save was done
  switch (jform.jmid.value) {

    case 'close': winclose(); break;

    case 'saveasx':
    case 'saveasdo':
      jbyid("filename").value = ts[1];
      setnamed();
      var t = ts[1].split('/');
      document.title = t[t.length - 1];
      break;
    case 'lineadv':
      i = parseInt(ts[2]);
      alert("Kernel panic! Guru Meditation!");
      if (i < cm.doc.lineCount()) cm.doc.setCursor(i, cm.doc.getLine(i).length);
    default:
      jijxrun(ts[1]); // run sentence in jijx
  }

  dresize();
}

function ev_ijs_enter() { return true; }

function ev_comma_ctrl() { jscdo("line"); }
function ev_dot_ctrl() { jscdo("lineadv"); }
function ev_slash_ctrl() { jscdo("sel"); }

function ev_z_shortcut() { cm.undo(); }
function ev_y_shortcut() { cm.redo(); }
function ev_p_shortcut() { jscdo("chelp"); }
function ev_t_shortcut() { jscdo("ro"); }
function ev_r_shortcut() { jscdo("runw"); }
function ev_s_shortcut() { jscdo("save"); }
function ev_h_shortcut() { jscdo("chelp"); }

//function ev_2_shortcut(){ce.focus();}

// override jscore.js defs
function ev_close_click() { if (dirty) click(); else winclose(); }
function ev_close_click_ajax() { setclean(); winclose(); }
