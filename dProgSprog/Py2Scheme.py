import ast

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
            self.push(node.id)
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

        print("---------Unknown type: " + str(node) + " in parse()---------")

    def parse_list(self, node):
        self.push("(", "list")
        for element in node.elts:
            self.parse(element)
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
        
    def parse_binop(self, node):
        self.push("(", self.get_operator(node.op))
        self.parse(node.left)
        self.parse(node.right)
        self.push(")")

    def parse_expression(self, node):
        self.parse(node.value)
        #self.dedent()?

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

    def parse_module(self, node):
        #Top level accepts only:
        ##ast.Assign        - will be a define at top level; ex: (define x 10)
        ##ast.FunctionDef   - will be define; ex: (define foo (lambda (x) x))
        ##ast.Expr          - will be an expression; ex: (foo arg1 arg2)
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

            print("-------------Illegal toplevel type: " + str(subnode) + "-----")
        
    


if __name__ == "__main__":

    expr = """
x = 1
def test(arg1, arg2):
    l = [1, 2, 3]
    y = 5
    for e in l:
        y += e
    z = lambda x,y : x*y
    return x + arg1 + arg2 + y + z(10,10)
test(2,3)
    """

    tree = ast.parse(expr)
    print(Compiler(tree).Compile())
