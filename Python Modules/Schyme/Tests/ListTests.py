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


print "Passed List Tests"