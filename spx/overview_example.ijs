NB. crsum ?2 3$10
NB. add row and col sums to matrix
crsum=: {{
t=. y,+/y
t,.+/"1 t
}}

NB. square root of sum over squares of arg
hypot=: {{ %: +/ *: y }}