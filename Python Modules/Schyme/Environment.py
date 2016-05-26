class Environment(dict):

    def __init__(self, parms=(), args=(), outer=None):
        self.keywords = ["time", "if", "and", "or", "define", "else", "cond",
                         "case", "let", "let*", "letrec", "begin", "unless",
                         "quote", "lambda", "trace-lambda", "(", ")", "[", "]", ".", "#t", "#f"]
        self.update(zip(parms, args))
        self.outer = outer

    def find(self, var):
        if var in self:
            return self
        else:
            if self.outer == None:
                raise SyntaxError("Variable not defined: " + str(var))
            env = self.outer.find(var)
            if env == None:
                raise SyntaxError("Variable not defined: " + str(var))
            return env

    # @staticmethod
    # def get_default_env():
    #     "An environment with some Scheme standard procedures."
    #     import math, operator as op
    #     env = Environment()
    #     env.update(vars(math)) # sin, cos, sqrt, pi, ...
    #     env.update({
    #     "define": StandardLib.define, "lambda": StandardLib.lambdaexp,
    #     "quote": StandardLib.quote, "set!": StandardLib.set,
    #     '+':StandardLib.add, '-':StandardLib.sub, '*':StandardLib.mul, '/':StandardLib.div,
    #     '>':StandardLib.gt, '<':StandardLib.lt, '>=':op.ge, '<=':op.le, '=':op.eq,
    #     'abs':     abs,
    #     'append':  op.add,
    #     #'apply':   apply,
    #     'begin':   lambda *x: x[-1],
    #     'car':     lambda x: x[0],
    #     'cdr':     lambda x: x[1:],
    #     'cons':    lambda x,y: [x] + y,
    #     'eq?':     op.is_,
    #     'equal?':  op.eq,
    #     'length':  len,
    #     'list':    lambda *x: list(x),
    #     'list?':   lambda x: isinstance(x,list),
    #     'map':     map,
    #     'max':     max,
    #     'min':     min,
    #     'not':     op.not_,
    #     'null?':   lambda x: x == [],
    #     'number?': lambda x: isinstance(x, Number),
    #     'procedure?': callable,
    #     'round':   round,
    #     'symbol?': lambda x: isinstance(x, Symbol),
    #     })
    #     return env

    def isKeyword(self, obj):
        return obj in self.keywords