import { lineNumbers, highlightActiveLineGutter, highlightSpecialChars, dropCursor, drawSelection, rectangularSelection, crosshairCursor, highlightActiveLine, keymap, EditorView } from "../codemirror6/view/dist/index.js";
import { LRLanguage, LanguageSupport, HighlightStyle, syntaxHighlighting, indentService, IndentContext, bracketMatching } from "../codemirror6/language/dist/index.js";
import { EditorState, Compartment } from '../codemirror6/state/dist/index.js';
import { history, defaultKeymap, historyKeymap, undo, redo } from '../codemirror6/commands/dist/index.js';
import { closeBrackets, closeBracketsKeymap } from '../codemirror6/autocomplete/dist/index.js';
import { search, searchKeymap, openSearchPanel, highlightSelectionMatches, findNext, findPrevious, replaceNext, replaceAll, selectMatches } from '../codemirror6/search/dist/index.js';
import { LRParser, LocalTokenGroup } from "../lezer/lr/dist/index.js";
import { tags, styleTags } from "../lezer/highlight/dist/index.js";

// Code mirror 6 view is private variable in this module. 
// At the end of this file there are "exported functions" to access it.
let cm6;
let lineNumbersState = true;
let lineNumbersCompartment = new Compartment;
let readOnlyCompartment = new Compartment;

