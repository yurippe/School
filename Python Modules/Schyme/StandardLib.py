import Environment
from Evaluator import eval_exp
from Types import *

def define(environment, *args):
    try:
        (variable, expression) = args
    except:
        raise SyntaxError("Invalid argument count 'define' takes exactly 2 arguments")

    if environment.isKeyword(variable):
        raise SyntaxError("'" + str(variable) + "' is a reserved keyword")
    environment[variable] = expression



def lambdaexp(environment, *args):
    try:
        (parameters, body) = args
    except:
        raise SyntaxError("Invalid argument count 'lambda' takes exactly 2 arguments")

    return Procedure(parameters, body, environment)


def quote(environment, *args):
    (expression,) = args
    return expression

def set(environment, *args):
    try: (var, exp) = args
    except: raise SyntaxError("Invalid argument count 'set!' takes exactly 2 arguments")

    environment.find(var)[var] = exp

def add(environment, *args):
    s = 0
    for arg in args:
        s += arg
    return s

def mul(environment, *args):
    s = 1
    for arg in args:
        s *= arg
    return s

def sub(environment, *args):
    try: answer = args[0]
    except IndexError: raise SyntaxError("Invalid argument count '-' takes at least 1 argument")
    for num in args[1:]:
        answer -= num
    return answer

def div(environment, *args):
    raise NotImplementedError("Not implemented '/'")

def gt(environment, *args):
    try: c = args[0]
    except IndexError: raise SyntaxError("Invalid argument count '>' takes at least 1 argument")
    i = 1
    while i < len(args):
        if c > args[i]:
            c = args[i]
            i += 1
        else:
            return False
    return True

def lt(environment, *args):
    try: c = args[0]
    except IndexError: raise SyntaxError("Invalid argument count '<' takes at least 1 argument")
    i = 1
    while i < len(args):
        if c < args[i]:
            c = args[i]
            i += 1
        else:
            return False
    return True

def lte(environment, *args):
    try: c = args[0]
    except IndexError: raise SyntaxError("Invalid argument count '<' takes at least 1 argument")
    i = 1
    while i < len(args):
        if c <= args[i]:
            c = args[i]
            i += 1
        else:
            return False
    return True

def gte(environment, *args):
    try: c = args[0]
    except IndexError: raise SyntaxError("Invalid argument count '<' takes at least 1 argument")
    i = 1
    while i < len(args):
        if c >= args[i]:
            c = args[i]
            i += 1
        else:
            return False
    return True

def eq(environment, *args):
    try: c = args[0]
    except IndexError: raise SyntaxError("Invalid argument count '<' takes at least 1 argument")
    i = 1
    while i < len(args):
        if c == args[i]:
            c = args[i]
            i += 1
        else:
            return False
    return True

class Procedure(object):

    def __init__(self, parameters, body, environment):
        self.parameters = parameters
        self.body = body
        self.environment = environment

    def __call__(self, environment, *args):
        localenv = Environment.Environment(self.parameters, args, environment) #self.environment or environment ?
        return eval_exp(self.body, localenv)

def get_default_env():
        "An environment with some Scheme standard procedures."
        import math
        env = Environment.Environment()
        env.update(vars(math)) # sin, cos, sqrt, pi, ...
        env.update({
        "define": define, "lambda": lambdaexp,
        "quote": quote, "set!": set,
        '+':add, '-':sub, '*':mul, '/':div,
        '>':gt, '<':lt, '>=':gte, '<=':lte, '=':eq,
        'abs':     abs,
        'append':  add,
        #'apply':   apply,
        'begin':   lambda *x: x[-1],
        'car':     lambda x: x[0],
        'cdr':     lambda x: x[1:],
        'cons':    lambda x,y: [x] + y,
        #'eq?':    eq but for identity,
        'equal?':  eq,
        'length':  len,
        'list':    lambda *x: list(x),
        'list?':   lambda x: isinstance(x,list),
        'map':     map,
        'max':     max,
        'min':     min,
        #'not':    notoperator,
        'null?':   lambda x: x == [],
        'number?': lambda x: isinstance(x, Number),
        'procedure?': callable,
        'round':   round,
        'symbol?': lambda x: isinstance(x, Symbol),
        "#t": True, "#f":False
        })
        return env