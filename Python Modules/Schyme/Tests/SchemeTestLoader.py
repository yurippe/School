import sys
sys.path.append("../..")
from Schyme import Schyme, repl
from Types import SchemePair
from SchymeExceptions import *

interpreter = Schyme(toSchemestr=False)

print("------------------------------------")
print("Opening SchemeUnitTest.scm")
interpreter.evalFile("SchemeUnitTest.scm")
print("Done interpreting SchemeUnitTest.scm")
print("------------------------------------")

repl(interpreter=interpreter)
print interpreter.eval("(equal? (stream-head stream-of-even-natural-numbers 10) '(0 4 8 12 16 20 24 28 32 36))")