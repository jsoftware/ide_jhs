NB. TITLE:  'A Taste of J (1)'
0 : 0
You can use J as a calculator - just type sentences into the window and press Enter.
J is ready for input when the message in the status bar at the foot of the screen displays Ready.
Typically, the cursor is indented 3 spaces to distinguish user entries from the response of the computer, which are shown aligned to the left.
For example, add 5 to the three numbers 10 20 30:
)
5 + 10 20 30
0 : 0
You are encouraged to experiment when going through labs.
You can type in your own sentences, or re-enter sentences by moving the cursor up to the line, pressing Enter, then making any modifications.
Try this now with the sentence 5 + 10 20 30 shown above.
)
0 : 0
The standard mathematical functions are + - * % ^ ^., i.e. plus, minus, times, divide, power and log:
)
5 + 10 20 30
5 - 10 20 30
5 * 10 20 30
5 % 10 20 30
5 ^ 10 20 30
5 ^. 10 20 30
0 : 0
Note that the symbol for log "^." has two characters. In general, J functions are written with either a single character as in power "^", or with two characters, where the second character is either a period "." or colon ":".
For example, *: squares its argument:
)
*: 10 20 30
0 : 0
Use =: to assign names.
No result is shown if a sentence is an assignment; otherwise the result is displayed.
Note that character strings are entered using quotes:
)
a=: 5
b=: 10 20 30
log=: ^.
plus=: +
square=: *:
sum=: +/
text=: 'hello world'
0 : 0
We can now use the assigned names:
)
a plus b
square b
sum b
c=: a plus b
sum c
text
0 : 0
J excels at manipulating data. Let us try some examples.
Define a character string t as follows:
)
t=: 'earl of chatham'
t
0 : 0
Count of t, i.e. number of characters in the string:
)
#t
0 : 0
Nub of t, i.e. unique characters:
)
~. t
0 : 0
Count of nub of t:
)
# ~. t
0 : 0
Sort t in ascending order. "sort" is a predefined utility.
The sort order is the standard ASCII alphabet, where blanks are sorted before other characters:
)
sort t
0 : 0
Reverse t:
)
|. t
0 : 0
Duplicate each letter:
)
2 # t
0 : 0
Make 3 copies of t:
)
3 # ,: t
0 : 0
Chop t into words.
Note J puts each word in a box - when something is in a box it is treated as a single item, even though it may contain several numbers or characters:
)
;: t
0 : 0
Sort words in t:
)
sort ;: t
0 : 0
The utility "each" applies a function to each boxed item. For example, count the length of each word:
)
# each ;: t
0 : 0
The above examples apply equally well to numbers.
Other facilities are defined just for numbers. For example, the integer function (i.) generates numbers:
)
i.10           NB. first 10 numbers
i.4 3          NB. first 12 numbers in a 4 by 3 table
i.3 4 5        NB. first 60 numbers in a 3 by 4 by 5 table
0 : 0
The function +/ sums its argument. It is made up of + (add) with / (insert), meaning insert + between each item of the argument.
So  +/ 10 20 30  means:  10 + 20 + 30.
Similarly */ is "multiply insert", i.e. multiply all elements together.
)
+/ 10 20 30
*/ 10 20 30
0 : 0
Add up the first 10,000 positive integers:
)
+/i.10001  NB. 10001 - since J starts counting at 0
0 : 0
Add up i.3 4 5
)
+/i.3 4 5
0 : 0
"power insert" of 10 20 30 is a big number! It exceeds the representation used by the machine, so J returns infinity.
Can you figure out the other examples below?
(Try 3 ^ 4, then take 2 to the power of this number.)
The 'x' used here means "extended" and instructs J to use extended precision in performing the calculations, instead of converting to floating point.
)
^/ 10 20 30
^/ 2 3 4
^/ 2 3 4x
0 : 0
Note the "e" notation used in 2.41785e24, meaning:
  2.41785 * 10^24
J has other number notations that use letters:
)
3b102     NB. base (102 in base 3)
3r5       NB. ratio (3 % 5)
3j5       NB. complex number
3p5       NB. Pi (3 * Pi ^ 5)
3x5       NB. Exponentional (3 * 2.71828... ^ 5)
0 : 0
Examples:
)
1p1 2p1     NB. Pi, 2 * Pi
%: -i.6     NB. square roots of minus 0 to minus 5
0 : 0
The function ? generates random numbers.
For example, generate 20 random numbers in the range 0-99:
)
? 20#100
? 20#100
0 : 0
The function "load" reads in definitions from "script" files.
For example, read in the stats functions:
)
load 'stats'
0 : 0
Example:
)
dstat ? 20#100
0 : 0
normalrand generates random numbers in a normal distribution with mean 0 and standard deviation 1:
)
normalrand 6
dstat normalrand 10000
0 : 0
Read in the trig and plot functions:
)
load 'trig plot'
0 : 0
Try generating sines, here the arguments are in radians:
)
sin i.6
sin i.3 4
0 : 0
You can plot numbers directly. The next section plots the sin of i.3 4. The lines are jagged because each point is joined by a straight line and there are very few points.
)
0 : 0
)
plot sin i.3 4
0 : 0
The next two sections plot sin 0.2 * i.30 30, first as a series of lines, then as a surface. This time there are enough data points to show smooth lines.
)
0 : 0
)
plot sin 0.2 * i.30 30
0 : 0
)
'surface' plot sin 0.2 * i.30 30
