0 :0
6 minutes with this lab covers J programming mechanics with the JHS interface:
• repl (read-eval-print-loop)
• inputs
• menu commands
• menu shortcuts
• scripts
• line recall (less typing!)
• how to dig in and learn J

J coding is covered by other labs and resources referenced at the end of this lab
)

0 : 0
lab advance:
 keyboard: ctrl+.
 touchscreen: right green button
gives J the next line from the lab file
J evaluates the input and displays the result

do a lab advance now
)

2+4 NB. comment (Nota Bene)
i. 5 NB. first 5 ints
+/ i. 5 NB.sum over first 5 ints
*: i. 5 NB. square first 5 ints
load 'plot' NB. load plot package
plot *: i. 5
plot sin 0.1 * i.60

0 : 0
next advance simulates your typing and pressing enter
)

NB.spxrun:jjs_jhs_ 5000 animate_jsp_ '   |.''.| htiw atad esrever'''

0 : 0
time to try your first input
3 blanks is prompt for input and result is on the left
click the input area (box below)
and type a line (e.g. +/ 23 24) and then press enter
)

0 : 0
this pattern of
 read input
  evaluate 
   print
    loop
is called a repl (read-eval-print-loop)

this page (window) is a J repl
)

a=: 2 6$100   NB. a is 2 by 6 array of 100
b=: ?a        NB. random values from a
b             NB. display b
c=: b,+/b     NB. add row of sum over cols
c
plot c 

0 : 0
lab is interactive!
instead of doing a lab advance
click the input box below
and run your own input
)

0 : 0
click ☰  (page upper right corner)
click outside menu to dismiss it
)

0 : 0
if you are a J server guest
you can learn more:

☰ then help then guest rules
☰.help.guest rules
☰.help.guest files
)

0 : 0
☰.help.mobile - mobile (touchscreen) info
)

10?10 NB. line for testing recall

0 : 0
want to run a line again?

click the line above with 10?10
press return to recall it to the input area
press return again to run the line
)

0 : 0
recall previous inputs with:
 keyboard: ctrl+shift+↑
 keyboard: ctrl+shift+↓
or
 touchscreen: right blue button
 touchscreen: right red button
  
try it now to recall the 10?10 line
and press enter to run it again
)

0 : 0
J scripts (file names ending in .ijs) contain J code
)

fin=: '~addons/ide/jhs/spx/overview_example.ijs'
jpath fin  NB. ~addons expands to J addons folder
data=: fread fin NB. file read
data       NB. display data
fout=: '~temp/ovtour.ijs'
jpath fout NB. ~temp expands to J temp folder file
data fwrite fout NB. data written to file
load fout  NB. load script to define crsum
mat=: ?3 4$10
mat
crsum mat NB. crsum adds row and col sums

0 : 0
the display of crsum is its defn
script used a new form with {{ ... }}
display uses an old form with 3 : 0 up to the )
)
crsum

0 : 0
name=: ... NB. global assignment
name=. ... NB. local assigment - only for current definition

the crsum sentence:
t=. y,+/y
assigns the local name t 
)

t=: 123
crsum mat
t NB. global t is not changed by crsum local use

erase'crsum'
crsum mat NB. error as crsum not defined
load fout NB. load script again to define crsum
crsum mat
crsum 'asdf' NB. text causes an error
plot crsum mat

names'' NB. list of defined
a NB. display a

0 : 0
next step opens ovtour.ijs in an edit page

after ovtour.ijs shows, switch back to jterm
)

NB.spxaction:browser may ask for pop-up permission in next lab advance
edit fout NB. open file in edit page

0 : 0
2 j pages open: jterm and ovtour.ijs
switching between pages can be confusing

big screen: dragging ovtour.ijs to be
visible at the same time as jterm helps
)

0 : 0
ovtour.ijs also defines verb hypot
)

hypot 3 4

0 : 0
you can also show latex or html
)
jhlatex_jhs_ '\sqrt{y_0^2 + y_1^2}'
jhtml'<div><font style="color:red;font-size:2rem;">square root of the sum of the squared sides</font></div>'

0 : 0
edit page has context sensitive help
that opens the relevant wiki page

after switching back to edit page

click just before the %: in the hypot defn
☰.context sensitive

iOS considers opening a wiki page a pop-up
switch to jterm and allow the pop-up
)

0 : 0
try the following in the edit page

☰.readonly - allow changes
at the end add new line line:
d=: +/20 2
☰.load - save and load the script

switch to jterm page
)
d

0 : 0
wiki quick reference:
☰.help.wiki
)

0 : 0
click line: jhswiki'voc'
press return to recall and return to run
)

0 : 0
NuVoc wiki page
scan down left col for %
and scan right for the %: col
click Square Root
)

0 : 0
host services are accessed by:
 group !: type

group 6 is for time  and type 3 is for sleep
)

sleep=: 6 !: 3
NB. next step sleeps for 3 seconds
sleep 3 NB. sleep for 3 seconds

0 : 0
what if you asked for a long sleep by mistake?

you need to signal break to get back control
)

0 : 0
click ☰
note: break item has shortcut esc-c

esc used as browsers appropriate most ctrl shortcuts
esc key is not held down! (unlike shift or ctrl)
)

0 : 0
press esc key and then c key (or click ☰.break)
to signal break
nothing is running so no effect
)

0 : 0
a typo or coding error can run a looong time
signal break to take back control
)

0 : 0
esc-c or ☰.break signals a break

if J is running locally this will indicate you should
 do ctrl+c in the window that started your local server
 (window with the text: J HTTP Server - init OK)

a simple long running sentence is: sleep 20 seconds

it takes 2 breaks to break a sleep
 but only one to break a loop
 
run sentence in the box below:
   sleep 20 NB. 2 breaks to end the delay
)

0 : 0
JHS is a browser interface to J

A full J installation includes:
  Jqt - a complete IDE built in Qt
  jconsole - terminal repl interface
)

0 : 0
close J pages with ☰.close
quit  J session with ☰.quit

preferable to browser x close button
as it gives J more control
)

0 : 0
this is the end of the overview

explore jterm menu and run labs and tours

☰.entry.lab
recall and run line for core
then recall and run line for 'A J Introduction'

☰.entry.tour
recall and run line for plot tour
)
