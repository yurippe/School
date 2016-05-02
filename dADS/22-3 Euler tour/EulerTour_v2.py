class Edge(object):
    def __init__(self, from_node, to_node):
        self.from_node = from_node
        self.to_node = to_node

        self.visited = False
        self.color = "white"

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
        self.color = "white"

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


def FindEulerTour(G):
    V_start = G[0]

    #Find an initial cycle
    EulerTour = CycleTour(V_start)
    i = 0
    V = EulerTour[i]

    while True:
        #Find a white outgoing edge from V
        edge = None
        for e in V.getEdges():
                    if e.color == "white":
                        edge = e
                        break

        #Is there an unresolved cycle?
        if not edge == None:
            Cycle = CycleTour(V)
            EulerTour = EulerTour[:i] + Cycle + EulerTour[i+1:]
        else:
            pass

        #Follow to the next
        i += 1
        if i+1 > len(EulerTour): break
        V = EulerTour[i]

        #We've merged with all other cycles, when we're back again at the start
        if V == V_start: break

    return EulerTour
#Create a tour from a vertice untill it is a cycle
def CycleTour(V_init):
    #Tour = New Circular Doublylinked List with [V_init]
    Tour = []
    V = V_init
    while True:
        Tour.append(V)
        #Find a white outgoing edge from V
        edge = None
        for e in V.getEdges():
            if e.color == "white":
                edge = e
                break

        #Follow the edge and color it black
        if not edge == None:
            edge.color = "black"
            V = edge.getTo()
        else:
            raise Exception("fack")

        #Stop, when you reach the start again
        if V == V_init:
            Tour.append(V)
            break

    return Tour


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

    r = FindEulerTour(vertixes)

    for edge in r:
        print str(edge)
