def SchemeProcedureWrapper(f):
    def WrappedFunc(environment, *args):
        return f(*args)
    return WrappedFunc