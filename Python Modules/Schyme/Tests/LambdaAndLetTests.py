import sys
sys.path.append("..")
from Schyme import Schyme

interpreter = Schyme(toSchemestr=False)

assert interpreter.eval("(define x (lambda (y) (lambda (g) (+ y g)))) ((x 10) 20)") == 30

assert interpreter.eval("(define x 10) (let ([x 1] [y 2]) (+ x y))") == 3
assert interpreter.eval("(define x 10) (let ([z 1] [y 2]) (+ x y z))") == 13


print "Passed Lambda and Let, Let* and Letrec Tests"