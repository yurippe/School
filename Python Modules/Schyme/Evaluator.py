from Types import *
def getArgs(procedure, arguments, env):
    args = []
    nextIsLiteral = False
    i = 1
    for arg in arguments[1:]:
            if nextIsLiteral:
                if isinstance(arg, list):
                    arg = SchemePair.fromPythonList(arg)
                args.append(arg)
                nextIsLiteral = False
                i += 1
                continue

            if arg == "'":
                nextIsLiteral = True
                continue
            if(evalArg(arguments[0], i)):
                args.append(eval_exp(arg, env))
            else:
                args.append(arg) #is a literal ?
            i += 1
    return args

def evalArg(procedureName, index):
    if procedureName == "define" and index == 1:
        return False
    if procedureName == "lambda":
        return False
    if procedureName == "quote":
        return False
    if procedureName == "let":
        return False
    if procedureName == "and":
        return False
    if procedureName == "or":
        return False
    return True


def eval_exp(x, env):
    if isinstance(x, Symbol):      # variable reference
        return env.find(x)[x]
    elif not isinstance(x, List):  # constant literal
        return x
    else:                          # (procedure arg...)
        procedure = eval_exp(x[0], env)
        args = getArgs(procedure, x, env)
        #args = [eval_exp(arg, env) for arg in x[1:]]
        return procedure(env, *args)