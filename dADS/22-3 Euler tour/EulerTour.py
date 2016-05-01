class Edge(object):
    def __init__(self, from_node, to_node):
        self.from_node = from_node
        self.to_node = to_node

        self.visited = False

    def getTo(self):
        return self.to_node
    def getFrom(self):
        return self.from_node

class Vertex(object):
    def __init__(self, name):
        self.outedges = []
        self.inedges = []
        self.name = name

        self.visited = False

    def addEdge(self, toVertex):
        edge = Edge(self, toVertex)
        self.addOutEdge(edge)
        toVertex.addInEdge(edge)

    def addInEdge(self, edge):
        if not (edge in self.inedges):
            self.inedges.append(edge)

    def addOutEdge(self, edge):
        if not (edge in self.outedges):
            self.outedges.append(edge)

    def getEdges(self):
        return self.outedges

    def __str__(self):
        return str(self.name)

        
def Euler(graph):
    result = []

    

    for vertex in graph:
        #main loop
        loop = []
        #find a path:
        start = vertex
        for path in start.getEdges():
            if not path.visited:
                #find a loop:
                end = path.getTo()
                loop.append(path)
                path.visited = True
                while not end == start:
                    for path in end.getEdges():
                        if not path.visited:
                            #find a loop
                            end = path.getTo()
                            loop.append(path)
                            path.visited = True
                            break
        if len(loop) > 0:
            result.append(loop)

    if len(result) > 1:
        #we need to combine the results
        treatMap = {}
        #O(E)
        for loop in result[1:]:
            treatAs = loop[0].getFrom() #the first node (should also be the last)
            if treatAs in treatMap.keys():
                treatMap[treatAs] += loop
            else:
                treatMap[treatAs] = loop


        i = 0
        while i < len(result[0]):
            path = result[0][i]
            to = path.getTo()
            if to in treatMap.keys():
                result[0] = result[0][:i+1] + treatMap[to] + result[0][i+1:]
                del treatMap[to]
            i += 1
       
            
                
                
    elif len(result) == 0:
        return [[]]  
        
    return result[0]
       


if __name__ == "__main__":

    

    q1 = Vertex("q1")
    q2 = Vertex("q2")
    q3 = Vertex("q3")
    q4 = Vertex("q4")
    q5 = Vertex("q5")

    vertixes = [q1, q2, q3, q4, q5]
    
    q1.addEdge(q2)
    q2.addEdge(q3)
    q2.addEdge(q4)
    q3.addEdge(q5)
    q4.addEdge(q5)
    q5.addEdge(q1)
    q5.addEdge(q2)

    r = Euler(vertixes)

    for edge in r:
        print str(edge.getFrom()) + "-->" + str(edge.getTo())

    
