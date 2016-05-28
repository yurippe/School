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

    def isKeyword(self, obj):
        return obj in self.keywords