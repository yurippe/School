import Environment
from Evaluator import eval_exp
from SchymeExceptions import *
from Types import *
from Wrappers import SchemeProcedureWrapper
import MathLib
from SchymeParser import Parser

def NOT_IMPLEMENTED(environment, *args):
    raise NotImplementedError("Not implemented")

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

def let(environment, *args):
    try: (parameters, body) = args
    except: raise SyntaxError("Invalid argument count 'let' takes exactly 2 arguments")
    newenv = Environment.Environment(outer=environment)
    uniqueness = []
    for param in parameters:
        if param[0] in uniqueness:
            raise SyntaxError("Duplicate paramater in 'let'")
        else:
            uniqueness.append(param[0])

        newenv[param[0]] = eval_exp(param[1], environment)
    return eval_exp(body, newenv)

def letrec(environment, *args): #NOT WORKING, read more: https://docs.racket-lang.org/reference/let.html
    try: (parameters, body) = args
    except: raise SyntaxError("Invalid argument count 'let' takes exactly 2 arguments")

    newenv = Environment.Environment(outer=environment)
    uniqueness = []
    for param in parameters:
        if param[0] in uniqueness:
            raise SyntaxError("Duplicate paramater in 'let'")
        else:
            uniqueness.append(param[0])

        newenv[param[0]] = None

    for param in parameters:
        print "evaling" + str(param[0])
        newenv[param[0]] = eval_exp(param[1], newenv)

    return eval_exp(body, newenv)

def quote(environment, *args):
    (expression,) = args
    return expression


def cons(environment, *args):
    try: (xs, ys) = args
    except: raise SyntaxError("Invalid argument count 'cons' takes exactly 2 arguments")
    return SchemePair(xs,ys)

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

def equal(environment, *args):
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

def eq_is(environment, *args):
    try: (a, b) = args
    except IndexError: raise SyntaxError("Invalid argument count 'eq?' takes at exactly 2 argument")

    return (a is b)

def abs_scheme(environment, *args):
    try: (n,) = args
    except IndexError: raise SyntaxError("Invalid argument count 'abs' takes at exactly 1 argument")
    return abs(n)

def append(environment, *args):
    r = []
    for arg in args:
        if isinstance(arg, SchemePair):
            arg = arg.toPythonList()
        r += arg
    return SchemePair.fromPythonList(r)

def not_scheme(environment, *args):
    try: (b,) = args
    except IndexError: raise SyntaxError("Invalid argument count 'not' takes at exactly 1 argument")
    return (not b)

def LOAD(environment, *args):
    try: (fname,) = args
    except IndexError: raise SyntaxError("Invalid argument count 'load' takes at exactly 1 argument")

    with open(fname, "r") as f:
        content = f.read()


    parser = Parser()
    parsed = parser.parse(content)
    for exp in parsed:
        val = eval_exp(exp, environment)

def member(environment, *args):
    try: (searchfor, searchin) = args
    except IndexError: raise SyntaxError("Invalid argument count 'member' takes at exactly 2 arguments")
    searchin = searchin.toPythonList()
    i = 0
    while i < len(searchin):
        if searchin[i] == searchfor:
            return searchin[i:]
        i += 1
    return False

def memq(environment, *args):
    try: (searchfor, searchin) = args
    except IndexError: raise SyntaxError("Invalid argument count 'memq' takes at exactly 2 arguments")
    searchin = searchin.toPythonList()
    i = 0
    while i < len(searchin):
        if searchin[i] is searchfor:
            return searchin[i:]
        i += 1
    return False

def list_head(environment, *args):
    try: (listin, index) = args
    except IndexError: raise SyntaxError("Invalid argument count 'list-head' takes at exactly 2 arguments")
    if index > len(listin): raise SyntaxError("Index " + str(index) + " is out of range for list: " + str(listin))
    if index < 0: raise SyntaxError("Invalid index: " + str(index))
    return SchemePair.fromPythonList(listin[:index])