const parser = LRParser.deserialize({
  version: 14,
  states: "&SQ]QPOOP!gOPOOO!lQPO'#CyO!sQPO'#C}OOQO'#Cj'#CjOOQO'#DS'#DSO!zQPO'#CiOOQO'#Ci'#CiOOQO'#DR'#DRQ]QPOOP$UOQO'#C^POOO)C>z)C>zOOQO,59e,59eO$dQPO,59eO$kQPO,59eOOQO,59i,59iO$rQPO,59iO$yQPO,59iOOQO-E7Q-E7QOOQO,59T,59TOOQO-E7P-E7PPOOO,58x,58xP%QOQO,58xP%]OSO,58}OOQO1G/P1G/PO%hQPO1G/POOQO1G/T1G/TO%oQPO1G/TPOOO1G.d1G.dP%vOSO1G.iPOOO'#DQ'#DQP%vOSO1G.iPOOO1G.i1G.iOOQO7+$k7+$kOOQO7+$o7+$oP&ROSO7+$TPOOO7+$T7+$TPOOO-E7O-E7OPOOO<<Go<<Go",
  stateData: "&q~OyOSPOSRPQ~O_SO`SOaSObSOcSOdSOeSOfSOgSOhSOiSOjSOkSOlSOnQOpSOrROzVO~ORYO~Oo[O~P]Os_O~P]O_SO`SOaSObSOcSOdSOeSOfSOgSOhSOiSOjSOkSOlSOnQOpSOrROzcO~OSfOTeOUeOWgO~OohO~P!zOohO~P]OsjO~P!zOsjO~P]OTlOUlOWmO~OXnOYnOZpO~OoqO~P!zOsrO~P!zOXnOYnOZtO~OXnOYnOZvO~Obe`dgilfhjckprsP_h~",
  goto: "#pwPPxPPPPxPPPPP{!TPPPPPPPPPPPPPP!bPPP!bPP!o!y#XRZP]WOQRX^agTOQRUX]^`aikgSOQRUX]^`aikQogQsmTuosQXOQ^QQaRVdX^aSUOXQ]QQ`RYbU]`ikQi^Rka",
  nodeNames: "⚠ Comment NounSinglelineDef NounDefBegin NounSinglelineDefContent NounSinglelineDefEnd NounDoublelineDefEnd NounMultilineDef NounSinglelineDefNewline NounMultilineDefContent NounMultilineDefNewline NounMultilineDefEnd Program Sentence PartOfSpeech Identifier Number String InvalidToken1 InvalidToken2 Noun Verb1 Verb2 Adverb1 Adverb2 Conjunction1 Conjunction2 Conjunction3 Assignment DirectDef DirectUnknownDefBegin DirectDefEnd Control ControlBlock ControlBegin ControlEnd",
  maxTerm: 42,
  nodeProps: [
    ["closedBy", 3, "NounSinglelineDefEnd NounDoublelineDefEnd NounMultilineDefEnd", 30, "DirectDefEnd", 34, "ControlEnd"],
    ["openedBy", -3, 5, 6, 11, "NounDefBegin", 31, "DirectUnknownDefBegin", 35, "ControlBegin"]
  ],
  skippedNodes: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36],
  repeatNodeCount: 3,
  tokenData: "!-c~R!oXY&SYZ&_pq&Sqr&drs'Vst'mtu'muv'mvw'xwx)Pz{'m{|'m|}'m}!O'm!O!P)q!P!Q*U!Q![*t![!]+|!]!^,X!^!_'m!_!`,d!`!a'm!a!b,z!b!c-X!c!d-i!d!e-}!e!f-i!f!g-}!g!h-i!h!i.`!i!j-}!j!k.w!k!l-i!l!n-}!n!o/]!o!p/t!p!q0_!q!u-}!u!v1s!v!w-i!w!|-}!|!}2X!}#O,X#O#P2m#P#Q2x#Q#R3`#R#S3k#S#T4a#T#U4i#U#V7|#V#W9|#W#X?w#X#Y@`#Y#ZDV#Z#[Gm#[#]-}#]#^J^#^#_-i#_#`-}#`#aKa#a#b.w#b#c-}#c#d-i#d#eM^#e#fM}#f#gNf#g#h!#Q#h#i!%l#i#j!(^#j#k!(u#k#l!)Z#l#m2X#m#o-}#o#p!+a#p#q'm#q#r!,s#r#s!-W~&XQy~XY&Spq&S~&dOz~~&iQf~!O!P&o![!]&o~&tQi~!O!P&z![!]&z~'PQb~!O!P&z![!]&z~'[Qj~!O!P'b![!]'b~'gQf~!O!P&z![!]&z~'rQf~!O!P'b![!]'b~'}Qj~!O!P(T![!](t~(YQj~!O!P(`![!](i~(cQ!O!P&z![!]&z~(nQj~!O!P&z![!]&z~(yQj~!O!P(`![!](`~)SUOY)PZw)Pwx)fx;'S)P;'S;=`)k<%lO)P~)kOa~~)nP;=`<%l)P~)vQk~!O!P)|![!](`~*RPc~!O!P)|~*ZQh~!O!P*a![!]'b~*fPh~!O!P*i~*nQh~!O!P&z![!]&z~*yU`~!O!P+]!Q![+]![!]+q!c!}+]#R#S+]#T#o+]~+bT`~!O!P+]!Q![+]!c!}+]#R#S+]#T#o+]~+vQe~!O!P&z![!]&z~,RQj~!O!P(i![!](i~,^Qf~!O!P&o![!]'b~,iQf~!O!P,o![!],o~,tQl~!O!P&z![!]&z~-PPf~!O!P-S~-XOf~~-^Qj~!O!P-d![!]-d~-iOj~~-nT_~!O!P'b!Q![-}!c!}-}#R#S-}#T#o-}~.SS_~!Q![-}!c!}-}#R#S-}#T#o-}~.eU_~!O!P+|!Q![-}![!]+|!c!}-}#R#S-}#T#o-}~.|T_~!O!P-d!Q![-}!c!}-}#R#S-}#T#o-}~/bU_~!O!P'b!Q![-}![!](i!c!}-}#R#S-}#T#o-}~/yT_~!O!P0Y!Q![-}!c!}-}#R#S-}#T#o-}~0_Oh~~0dU_~!Q![-}!c!d-}!d!e0v!e!}-}#R#S-}#T#o-}~0{T_~!O!P1[!Q![-}!c!}-}#R#S-}#T#o-}~1aSP~OY1[Z;'S1[;'S;=`1m<%lO1[~1pP;=`<%l1[~1xT_~!Q![-}![!](i!c!}-}#R#S-}#T#o-}~2^T_~!Q![-}![!]'b!c!}-}#R#S-}#T#o-}~2rQh~!O!P*i![!]'b~2}Qf~!O!P&o![!]3T~3YQg~!O!P&z![!]&z~3eQf~!O!P'b![!]&o~3pU`~!O!P+]!Q![*t![!]4S!c!}+]#R#S*t#T#o+]~4ZQe~f~!O!P&z![!]&z~4fPj~![!](i~4nW_~!O!P5W!Q![-}![!]5W!c!}-}#R#S-}#T#g-}#g#h5c#h#o-}~5]Qd~!O!P&z![!]&z~5hU_~!Q![-}!c!}-}#R#S-}#T#g-}#g#h5z#h#o-}~6PU_~!Q![-}!c!}-}#R#S-}#T#X-}#X#Y6c#Y#o-}~6hU_~!Q![-}!c!}-}#R#S-}#T#f-}#f#g6z#g#o-}~7PU_~!Q![-}!c!}-}#R#S-}#T#h-}#h#i7c#i#o-}~7hT_~!O!P7w!Q![-}!c!}-}#R#S-}#T#o-}~7|Op~~8RV_~!O!P0Y!Q![-}!c!}-}#R#S-}#T#f-}#f#g8h#g#o-}~8mU_~!Q![-}!c!}-}#R#S-}#T#X-}#X#Y9P#Y#o-}~9UT_~!Q![-}!c!}-}#R#S-}#T#U9e#U#o-}~9jU_~!Q![-}!c!}-}#R#S-}#T#_-}#_#`7c#`#o-}~:RW_~!O!P'b!Q![-}!c!}-}#R#S-}#T#U:k#U#c-}#c#d=`#d#o-}~:pV_~!Q![-}!c!}-}#R#S-}#T#g-}#g#h;V#h#i;n#i#o-}~;[U_~!Q![-}!c!}-}#R#S-}#T#X-}#X#Y7c#Y#o-}~;sU_~!Q![-}!c!}-}#R#S-}#T#V-}#V#W<V#W#o-}~<[U_~!Q![-}!c!}-}#R#S-}#T#[-}#[#]<n#]#o-}~<sX_~!O!P7w!Q![-}!c!}-}#R#S-}#T#W-}#W#X7c#X#h-}#h#i7c#i#o-}~=eU_~!Q![-}!c!}-}#R#S-}#T#b-}#b#c=w#c#o-}~=|U_~!Q![-}!c!}-}#R#S-}#T#h-}#h#i>`#i#o-}~>eU_~!Q![-}!c!}-}#R#S-}#T#]-}#]#^>w#^#o-}~>|U_~!Q![-}!c!}-}#R#S-}#T#b-}#b#c?`#c#o-}~?eU_~!Q![-}!c!}-}#R#S-}#T#i-}#i#j;V#j#o-}~?|U_~!Q![-}!c!}-}#R#S-}#T#c-}#c#d7c#d#o-}~@eX_~!O!P'b!Q![-}!c!}-}#R#S-}#T#`-}#`#aAQ#a#b-}#b#cCT#c#o-}~AVU_~!Q![-}!c!}-}#R#S-}#T#g-}#g#hAi#h#o-}~AnU_~!Q![-}!c!}-}#R#S-}#T#X-}#X#YBQ#Y#o-}~BVV_~!O!P7w!Q![-}!c!}-}#R#S-}#T#]-}#]#^Bl#^#o-}~BqU_~!Q![-}!c!}-}#R#S-}#T#Y-}#Y#Z7c#Z#o-}~CYU_~!Q![-}!c!}-}#R#S-}#T#W-}#W#XCl#X#o-}~CqT_~!O!PDQ!Q![-}!c!}-}#R#S-}#T#o-}~DVOs~~D[X_~!O!P0Y!Q![-}!c!}-}#R#S-}#T#V-}#V#WDw#W#c-}#c#dEt#d#o-}~D|T_~!Q![-}!c!}-}#R#S-}#T#UE]#U#o-}~EbU_~!Q![-}!c!}-}#R#S-}#T#g-}#g#h;V#h#o-}~EyU_~!Q![-}!c!}-}#R#S-}#T#f-}#f#gF]#g#o-}~FbT_~!O!PFq!Q![-}!c!}-}#R#SFv#T#o-}~FvOr~~F{S_~!Q![-}!c!}GX#R#S-}#T#oGX~G^T_~!O!PFq!Q![GX!c!}GX#R#SGX#T#oGX~GrU_~!Q![-}!c!}-}#R#S-}#T#c-}#c#dHU#d#o-}~HZU_~!Q![-}!c!}-}#R#S-}#T#h-}#h#iHm#i#o-}~HrU_~!Q![-}!c!}-}#R#S-}#T#c-}#c#dIU#d#o-}~IZS_~!Q![-}!c!}-}#R#SIg#T#o-}~IlS_~!Q![-}!c!}Ix#R#S-}#T#oIx~I}T_~!O!P7w!Q![Ix!c!}Ix#R#SIx#T#oIx~JcW_~!O!P'b!Q![-}![!]'b!c!}-}#R#S-}#T#Y-}#Y#ZJ{#Z#o-}~KQT_~!O!PFq!Q![-}!c!}-}#R#S-}#T#o-}~KfT_~!Q![-}!c!}-}#R#S-}#T#UKu#U#o-}~KzU_~!Q![-}!c!}-}#R#S-}#T#U-}#U#VL^#V#o-}~LcU_~!Q![-}!c!}-}#R#S-}#T#X-}#X#YLu#Y#o-}~LzU_~!Q![-}!c!}-}#R#S-}#T#`-}#`#aIU#a#o-}~McU_~!O!PMu!Q![-}![!]-S!c!}-}#R#S-}#T#o-}~MzPf~!O!P'b~NSU_~!O!P(`!Q![-}![!]-S!c!}-}#R#S-}#T#o-}~NkV_~!O!P'b!Q![-}!c!}-}#R#S-}#T#X-}#X#Y! Q#Y#o-}~! VU_~!Q![-}!c!}-}#R#S-}#T#h-}#h#i! i#i#o-}~! nU_~!Q![-}!c!}-}#R#S-}#T#i-}#i#j!!Q#j#o-}~!!VU_~!Q![-}!c!}-}#R#S-}#T#f-}#f#g!!i#g#o-}~!!nU_~!Q![-}!c!}-}#R#S-}#T#b-}#b#c7c#c#o-}~!#VV_~!Q![-}![!]'b!c!}-}#R#S-}#T#X-}#X#Y!#l#Y#o-}~!#qU_~!Q![-}!c!}-}#R#S-}#T#`-}#`#a!$T#a#o-}~!$YU_~!Q![-}!c!}-}#R#S-}#T#X-}#X#Y!$l#Y#o-}~!$qU_~!Q![-}!c!}-}#R#S-}#T#V-}#V#W!%T#W#o-}~!%YU_~!Q![-}!c!}-}#R#S-}#T#h-}#h#iJ{#i#o-}~!%qX_~!O!P-d!Q![-}!c!}-}#R#S-}#T#[-}#[#]!&^#]#f-}#f#g!'u#g#o-}~!&cU_~!Q![-}!c!}-}#R#S-}#T#f-}#f#g!&u#g#o-}~!&zU_~!Q![-}!c!}-}#R#S-}#T#c-}#c#d!'^#d#o-}~!'cU_~!Q![-}!c!}-}#R#S-}#T#k-}#k#l7c#l#o-}~!'zU_~!Q![-}!c!}-}#R#S-}#T#m-}#m#nJ{#n#o-}~!(cU_~!O!P-S!Q![-}![!]'b!c!}-}#R#S-}#T#o-}~!(zT_~!O!P-S!Q![-}!c!}-}#R#S-}#T#o-}~!)`U_~!Q![-}!c!}-}#R#S-}#T#[-}#[#]!)r#]#o-}~!)wU_~!Q![-}!c!}-}#R#S-}#T#]-}#]#^!*Z#^#o-}~!*`U_~!Q![-}!c!}-}#R#S-}#T#`-}#`#a!*r#a#o-}~!*wW_~!Q![-}!c!}-}#R#S-}#T#X-}#X#YJ{#Y#g-}#g#h!%T#h#o-}~!+fRf~!O!P'b![!]!+o#o#p!+w~!+tPf~![!]'b~!+|Pn~yz!,P~!,SVz{!,i#T#U!,i#V#W!,i#W#X!,i#a#b!,i#b#c!,n#j#k!,i~!,nOn~~!,sOR~~!,xRh~!O!P'b![!]'b#q#r!-R~!-WOo~~!-]Qh~!O!P'b![!]'b",
  tokenizers: [2, new LocalTokenGroup("|~RQYZX#q#rl~^PW~#q#ra~dP#q#rg~lOU~~oP#q#rr~wOT~UTWT~", 39, 4), new LocalTokenGroup("#U~RPYZU~XQxy_#q#r!x~bPqre~hP!}#Ok~nP#q#rq~tP#P#Qw~zP#p#q}~!QP#q#r!T~!WPqr!Z~!^P!}#O!a~!dP#q#r!g~!jP#P#Q!m~!pPyz!s~!xOY~~!{P#q#r#O~#TOZ~~", 97, 9)],
  topRules: { "Program": [0, 12] },
  tokenPrec: 244
});

