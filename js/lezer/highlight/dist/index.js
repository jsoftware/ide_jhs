import{NodeProp}from"../../common/dist/index.js";let nextTagID=0;class Tag{constructor(t,e,a,r){this.name=t,this.set=e,this.base=a,this.modified=r,this.id=nextTagID++}toString(){let{name:t}=this;for(let e of this.modified)e.name&&(t=`${e.name}(${t})`);return t}static define(t,e){let a="string"==typeof t?t:"?";if(t instanceof Tag&&(e=t),null==e?void 0:e.base)throw new Error("Can not derive from a modified tag");let r=new Tag(a,[],null,[]);if(r.set.push(r),e)for(let t of e.set)r.set.push(t);return r}static defineModifier(t){let e=new Modifier(t);return t=>t.modified.indexOf(e)>-1?t:Modifier.get(t.base||t,t.modified.concat(e).sort(((t,e)=>t.id-e.id)))}}let nextModifierID=0;class Modifier{constructor(t){this.name=t,this.instances=[],this.id=nextModifierID++}static get(t,e){if(!e.length)return t;let a=e[0].instances.find((a=>a.base==t&&sameArray(e,a.modified)));if(a)return a;let r=[],i=new Tag(t.name,r,t,e);for(let t of e)t.instances.push(i);let o=powerSet(e);for(let e of t.set)if(!e.modified.length)for(let t of o)r.push(Modifier.get(e,t));return i}}function sameArray(t,e){return t.length==e.length&&t.every(((t,a)=>t==e[a]))}function powerSet(t){let e=[[]];for(let a=0;a<t.length;a++)for(let r=0,i=e.length;r<i;r++)e.push(e[r].concat(t[a]));return e.sort(((t,e)=>e.length-t.length))}function styleTags(t){let e=Object.create(null);for(let a in t){let r=t[a];Array.isArray(r)||(r=[r]);for(let t of a.split(" "))if(t){let a=[],i=2,o=t;for(let e=0;;){if("..."==o&&e>0&&e+3==t.length){i=1;break}let r=/^"(?:[^"\\]|\\.)*?"|[^\/!]+/.exec(o);if(!r)throw new RangeError("Invalid path: "+t);if(a.push("*"==r[0]?"":'"'==r[0][0]?JSON.parse(r[0]):r[0]),e+=r[0].length,e==t.length)break;let n=t[e++];if(e==t.length&&"!"==n){i=0;break}if("/"!=n)throw new RangeError("Invalid path: "+t);o=t.slice(e)}let n=a.length-1,s=a[n];if(!s)throw new RangeError("Invalid path: "+t);let l=new Rule(r,i,n>0?a.slice(0,n):null);e[s]=l.sort(e[s])}}return ruleNodeProp.add(e)}const ruleNodeProp=new NodeProp;class Rule{constructor(t,e,a,r){this.tags=t,this.mode=e,this.context=a,this.next=r}get opaque(){return 0==this.mode}get inherit(){return 1==this.mode}sort(t){return!t||t.depth<this.depth?(this.next=t,this):(t.next=this.sort(t.next),t)}get depth(){return this.context?this.context.length:0}}function tagHighlighter(t,e){let a=Object.create(null);for(let e of t)if(Array.isArray(e.tag))for(let t of e.tag)a[t.id]=e.class;else a[e.tag.id]=e.class;let{scope:r,all:i=null}=e||{};return{style:t=>{let e=i;for(let r of t)for(let t of r.set){let r=a[t.id];if(r){e=e?e+" "+r:r;break}}return e},scope:r}}function highlightTags(t,e){let a=null;for(let r of t){let t=r.style(e);t&&(a=a?a+" "+t:t)}return a}function highlightTree(t,e,a,r=0,i=t.length){let o=new HighlightBuilder(r,Array.isArray(e)?e:[e],a);o.highlightRange(t.cursor(),r,i,"",o.highlighters),o.flush(i)}function highlightCode(t,e,a,r,i,o=0,n=t.length){let s=o;function l(e,a){if(!(e<=s)){for(let o=t.slice(s,e),n=0;;){let t=o.indexOf("\n",n),e=t<0?o.length:t;if(e>n&&r(o.slice(n,e),a),t<0)break;i(),n=t+1}s=e}}highlightTree(e,a,((t,e,a)=>{l(t,""),l(e,a)}),o,n),l(n,"")}Rule.empty=new Rule([],2,null);class HighlightBuilder{constructor(t,e,a){this.at=t,this.highlighters=e,this.span=a,this.class=""}startSpan(t,e){e!=this.class&&(this.flush(t),t>this.at&&(this.at=t),this.class=e)}flush(t){t>this.at&&this.class&&this.span(this.at,t,this.class)}highlightRange(t,e,a,r,i){let{type:o,from:n,to:s}=t;if(n>=a||s<=e)return;o.isTop&&(i=this.highlighters.filter((t=>!t.scope||t.scope(o))));let l=r,g=getStyleTags(t)||Rule.empty,h=highlightTags(i,g.tags);if(h&&(l&&(l+=" "),l+=h,1==g.mode&&(r+=(r?" ":"")+h)),this.startSpan(Math.max(e,n),l),g.opaque)return;let c=t.tree&&t.tree.prop(NodeProp.mounted);if(c&&c.overlay){let o=t.node.enter(c.overlay[0].from+n,1),g=this.highlighters.filter((t=>!t.scope||t.scope(c.tree.type))),h=t.firstChild();for(let d=0,m=n;;d++){let f=d<c.overlay.length?c.overlay[d]:null,p=f?f.from+n:s,u=Math.max(e,m),k=Math.min(a,p);if(u<k&&h)for(;t.from<k&&(this.highlightRange(t,u,k,r,i),this.startSpan(Math.min(k,t.to),l),!(t.to>=p)&&t.nextSibling()););if(!f||p>a)break;m=f.to+n,m>e&&(this.highlightRange(o.cursor(),Math.max(e,f.from+n),Math.min(a,m),"",g),this.startSpan(Math.min(a,m),l))}h&&t.parent()}else if(t.firstChild()){c&&(r="");do{if(!(t.to<=e)){if(t.from>=a)break;this.highlightRange(t,e,a,r,i),this.startSpan(Math.min(a,t.to),l)}}while(t.nextSibling());t.parent()}}}function getStyleTags(t){let e=t.type.prop(ruleNodeProp);for(;e&&e.context&&!t.matchContext(e.context);)e=e.next;return e||null}const t=Tag.define,comment=t(),name=t(),typeName=t(name),propertyName=t(name),literal=t(),string=t(literal),number=t(literal),content=t(),heading=t(content),keyword=t(),operator=t(),punctuation=t(),bracket=t(punctuation),meta=t(),tags={comment:comment,lineComment:t(comment),blockComment:t(comment),docComment:t(comment),name:name,variableName:t(name),typeName:typeName,tagName:t(typeName),propertyName:propertyName,attributeName:t(propertyName),className:t(name),labelName:t(name),namespace:t(name),macroName:t(name),literal:literal,string:string,docString:t(string),character:t(string),attributeValue:t(string),number:number,integer:t(number),float:t(number),bool:t(literal),regexp:t(literal),escape:t(literal),color:t(literal),url:t(literal),keyword:keyword,self:t(keyword),null:t(keyword),atom:t(keyword),unit:t(keyword),modifier:t(keyword),operatorKeyword:t(keyword),controlKeyword:t(keyword),definitionKeyword:t(keyword),moduleKeyword:t(keyword),operator:operator,derefOperator:t(operator),arithmeticOperator:t(operator),logicOperator:t(operator),bitwiseOperator:t(operator),compareOperator:t(operator),updateOperator:t(operator),definitionOperator:t(operator),typeOperator:t(operator),controlOperator:t(operator),punctuation:punctuation,separator:t(punctuation),bracket:bracket,angleBracket:t(bracket),squareBracket:t(bracket),paren:t(bracket),brace:t(bracket),content:content,heading:heading,heading1:t(heading),heading2:t(heading),heading3:t(heading),heading4:t(heading),heading5:t(heading),heading6:t(heading),contentSeparator:t(content),list:t(content),quote:t(content),emphasis:t(content),strong:t(content),link:t(content),monospace:t(content),strikethrough:t(content),inserted:t(),deleted:t(),changed:t(),invalid:t(),meta:meta,documentMeta:t(meta),annotation:t(meta),processingInstruction:t(meta),definition:Tag.defineModifier("definition"),constant:Tag.defineModifier("constant"),function:Tag.defineModifier("function"),standard:Tag.defineModifier("standard"),local:Tag.defineModifier("local"),special:Tag.defineModifier("special")};for(let t in tags){let e=tags[t];e instanceof Tag&&(e.name=t)}const classHighlighter=tagHighlighter([{tag:tags.link,class:"tok-link"},{tag:tags.heading,class:"tok-heading"},{tag:tags.emphasis,class:"tok-emphasis"},{tag:tags.strong,class:"tok-strong"},{tag:tags.keyword,class:"tok-keyword"},{tag:tags.atom,class:"tok-atom"},{tag:tags.bool,class:"tok-bool"},{tag:tags.url,class:"tok-url"},{tag:tags.labelName,class:"tok-labelName"},{tag:tags.inserted,class:"tok-inserted"},{tag:tags.deleted,class:"tok-deleted"},{tag:tags.literal,class:"tok-literal"},{tag:tags.string,class:"tok-string"},{tag:tags.number,class:"tok-number"},{tag:[tags.regexp,tags.escape,tags.special(tags.string)],class:"tok-string2"},{tag:tags.variableName,class:"tok-variableName"},{tag:tags.local(tags.variableName),class:"tok-variableName tok-local"},{tag:tags.definition(tags.variableName),class:"tok-variableName tok-definition"},{tag:tags.special(tags.variableName),class:"tok-variableName2"},{tag:tags.definition(tags.propertyName),class:"tok-propertyName tok-definition"},{tag:tags.typeName,class:"tok-typeName"},{tag:tags.namespace,class:"tok-namespace"},{tag:tags.className,class:"tok-className"},{tag:tags.macroName,class:"tok-macroName"},{tag:tags.propertyName,class:"tok-propertyName"},{tag:tags.operator,class:"tok-operator"},{tag:tags.comment,class:"tok-comment"},{tag:tags.meta,class:"tok-meta"},{tag:tags.invalid,class:"tok-invalid"},{tag:tags.punctuation,class:"tok-punctuation"}]);export{Tag,classHighlighter,getStyleTags,highlightCode,highlightTree,styleTags,tagHighlighter,tags};