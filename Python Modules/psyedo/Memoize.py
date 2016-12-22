def memoize(func):
    memory = {}
    def wrapper(*args):
        if args in memory.keys():
            return memory[args]
        else:
            retval = func(*args)
            memory[args] = retval
            return retval
    return wrapper



if __name__ == "__main__":
    @memoize
    def memoized_fib(n):
        print("call to fib(" + str(n) + ")")
        if n == 1 or n == 2:
            return 1
        else:
            return memoized_fib(n-1) + memoized_fib(n-2)

    def fib(n):
        print("call to fib(" + str(n) + ")")
        if n == 1 or n == 2:
            return 1
        else:
            return fib(n-1) + fib(n-2)

    print("Non-decorated fib") 
    print("fib(5) = " + str(fib(5)))
    print("-----------------")
    print("-----------------")
    print("Decorated fib")
    print("memoized_fib(5) = " + str(memoized_fib(5)))
    print("-----------------")