const JLanguage = LRLanguage.define({
  parser: parser.configure({
    props: [
      styleTags({
        NounSinglelineDefContent: tags.string,
        NounMultilineDefContent: tags.string,
        NounMultilineDefNotEnd: tags.string,
        Number: tags.number,
        String: tags.string,
        Noun: tags.string,
        Verb1: tags.operatorKeyword,
        Verb2: tags.operatorKeyword,
        Adverb1: tags.updateOperator,
        Adverb2: tags.updateOperator,
        Conjunction1: tags.modifier,
        Conjunction2: tags.modifier,
        Conjunction3: tags.modifier,
        Control: tags.controlKeyword,
        ControlBegin: tags.controlKeyword,
        ControlEnd: tags.controlKeyword,
        Comment: tags.lineComment,
        DirectUnknownDefBegin: tags.controlKeyword,
        DirectDefEnd: tags.controlKeyword,
        NounDefBegin: tags.controlKeyword,
        NounSinglelineDefEnd: tags.controlKeyword,
        NounDoublelineDefEnd: tags.controlKeyword,
        NounMultilineDefEnd: tags.controlKeyword
      })
    ]
  }),
  languageData: {
    commentTokens: { line: "NB." },
    closeBrackets: { brackets: ["(", "'"] }
  }
});

