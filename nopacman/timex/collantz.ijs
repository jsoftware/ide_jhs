bignoun =: 0.5 + i. 5e7  NB. Large float array - too big to make multiple copies
collatzcount =: {{ c =. 0 while. y > 1 do. c =. >: c if. 2|y do. y =. 1 + 3*y else. y =. <. -: y end. end. c{bignoun }}"0
NB. Run Collatz, fetch from shared array
collatzargs =: {{ 1023 (^ m. x) y }}"0
collatzcountx=: {{ +/ ; (>: i. 1000)&(collatzcount@collatzargs t. '')"0 y }}

collatzcount =: {{
c =. 0
while. y > 1 do. c =. >: c if. 2|y do. y =. 1 + 3*y else. y =. <. -: y end. end.
c{bignoun 
}}"0


f=: {{
+/ ; (>: i. 1000)&(collatzcount@collatzargs t. '')"0 y
}}

ec =: 3 : 0 "0
c =. 0
while. y > 1 do.
 c =. >: c
 if. 2|y do.
  y =. 1 + 3*y 
 else. y =. <. -: y
 end.
end.
c
)
