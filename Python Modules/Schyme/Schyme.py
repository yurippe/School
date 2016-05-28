from SchymeParser import Parser
from Types import *
import StandardLib
from Evaluator import eval_exp

import sys
if sys.version_info[0] < 3:
    input = raw_input


def repl(prompt='Schyme> ', ctoSchemestr=True, interpreter=None):

    if interpreter == None:
        interpreter = Schyme(toSchemestr=False)
    while True:
        inp = input(prompt)
        out = interpreter.eval(inp)
        if ctoSchemestr:
            if out == None:
                continue
            print(schemestr(out))
        else:
            print(out)


    # parser = Parser()
    # env = StandardLib.get_default_env()
    # while True:
    #     inp = raw_input(prompt)
    #     parsedinp = parser.parse(inp)
    #     for exp in parsedinp:
    #         val = eval_exp(exp, env)
    #         if val is not None:
    #             output = schemestr(val)
    #             print(output)

def schemestr(exp):
    if isinstance(exp, list):
        return '(' + ' '.join(map(schemestr, exp)) + ')'
    else:
        return str(exp)


class Schyme(object):

    def __init__(self, environment=StandardLib.get_default_env(), toSchemestr=False):
        self.environment = environment
        self.parser = Parser()
        self.toSchemestr = toSchemestr

    def eval(self, inp):
        parsed = self.parser.parse(inp)
        val = None
        nextIsLiteral = False
        for exp in parsed:
            if nextIsLiteral:
                if isinstance(exp, list):
                    return SchemePair.fromPythonList(exp)
                else:
                    return exp
                nextIsLiteral = False
            if exp == "'":
                nextIsLiteral = True
                continue
            val = eval_exp(exp, self.environment)

        if self.toSchemestr:
            if val == None:
                return val
            return schemestr(val)
        else:
            return val

    def evalFile(self, filename):
        with open(filename, "r") as f:
            content = f.read()
        self.eval(content)


if __name__ == "__main__":
    repl()