function J() {
  return new LanguageSupport(JLanguage);
}

const lbg0 = "#fbf3db",
  lbg1 = "#ece3cc",
  lbg2 = "#d5cdb6",
  ldim0 = "#909995",
  lfg0 = "#53676d",
  lfg1 = "#3a4d53"

const lightSelenizedTheme = EditorView.theme({
  "&": {
    color: lfg1,
    backgroundColor: lbg1,
    zIndex: "0"
  },

  ".cm-content": {
    caretColor: lfg0
  },

  ".cm-cursor, .cm-dropCursor": { borderLeftColor: "#53676d", borderLeftWidth: "3px", marginLeft: "-1px" },
  "&.cm-focused > .cm-scroller > .cm-selectionLayer .cm-selectionBackground, .cm-selectionBackground, .cm-content ::selection": { backgroundColor: "#ebc13d90" },

  ".cm-panels": { backgroundColor: lbg2, color: lfg0 },

  ".cm-searchMatch": {
    backgroundColor: "#72a1ff59",
    outline: "1px solid #457dff",
    borderRadius: "1px"
  },
  ".cm-searchMatch.cm-searchMatch-selected": {
    backgroundColor: "#6199ff2f"
  },

  ".cm-activeLine": { backgroundColor: "#fbf3db70" },
  ".cm-selectionMatch": {
    backgroundColor: "#ebc13d",
    outline: "1px solid #ebc13d20",
    borderRadius: "1px"
  },

  "&.cm-focused .cm-matchingBracket": {
    backgroundColor: "#428b0020",
    outline: "1px solid #428b0050",
    borderRadius: "1px"
  },

  "&.cm-focused .cm-nonmatchingBracket": {
    backgroundColor: "#cc172920",
    outline: "1px solid #cc172950",
    borderRadius: "1px"
  },

  ".cm-gutters": {
    backgroundColor: lbg2,
    color: ldim0,
    border: "none"
  },

  ".cm-activeLineGutter": {
    backgroundColor: lbg0
  }
}, { dark: false });

