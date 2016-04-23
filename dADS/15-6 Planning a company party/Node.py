class Node(object):

    def __init__(self, name, rating):
        self.name = name
        self.rating = rating

        self.parent = None
        self.left = None
        self.right = None

        self.childsum = None
        self.childreninvited = None


    def setParent(self, node):
        self.parent = node
        return node

    def setLeft(self, node):
        self.left = node
        node.setParent(self)
        return node

    def setRight(self, node):
        self.right = node
        node.setParent(self.parent)
        return node

    def __str__(self):
        return "(" + str(self.name) + "," + str(self.rating) + ")"

    def allChildren(self):
        arr = []
        arr.append(str(self))
        if self.right != None:
            arr += self.right.allChildren()
        if self.left != None:
            arr += self.left.allChildren()
        return arr