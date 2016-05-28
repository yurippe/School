import sys
sys.path.append("../..")
from Schyme import Schyme
from SchymeExceptions import *

interpreter = Schyme(toSchemestr=False)

assert interpreter.eval("(define x (lambda (y) (lambda (g) (+ y g)))) ((x 10) 20)") == 30

assert interpreter.eval("(define x 10) (let ([x 1] [y 2]) (+ x y))") == 3
assert interpreter.eval("(define x 10) (let ([z 1] [y 2]) (+ x y z))") == 13

try: interpreter.eval("(let ([x 1] [x 2]) x)"); assert False
except SyntaxError: pass
except: assert False

interpreter.eval("(define is-definition?(lambda (v)(and (proper-list-of-given-length? v 3)(equal? (car v) 'define))))")
interpreter.eval("(define proper-list-of-given-length? (lambda (v n) (or (and (null? v) (= n 0)) (and (pair? v) (> n 0) (proper-list-of-given-length? (cdr v) (1- n))))))")

assert interpreter.eval("(is-definition? (cons 'define (cons #t #t)))") == False
assert interpreter.eval("(is-definition? (cons 'define (cons #t (cons #t '()))))") == True

assert interpreter.eval("(define x (lambda (x) (+ x 100))) (x 11)") == 111


print "Passed Lambda and Let, Let* and Letrec Tests"