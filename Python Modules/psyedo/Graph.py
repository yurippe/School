class Graph(object):

    class Node(object):
        def __init__(self, name=""):
            self.identifier = name
            if type(name) == tuple:
                newname = "("
                for i in range(len(name)):
                    newname += str(name[i])
                    if i < len(name) - 1:
                        newname += ", "
                    else:
                        newname += ")"
                name = newname
            
            self.name = name
            defaultData = None #If self.data has no value for this key
            self.data = {} #Make it possible to store data on this node without ambiguity

        def __setitem__(self, key, value):
            self.data[key] = value

        def __getitem__(self, key):
            if key in self.data.keys():
                return self.data[key]
            else:
                return self.defaultData

        def __repr__(self):
            return str(self.name)
        def __str__(self):
            return str(self.name)

    class Edge(object):
        def __init__(self, weight, fromNode, toNode):
            self.weight = weight
            self.fromNode = fromNode
            self.toNode = toNode

        def __repr__(self):
            return str(self.fromNode) + "->" + str(self.toNode)
        def __str__(self):
            return str(self.fromNode) + "-- " + str(self.weight) +" ->" + str(self.toNode)
        
    def __init__(self, nopathvalue=9999999, nonodevalue=None, defaultweight=0):

        self.defaultweight = defaultweight
        self.nopathvalue = nopathvalue
        self.nonodevalue = nonodevalue
        self.nodemap = {}
        self.nodes = {}
        self.edges = {}
        
    def getWeight(self, fromNode, toNode):
        if not isinstance(fromNode, self.Node):
            fromNode = self.nodemap[fromNode]
        if not isinstance(toNode, self.Node):
            toNode = self.nodemap[toNode]
        
        k = (fromNode, toNode)
        if k in self.edges.keys():
            return self.edges[k].weight
        else:
            return self.nopathvalue

    def setWeight(self, fromNode, toNode, weight):
        if not isinstance(fromNode, self.Node):
            fromNode = self.nodemap[fromNode]
        if not isinstance(toNode, self.Node):
            toNode = self.nodemap[toNode]
        
        k = (fromNode, toNode)
        if not k in self.edges.keys():
            #Create new edge #TODO, decide if this should be standard behaviour
            self.addEdge(fromNode, toNode, weight)
        else:
            self.edges[k].weight = weight

    def addEdge(self, fromNode, toNode, weight=None):
        if weight == None:
            weight = self.defaultweight
        if not isinstance(fromNode, self.Node):
            fromNode = self.nodemap[fromNode]
        if not isinstance(toNode, self.Node):
            toNode = self.nodemap[toNode]

        e = self.Edge(weight, fromNode, toNode)
        self.edges[(fromNode, toNode)] = e
        return e

    def createNode(self, identifier):
        n = self.Node(identifier)
        if identifier in self.nodemap.keys():
            raise Exception("A node with this identifier already exists")
        self.nodemap[identifier] = n
        self.nodes[n] = True
        return n

    def __getitem__(self, key):
        #Get the node for this key if it exists
        if type(key) == tuple:
            if len(key) == 2:
                if isinstance(key[0], self.Node) and isinstance(key[1], self.node):
                    return self.edges[key] #return the edge in this special case
        
        if key in self.nodemap.keys():
            return self.nodemap[key]
        else:
            #raise Exception("Key does not exist")
            return self.nonodevalue

    def listNodes(self):
        nlist = [k for k in self.nodes.keys()]
        #nlist.sort() #TODO
        return nlist
    
    def listVertices(self): #Alias
        return self.listNodes()
    
    def listEdges(self):
        e = [k for k in self.edges.values()]
        #e.sort() #TODO
        return e

if __name__ == "__main__":
    #Gittergraf
    from Infinity import INFINITY, NINFINITY
    g = Graph(INFINITY, 0)
    k = 5
    for i in range(1,k+1):
        for j in range(1, k+1):
            t = (i,j)
            g.createNode(t)

    for i in range(1, k+1):
        for j in range(1, k):
            tfrom = (i,j)
            tto = (i, j+1)
            g.addEdge(tfrom, tto)

    for i in range(1, k+1):
        for j in range(2, k+1):
            tfrom = (i,j)
            tto = (i, j-1)
            g.addEdge(tfrom, tto)

    for i in range(1, k):
        for j in range(1, k+1):
            tfrom = (i,j)
            tto = (i+1, j)
            g.addEdge(tfrom, tto)
