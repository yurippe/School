import sys
sys.path.append("..")
from Schyme import Schyme

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
except: pass
try: assert interpreter.eval("(list-head '(1 2 3 4) -1)"); assert False
except: pass

assert interpreter.eval("(list-tail '(1 2 3 4) 4)") == []
assert interpreter.eval("(list-tail '(1 2 3 4) 3)") == [4]
assert interpreter.eval("(list-tail '(1 2 3 4) 2)") == [3, 4]
assert interpreter.eval("(list-tail '(1 2 3 4) 1)") == [2, 3, 4]
assert interpreter.eval("(list-tail '(1 2 3 4) 0)") == [1, 2, 3, 4]
try: interpreter.eval("(list-tail '(1 2 3 4) 5)"); assert False
except: pass
try: assert interpreter.eval("(list-tail '(1 2 3 4) -1)"); assert False
except: pass

interpreter.eval("(define make-stream (lambda (seed next) (let ([produce (lambda (current) (cons current(lambda () (produce (next current)))))])(produce seed)))) (define stream-of-even-natural-numbers (make-stream 0 (lambda (n) (+ n 2))))")
stream = interpreter.eval("(cons 1 stream-of-even-natural-numbers)")
assert stream[0] == [1, 0] and callable(stream[1])
stream = interpreter.eval("(cons stream-of-even-natural-numbers 1)")
assert stream[0][0] == 0 and stream[1] == 1 and callable(stream[0][1])

interpreter.eval("(define x (cons stream-of-even-natural-numbers stream-of-even-natural-numbers))")
carx = interpreter.eval("(car x)") #expected (0 . procedure)
print carx

print "Passed List Tests"