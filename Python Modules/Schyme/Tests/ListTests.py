import sys
sys.path.append("../..")
from Schyme import Schyme
from Types import SchemePair
from SchymeExceptions import *

interpreter = Schyme(toSchemestr=False)

assert interpreter.eval("(member 1 '(1 2 3 4))") == [1, 2, 3, 4]
assert interpreter.eval("(member 2 '(1 2 3 4))") == [2, 3, 4]
assert interpreter.eval("(member 3 '(1 2 3 4))") == [3, 4]
assert interpreter.eval("(member 4 '(1 2 3 4))") == [4]
assert interpreter.eval("(member 5 '(1 2 3 4))") == False

assert interpreter.eval("(memq 1 '(1 2 3 4))") == [1, 2, 3, 4]
assert interpreter.eval("(memq 2 '(1 2 3 4))") == [2, 3, 4]
assert interpreter.eval("(memq 3 '(1 2 3 4))") == [3, 4]
assert interpreter.eval("(memq 4 '(1 2 3 4))") == [4]
assert interpreter.eval("(memq 5 '(1 2 3 4))") == False

assert interpreter.eval("(list-head '(1 2 3 4) 4)") == [1, 2, 3, 4]
assert interpreter.eval("(list-head '(1 2 3 4) 3)") == [1, 2, 3]
assert interpreter.eval("(list-head '(1 2 3 4) 2)") == [1, 2]
assert interpreter.eval("(list-head '(1 2 3 4) 1)") == [1]
assert interpreter.eval("(list-head '(1 2 3 4) 0)") == []
try: interpreter.eval("(list-head '(1 2 3 4) 5)"); assert False
except SyntaxError: pass
except: assert False

try: assert interpreter.eval("(list-head '(1 2 3 4) -1)"); assert False
except SyntaxError: pass
except: assert False

assert interpreter.eval("(list-tail '(1 2 3 4) 4)") == []
assert interpreter.eval("(list-tail '(1 2 3 4) 3)") == [4]
assert interpreter.eval("(list-tail '(1 2 3 4) 2)") == [3, 4]
assert interpreter.eval("(list-tail '(1 2 3 4) 1)") == [2, 3, 4]
assert interpreter.eval("(list-tail '(1 2 3 4) 0)") == [1, 2, 3, 4]

try: interpreter.eval("(list-tail '(1 2 3 4) 5)"); assert False
except SyntaxError: pass
except: assert False

try: assert interpreter.eval("(list-tail '(1 2 3 4) -1)"); assert False
except SyntaxError: pass
except: assert False

interpreter.eval("(define make-stream (lambda (seed next) (let ([produce (lambda (current) (cons current(lambda () (produce (next current)))))])(produce seed)))) (define stream-of-even-natural-numbers (make-stream 0 (lambda (n) (+ n 2))))")
carstream = interpreter.eval("(car (cons 1 stream-of-even-natural-numbers))")
assert carstream == 1
cadrstream = interpreter.eval("(car (cdr (cons 1 stream-of-even-natural-numbers)))")
assert cadrstream == 0
cddrstream = interpreter.eval("(cdr (cdr (cons 1 stream-of-even-natural-numbers)))")
assert callable(cddrstream)

carstream = interpreter.eval("(car (cons stream-of-even-natural-numbers 1))")
assert carstream == SchemePair(0, carstream.cdr) and callable(carstream.cdr)
cdrstream = interpreter.eval("(cdr (cons stream-of-even-natural-numbers 1))")
assert cdrstream == 1

interpreter.eval("(define x (cons stream-of-even-natural-numbers stream-of-even-natural-numbers))")
carx = interpreter.eval("(car x)") #expected (0 . procedure)
assert carx.car == 0 and callable(carx.cdr)
cdrx = interpreter.eval("(cdr x)") #expected (0 . procedure)
assert cdrx.car == 0 and callable(cdrx.cdr)

assert interpreter.eval("(null? (cdr (cons 1 '())))") == True
assert interpreter.eval("(null? (cons 1 '()))") == False
assert interpreter.eval("(null? '())") == True
assert interpreter.eval("(null? '(1 2 3))") == False

print "Passed List Tests"