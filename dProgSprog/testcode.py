x = 1
def test(arg1, arg2):
    l = [1, 2, 3]
    y = 5
    for e in l:
        if e % 2 == 0:
            y += e
        elif False or True:
            y += 1000
    z = lambda x,y : x*y
    return x % arg1 + arg2 + y + z(z(10,10),10)
    
print(test(2,3))
#expected result: 3011

def fact(n):
    if n == 0 or n == 1:
        return 1
    else:
        return fact(n-1) * n

def dethunk(f, arg):
    return f(arg)

print(dethunk(fact, 10))
#expected result: 3628800

def x():
    l = 0
    for i in range(5,15,5):
        print(i)
        l += i + 2
    print(l)
x()
#Should print 5 10 19

def y():
    if False: print("no")
    elif False: print("I said NO!")
    else:
        print("this")
        print("should")
        print("work")
y()
#Should print this should work

def z():
    x = 1
    y = 2
    print(x)
    print(y)
    l = 20
    print(l)
z()
#Should print 1 2 20
