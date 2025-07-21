import time
import array

def timex(p):
 a= time.perf_counter()
 p()
 a= time.perf_counter()
 p()
 b= time.perf_counter()
 f = open('results.txt', 'a')
 f.write(p.__name__+'_py3=: '+"{:.6f}".format(b-a)+'\n')
 f.close()

def wh():
 a= int(1e7)
 while a>0 :  
    a-= 1

def ex():
 r= array.array('l')
 c= int(0)
 while c<1000:
  r.append(ec(c))
  c+= 1
 return r

def ec(y):
 c= int(0)
 while y>1:
  c+= 1
  if y % 2 != 0:
     y= 1+3*y
  else:
     y= y // 2
 return c    

timex(wh)
timex(ex)

 

