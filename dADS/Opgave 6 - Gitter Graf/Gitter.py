import sys
sys.path.append("../../Python Modules/")
from psyedo.Matrix import Matrix
from psyedo.Infinity import *
from psyedo.Graph import Graph

def InitializeSingleSource(G, s):
    for v in G.listVertices():
        v["d"] = INFINITY
        v["pi"] = None
    s["d"] = 0

def Relax(u, v, w):
    if v["d"] > u["d"] + w(u,v):
        v["d"] = u["d"] + w(u,v)
        v["pi"] = u

def FindShortestPathInG(G):
    s = G[1,1]
    w = G.getWeight

    InitializeSingleSource(G, s)

    v = s

    while True: #Do
        while True:
            Relax(v, v["right"], w)
            v = v["right"]
            if v["right"] == None: break
            
        while True:
            Relax(v, v["left"], w)

            if v["up"] != None:
                Relax(v, v["up"], w)

            v = v["left"]
            if v["left"] == None: break
            
        if v["up"] != None:
            Relax(v, v["up"], w)
            
        v = v["up"]
        if v == None: break
    

if __name__ == "__main__":  
#Gittergraf
    g = Graph(INFINITY, None, 5)
    k = 3
    for i in range(1,k+1):
        for j in range(1, k+1):
            t = (i,j)
            g.createNode(t)


    #Make right left up and down, to satisfy Lasse
    for i in range(1, k+1):
        for j in range(1, k+1):
            base = g[i,j]
            base["right"] = g[i, j+1]
            base["left"] = g[i, j-1]
            base["up"] = g[i+1, j]
            base["down"] = g[i-1, j]
            
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

    #Steffans test case:
    #i = 1
    g.setWeight((1,1),(1,2),2)
    g.setWeight((1,1),(2,1),4)
    g.setWeight((1,2),(1,1),1)
    g.setWeight((1,2),(2,2),3)
    g.setWeight((1,2),(1,3),5)
    g.setWeight((1,3),(1,2),3)
    g.setWeight((1,3),(2,3),3)
    #i = 2
    g.setWeight((2,1),(2,2),2)
    g.setWeight((2,1),(3,1),2)
    g.setWeight((2,2),(2,1),2)
    g.setWeight((2,2),(3,2),6)
    g.setWeight((2,2),(2,3),2)
    g.setWeight((2,3),(2,2),3)
    g.setWeight((2,3),(3,3),2)
    #i = 3
    g.setWeight((3,1),(3,2),4)
    g.setWeight((3,2),(3,1),1)
    g.setWeight((3,2),(3,3),2)
    g.setWeight((3,3),(3,2),1)

    #print(g.listEdges())
    #print(g[1,1]["right"])

    FindShortestPathInG(g)

    for i in range(1, k+1):
        for j in range(1, k+1):
            node = g[i,j]
            print(str(node) + " d: " + str(node["d"]) + " pi: " + str(node["pi"]))    
    