const lightSelenizedHighlight = HighlightStyle.define([
  { tag: tags.number, color: "#ca4898" },
  { tag: tags.string, color: "#ca4898" },
  { tag: tags.lineComment, color: "#909995", fontStyle: "italic" },
  { tag: tags.operatorKeyword, color: "#8762c6" }, // Verb.
  { tag: tags.updateOperator, color: "#009c8f" }, // Adverb.
  { tag: tags.modifier, color: "#489100" }, // Conjuntion.
  { tag: tags.controlKeyword, color: "#bc5819" }, // Control.
]);

function noIndent(_context, _pos) {
  return null;
}

function saveText() {
  ta.value = cm6.state.doc.toString(); // ta is global variable from jijs.js.
  jscdo('save'); // Call ev_save_click in jijs.ijs.
  return true;
}

function runText() {
  ta.value = cm6.state.doc.toString();
  jscdo('runw');
  return true;
}

function changeLineNumbers() {
  lineNumbersState = !lineNumbersState;

  if (lineNumbersState) {
    cm6.dispatch({
      effects: lineNumbersCompartment.reconfigure(lineNumbers())
    });
  } else {
    cm6.dispatch({
      effects: lineNumbersCompartment.reconfigure([])
    });
  }
}

function changeReadOnly() {
  if (cm6.state.readOnly) {
    cm6.dispatch({
      effects: readOnlyCompartment.reconfigure(EditorState.readOnly.of(false))
    });
  } else {
    cm6.dispatch({
      effects: readOnlyCompartment.reconfigure(EditorState.readOnly.of(true))
    });
  }
}