def list_tail(environment, *args):
    try: (listin, index) = args
    except IndexError: raise SyntaxError("Invalid argument count 'list-tail' takes at exactly 2 arguments")
    if index > len(listin): raise SyntaxError("Index " + str(index) + " is out of range for list: " + str(listin))
    if index < 0: raise SyntaxError("Invalid index: " + str(index))
    return SchemePair.fromPythonList(listin[index:])

def printf(environment, *args):
    print(args)

def errorf(environment, *args):
    raise SchemeErrorf(" ; ".join([str(arg) for arg in args]))

def and_scheme(environment, *args):
    for arg in args:
        if eval_exp(arg, environment):
            continue
        else: return False
    return True

def or_scheme(environment, *args):
    for arg in args:
        if eval_exp(arg, environment):
            return True
    return False

def if_scheme(environment, *args):
    (test, conseq, alt) = args
    result = eval_exp(test, environment)
    if result:
        return eval_exp(conseq, environment)
    else:
        return eval_exp(alt, environment)

def integer_questionmark(environment, *args):
    try: (i, ) = args
    except IndexError: raise SyntaxError("Invalid argument count 'integer?' takes at exactly 1 arguments")
    try:
        c = int(i)
        return True
    except ValueError: return False

class Procedure(object):

    def __init__(self, parameters, body, environment):
        self.parameters = parameters
        self.body = body
        self.environment = environment

    def __call__(self, environment, *args):
        localenv = Environment.Environment(self.parameters, args, self.environment)
        return eval_exp(self.body, localenv)



def get_default_env():
        "An environment with some Scheme standard procedures."

        env = Environment.Environment()

        env.update(MathLib.mathlib)  # sin, cos, sqrt, pi, ...
        env.update({
        "define": define, "lambda": lambdaexp,
        "quote": quote, "set!": set,
        '+': add, '-': sub, '*': mul, '/': div,
        '>': gt, '<': lt, '>=': gte, '<=':lte, '=': equal,
        'abs':     abs_scheme,
        'append':  append,
        'apply':   SchemeProcedureWrapper(apply),
        'begin':   SchemeProcedureWrapper(lambda *x: x[-1]),
        'car':     SchemeProcedureWrapper(lambda x: x.car),
        'cdr':     SchemeProcedureWrapper(lambda x: x.cdr),
        'cons':    cons,
        'eq?':     eq_is,
        'equal?':  equal,
        'pair?':   SchemeProcedureWrapper(lambda x: isinstance(x, SchemePair)),
        'length':  SchemeProcedureWrapper(len),
        'list':    SchemeProcedureWrapper(lambda *x: SchemePair.fromPythonList(list(x))),
        'list?':   SchemeProcedureWrapper(lambda x: isinstance(x,list)),
        'map':     SchemeProcedureWrapper(map),
        'max':     SchemeProcedureWrapper(max),
        'min':     SchemeProcedureWrapper(min),
        'not':     not_scheme,
        'zero?':   SchemeProcedureWrapper(lambda x: x==0),
        'null?':   SchemeProcedureWrapper(lambda x: x == []),
        'number?': SchemeProcedureWrapper(lambda x: isinstance(x, Number)),
        'integer?': integer_questionmark,
        'negative?': SchemeProcedureWrapper(lambda x: x < 0),
        'procedure?': SchemeProcedureWrapper(callable),
        'round':   SchemeProcedureWrapper(round),
        'symbol?': SchemeProcedureWrapper(lambda x: isinstance(x, Symbol)),
        "#t": True, "#f": False, "load": LOAD, "printf": printf, "errorf": errorf,
        "member": member, "memq": memq, "list-head": list_head, "list-tail": list_tail,
        "let": let, "letrec": letrec, "let*": NOT_IMPLEMENTED,
        "and": and_scheme, "or": or_scheme, "if": if_scheme,
        "1-": SchemeProcedureWrapper(lambda x: x - 1), "1+": SchemeProcedureWrapper(lambda x: x + 1)
        })
        return env