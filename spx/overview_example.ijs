NB. switch back to jterm page to continue lab

NB. example script used in overview tour

NB. define verb crsum to add row and col sums to matrix
NB. crsum ?2 3$10
crsum=: {{
t=. y,+/y
t,.+/"1 t
}}

NB. square root of sum over squares of arg
hypot=: {{ %: +/ *: y }}