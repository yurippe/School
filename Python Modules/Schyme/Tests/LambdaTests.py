import sys
sys.path.append("..")
from Schyme import Schyme

interpreter = Schyme(toSchemestr=False)

assert interpreter.eval("(define x (lambda (y) (lambda (g) (+ y g)))) ((x 10) 20)") == 30

print "Passed Lambda Tests"