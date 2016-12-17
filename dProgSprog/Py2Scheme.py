import ast

### Known limits / bugs
#####################################
#1  All functions in python must use return, write return False
#   if you don't have return values, if you don't do this, the last
#   in your function will be the return value in scheme. This is because
#   Scheme doesn't have a return keyword, but just returns what is on the
#   last line.
#####################################
#2  No support for classes yet, because Scheme is a functional programming-
#   language, and I feel like I am already cheating by using "set!" for
#   certain assignments.
#####################################
#3  Returning "None" in python doesn't work, since scheme doesnt have
#   a "void" / "null" value. Just return False instead, since what you
#   probably want is a Falsey return value. (This issue is practically
#   the same as #1 because python automatically returns None if you don't
#   specify a return value)
#####################################
#4  Print is only supported at top level, simply because in Scheme it
#   has to be wrapped in a (begin (display "text") ([...])) which is
#   cumbersome, and simply not supported at this time.

class Compiler(object):

    def __init__(self, tree):
        self.tree = tree
        self.stack = []
        self.level = 0
        self.scopes = {0:[]}

    def in_current_scope(self, var, minscope=0):
        if minscope > self.level: return False
        for i in range(self.level,minscope,-1):
            if var in self.scopes[i]: return True
        return False

    def add_to_scope(self, var):
        self.scopes[self.level].append(var)

    def push(self, *args):
        for item in args:
            self.stack.append(item)

    def enter_scope(self):
        self.level += 1
        self.scopes[self.level] = []

    def close_scope(self):
        while self.level > 0:
            self.push(")")
            self.scopes[self.level] = []
            self.level -= 1

    def Compile(self):
        self.parse(self.tree)
        #mega hacky but should work
        r = " ".join([str(token) for token in self.stack])
        r = r.replace("( ", "(").replace(" )", ")")
        r = r.replace("[ ", "[").replace(" ]", "]")
        return r

    def parse(self, node):
        if isinstance(node, ast.Module):
            #top level, some special rules apply
            return self.parse_module(node)
        if isinstance(node, ast.Num):
            self.push(node.n)
            return
        if isinstance(node, ast.Str):
            self.push(node.s)
            return
        if isinstance(node, ast.Name):
            if node.id == "True": self.push("#t")
            elif node.id == "False": self.push("#f")
            else: self.push(node.id)
            return

        if isinstance(node, ast.Expr):
            self.parse_expression(node)
            return

        if isinstance(node, ast.Lambda):
            self.parse_lambda(node)
            return

        if isinstance(node, ast.BinOp):
            self.parse_binop(node)
            return

        if isinstance(node, ast.BoolOp):
            self.parse_boolop(node)
            return

        if isinstance(node, ast.Return):
            self.parse_return(node)
            return

        if isinstance(node, ast.Assign):
            self.parse_assign(node)
            return

        if isinstance(node, ast.AugAssign):
            self.parse_augassign(node)
            return

        if isinstance(node, ast.Call):
            self.parse_call(node)
            return

        if isinstance(node, ast.List):
            self.parse_list(node)
            return

        if isinstance(node, ast.For):
            self.parse_for(node)
            return

        if isinstance(node, ast.If):
            self.parse_if(node)
            return

        if isinstance(node, ast.Compare):
            self.parse_compare(node)
            return

        print("---------Unknown type: " + str(node) + " in parse()---------")

    def parse_list(self, node):
        self.push("(", "list")
        for element in node.elts:
            self.parse(element)
        self.push(")")

    def parse_compare(self, node):
        self.push("(", self.get_operator(node.ops[0])) #ops seems to always be of length 1
        self.parse(node.comparators[0]) #limited to 1 thing on the rightside
        self.parse(node.left)
        self.push(")")

    def parse_if(self, node):
        #(if cond ontrue onfalse)
        self.push("(", "if")
        self.parse(node.test)
        for element in node.body:
            self.parse(element)
        if len(node.orelse) < 1:
            #no alternate is specified so R5RS says the result is unspecified,
            #a.k.a we can choose, so it is false to mimic python with None
            #type being falsey
            self.push("#f")
        else:
            self.parse(node.orelse[0]) #Seems to always have only 1 element (?)
        self.push(")")

    def parse_for(self, node):
        self.push("(", "for-each", "(", "lambda", "(")
        self.parse(node.target)
        self.push(")")
        for element in node.body:
            self.parse(element)
        self.push(")")
        self.parse(node.iter)
        self.push(")")

    def get_operator(self, node):
        if isinstance(node, ast.Add): return "+"
        elif isinstance(node, ast.Sub): return "-"
        elif isinstance(node, ast.Mult): return "*"
        elif isinstance(node, ast.Div): return "/"
        elif isinstance(node, ast.Mod): return "mod"
        elif isinstance(node, ast.Or): return "or"
        elif isinstance(node, ast.And): return "and"
        elif isinstance(node, ast.Eq): return "="
        elif isinstance(node, ast.LtE): return "<="
        elif isinstance(node, ast.GtE): return ">="
        elif isinstance(node, ast.Lt): return "<"
        elif isinstance(node, ast.Gt): return ">"

        print("-------- Unknown operator: " + str(node) + " ---------")
        
    def parse_binop(self, node):
        self.push("(", self.get_operator(node.op))
        self.parse(node.left)
        self.parse(node.right)
        self.push(")")

    def parse_boolop(self, node):
        self.push("(", self.get_operator(node.op))
        for element in node.values:
            self.parse(element)
        self.push(")")

    def parse_expression(self, node):
        self.parse(node.value)

    def parse_lambda(self, node):
        self.push("(", "lambda")
        self.parse_arguments(node.args)
        self.parse(node.body)
        self.push(")")

    def parse_arguments(self, node):
        self.push("(")
        for arg in node.args:
            self.parse(arg)
        self.push(")")

    def parse_toplevel_function(self, node):
        self.push("(", "define", node.name, "(", "lambda")
        self.add_to_scope(node.name) #we can use it inside the body (recursion)
        self.parse_arguments(node.args)
        for line in node.body:
            self.parse(line)
        self.push(")", ")")

    def parse_return(self, node):
        self.parse(node.value)
        self.close_scope()

    def parse_augassign(self, node):
        #We can assume the variable is already set, or it is a programming error
        self.push("(", "set!")
        self.parse(node.target)
        self.push("(", self.get_operator(node.op))
        self.parse(node.target)
        self.parse(node.value)
        self.push(")", ")")

    def parse_assign(self, node):
        if len(node.targets) > 1:
            #let*
            #what to do with scope here when it comes to choosing between set! and let*
            self.push("(", "let*", "(")
            for target in node.targets:
                self.push("[")
                self.parse(target)
                self.parse(node.value)
                self.push("]")
            self.enter_scope()
            
        else:
            if self.in_current_scope(node.targets[0].id, 1):
                #we dont want top level defines here, to mimic python behaviour
                self.push("(", "set!")
                self.parse(node.targets[0])
                self.parse(node.value)
                self.push(")")
                return
            #let
            self.push("(", "let", "(","[")
            self.parse(node.targets[0])
            self.parse(node.value)
            self.push("]", ")")
            self.enter_scope()
            self.add_to_scope(node.targets[0].id) #hardcoded =(

    def parse_call(self, node):
        #no keyword args atm, only good ol' foo(1,2,3)
        self.push("(")
        self.parse(node.func)
        for arg in node.args:
            self.parse(arg)
        self.push(")")

    def parse_print(self, node):
        if len(node.values) < 1:
            return
        self.push("(", "display")
        self.parse(node.values[0]) #only 1 arg here please
        self.push(")")

    def parse_module(self, node):
        #Top level accepts only:
        ##ast.Assign        - will be a define at top level; ex: (define x 10)
        ##ast.FunctionDef   - will be define; ex: (define foo (lambda (x) x))
        ##ast.Expr          - will be an expression; ex: (foo arg1 arg2)
        ##ast.Print         - will be a call to display; ex: (display 10)
        for subnode in node.body:
            if isinstance(subnode, ast.Assign):
                self.push("(", "define")
                self.push(subnode.targets[0].id) #restricted to being a single Name
                self.parse(subnode.value)
                self.push(")")
                self.add_to_scope(subnode.targets[0].id)
                continue
            if isinstance(subnode, ast.FunctionDef):
                self.parse_toplevel_function(subnode)
                continue
            if isinstance(subnode, ast.Expr):
                self.parse_expression(subnode)
                continue

            if isinstance(subnode, ast.Print):
                self.parse_print(subnode)
                continue

            print("-------------Illegal toplevel type: " + str(subnode) + "-----")
        
    


if __name__ == "__main__":

    expr = """
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
    f(arg)

print(dethunk(fact, 10))
#expected result: 3628800
    """


    tree = ast.parse(expr)
    comp = Compiler(tree)
    print(comp.Compile())
