from SchymeParser import Parser
from Types import *
import StandardLib
from Evaluator import eval_exp





def repl(prompt='Schyme> '):
    parser = Parser()
    env = StandardLib.get_default_env()
    while True:
        inp = raw_input(prompt)
        parsedinp = parser.parse(inp)
        for exp in parsedinp:
            val = eval_exp(exp, env)
            if val is not None:
                output = schemestr(val)
                print(output)

def schemestr(exp):
    if isinstance(exp, list):
        return '(' + ' '.join(map(schemestr, exp)) + ')'
    else:
        return str(exp)


class Schyme(object):

    def __init__(self, environment=StandardLib.get_default_env()):
        self.environment = environment
        self.parser = Parser()

    def eval(self, inp):
        parsed = self.parser.parse(inp)
        val = None
        for exp in parsed:
            val = eval_exp(exp, self.environment)
        if val == None:
            return val
        return schemestr(val)
    
if __name__ == "__main__":

    repl()

    with open("test.scm", "r") as f:
        content = f.read()

    parser = Parser()
    print(parser.parse(content))