function createEditor(text, parent) {
  return new EditorView({
    doc: text,
    extensions: [
      lineNumbersCompartment.of(lineNumbers()),
      readOnlyCompartment.of(EditorState.readOnly.of(text.length !== 0)),
      highlightActiveLineGutter(),
      history(),
      drawSelection(),
      EditorState.allowMultipleSelections.of(true),
      EditorView.lineWrapping,
      indentService.of(noIndent),
      bracketMatching({ brackets: "()" }),
      closeBrackets(),
      rectangularSelection(),
      crosshairCursor(),
      dropCursor(),
      search(),
      highlightActiveLine(),
      highlightSelectionMatches(),
      keymap.of([
        { key: "Ctrl-s", mac: "Cmd-s", run: saveText },
        { key: "Ctrl-r", run: runText }, // "Cmd-r" reloads page in Safari, so Ctrl-r for MacOS as well.
        ...closeBracketsKeymap,
        ...historyKeymap,
        ...searchKeymap,
        ...defaultKeymap,
      ]),
      J(),
      syntaxHighlighting(lightSelenizedHighlight),
      lightSelenizedTheme,
      EditorView.updateListener.of((update) => {
        if (update.docChanged) {
          setdirty(); // setdirty is global function from jijs.js
        }
      })
    ],
    parent: parent
  });
}

// This is a module and normally I would do an export of below functions,
// but then I would have to do an import in the jijs.js, but it is not a module, so I can't do it.
// So instead of export I assign the needed functions to global window. 
// This is a way to mix module code (this file) with non-module code (JHS).

window.cm6_creat = (text, parent) => { cm6 = createEditor(text, parent); }
window.cm6_undo = () => { undo(cm6); }
window.cm6_redo = () => { redo(cm6); }
window.cm6_findAll = () => { selectMatches(cm6); }
window.cm6_findNext = () => { findNext(cm6); }
window.cm6_findPrev = () => { findPrevious(cm6); }
window.cm6_replaceNext = () => { replaceNext(cm6); }
window.cm6_replaceAll = () => { replaceAll(cm6); }
window.cm6_changeLineNumbers = changeLineNumbers;
window.cm6_changeReadOnly = changeReadOnly;
