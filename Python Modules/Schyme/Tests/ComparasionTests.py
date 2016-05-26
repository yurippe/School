import sys
sys.path.append("..")
from Schyme import Schyme

interpreter = Schyme(toSchemestr=False)


assert interpreter.eval("(> 10 5 3 2)") == True
assert interpreter.eval("(> 10 5 3 3)") == False
assert interpreter.eval("(> 10 3 5 2)") == False

assert interpreter.eval("(< 10 20 30 40)") == True
assert interpreter.eval("(< 10 5 30 40)") == False
assert interpreter.eval("(< 10 30 20 40)") == False

assert interpreter.eval("(= (+ pi pi) (* pi 2))") == True

print "Passed Comparator Tests"