import sys
sys.path.append("../..")
from Schyme import Schyme

interpreter = Schyme(toSchemestr=False)

assert interpreter.eval("(and #t #t #t)") == True
assert interpreter.eval("(and #f #t #t)") == False
assert interpreter.eval("(and #t #f #t)") == False
assert interpreter.eval("(and #t #t #f)") == False
assert interpreter.eval("(and #f #f #f)") == False

assert interpreter.eval("(or #t #t #t)") == True
assert interpreter.eval("(or #f #t #t)") == True
assert interpreter.eval("(or #t #f #t)") == True
assert interpreter.eval("(or #t #t #f)") == True
assert interpreter.eval("(or #f #f #f)") == False

interpreter.eval("(define test-if (lambda (x y) (if (equal? x y) (* x y) (+ x y))))")
interpreter.eval("(define literal-test (lambda (v) (if (null? v) '(1 3 3 7) '())))")

assert interpreter.eval("(test-if 2 5)") == 7
assert interpreter.eval("(test-if 5 5)") == 25
assert interpreter.eval("(test-if 5 2)") == 7

assert interpreter.eval("(literal-test '())").toPythonList() == [1,3,3,7]
assert interpreter.eval("(literal-test '(1 3 3 7))").toPythonList() == []

print("Passed Conditionals Tests")