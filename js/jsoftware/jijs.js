var ta, rep, saveasx;

function ev_body_load() {
  ce = jbyid("ijs");
  window.cm6_creat(ce.value, document.getElementById("cm6_editor"));
  rep = jbyid("rep");
  ta = jbyid("textarea");
  saveasx = jbyid("saveasx");
  jresize();
}

function setdirty() { jbyid("jmenutitle").style.color = "red"; dirty = true; }
function setclean() { jbyid("jmenutitle").style.color = "blue"; dirty = false; }
function setnamed() { jbyid("jmenutitle").innerHTML = jbyid("filename").value; }

function click() {
  t = (dirty ? "dirty" : "clean") + JASEP;
  const [anchorLine, anchorCh, headLine, headCh] = window.cm6_getSelectionData();
  t = t + anchorLine + ' ' + anchorCh + ' ' + headLine + ' ' + headCh + JASEP;
  ta.value = window.cm6_gettext();
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
  jresize();
}

function ev_saveasclose_click() { jhide("saveasdlg"); jresize(); }

function ev_ro_click() { window.cm6_changeReadOnly(); }
function ev_numbers_click() { window.cm6_changeLineNumbers(); }
function ev_theme_click() { window.cm6_changeTheme(); }

// ajax response - ts[0] error ; ts[1] sentence ; advance_line ts[2]
function ajax(ts) {
  rep.innerHTML = ts[0];
  jhide("saveasdlg");
  if (0 != ts[0].length) return;
  setclean(); // no report means save was done
  switch (jform.jmid.value) {

    case 'close': winclose(); break;
    case 'save': break;
    case 'saveasx':
    case 'saveasdo':
      jbyid("filename").value = ts[1];
      setnamed();
      var t = ts[1].split('/');
      document.title = t[t.length - 1];
      break;
    case 'lineadv':
      var i = parseInt(ts[2]);
      window.cm6_setselection(i);
    default:
      jijxrun(ts[1]); // run sentence in jijx
  }
  jresize();
}

function ev_ijs_enter() { return true; }

function ev_comma_ctrl() { jscdo("line"); }
function ev_dot_ctrl() { jscdo("lineadv"); }
function ev_slash_ctrl() { jscdo("sel"); }

function ev_z_shortcut() { } // Handled by cm6.
function ev_y_shortcut() { }
function ev_p_shortcut() { jscdo("chelp"); }
function ev_t_shortcut() { jscdo("ro"); }
function ev_r_shortcut() { jscdo("runw"); }
function ev_s_shortcut() { jscdo("save"); }
function ev_h_shortcut() { jscdo("chelp"); }

//function ev_2_shortcut(){ce.focus();}

// override jscore.js defs
function ev_close_click() { if (dirty) click(); else winclose(); }
function ev_close_click_ajax(){ winclose(); }