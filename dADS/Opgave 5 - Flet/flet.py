def flet(x, y, z):
    #Conditions:
    #n = len(x)
    #m = len(y)
    #len(z) = n+m
    X = [None] + [letter for letter in x]
    Y = [None] + [letter for letter in y]
    Z = [None] + [letter for letter in z]
    
    class local:
        saves = [ [None for j in range(len(y) + 1)] for i in range(len(x)+1) ]
        visits = [ [0 for j in range(len(y) + 1)] for i in range(len(x)+1) ] ##Just for counting

        x_indexes = [ [None for j in range(len(y) + 1)] for i in range(len(x)+1) ]
        y_indexes = [ [None for j in range(len(y) + 1)] for i in range(len(x)+1) ]
        
    def F(i, j):

        if(local.saves[i][j] != None):
            return local.saves[i][j]

        #Count calls to F (getting a saved value doesn't count here)
        local.visits[i][j] += 1

        
        #True, i=0 j=0
        if i == 0 and j == 0:
            local.saves[i][j] = True
            local.x_indexes[i][j] = []
            local.y_indexes[i][j] = []
            return True

        #Y_ij, i=0 j>=1
        elif i == 0 and j >= 1:
            Fj = F(i, j-1)
            #Boolean expressions:
            YZ = (Z[i+j] == Y[j] and Fj)
            #Save the result
            local.saves[i][j] = YZ
            #Make index lists
            if YZ:
                local.y_indexes[i][j] = local.y_indexes[i][j-1] + [i+j]
                local.x_indexes[i][j] = local.x_indexes[i][j-1]
            else:
                local.y_indexes[i][j] = []
                local.x_indexes[i][j] = []
            return YZ

        #X_ij, i>=1 j=0
        elif i >= 1 and j == 0:
            Fi = F(i-1, j)
            #Boolean expressions
            XZ = (Z[i+j] == X[i] and Fi)
            #Save the result
            local.saves[i][j] = XZ
            #Save indexes:
            if XZ:
                local.x_indexes[i][j] = local.x_indexes[i-1][j] + [i+j]
                local.y_indexes[i][j] = local.y_indexes[i-1][j]
            else:
                local.y_indexes[i][j] = []
                local.x_indexes[i][j] = []
            return XZ

        #X_ij or  Y_ij, i>= 1 j>=1
        elif i >= 1 and j >= 1:
            Fi = F(i-1, j)
            Fj = F(i, j-1)
            #Boolean expressions
            XZ = (Z[i+j] == X[i] and Fi)
            YZ = (Z[i+j] == Y[j] and Fj)
            #Save the result
            local.saves[i][j] = (XZ or YZ)
            #Save indexes
            if XZ:
                local.x_indexes[i][j] = local.x_indexes[i-1][j] + [i+j]
                local.y_indexes[i][j] = local.y_indexes[i-1][j]
            elif YZ:
                local.y_indexes[i][j] = local.y_indexes[i][j-1] + [i+j]
                local.x_indexes[i][j] = local.x_indexes[i][j-1]
            else:
                local.y_indexes[i][j] = []
                local.x_indexes[i][j] = []
            #Return
            return (XZ or YZ)

    def printFlet(Q, i, j):
        if (i == 0 and j == 0):
            return
        if Q[i-1][j] == True:
            printFlet(Q, i-1, j)
            print i+j
        elif Q[i][j-1] == True:
            printFlet(Q, i, j-1)

    result = F(len(x), len(y))
    
    for s in local.saves:
        print s

    print "FLET X INDEXES"
    printFlet(local.saves, len(x), len(y))
    print "----------"
    print "Number of calls with the argument i,j being the indexes:"
    print local.visits
    print "X indexes:"
    print local.x_indexes[len(x)][len(y)]
    print "Y indexes:"
    print local.y_indexes[len(x)][len(y)]
    print "Result:"
    return result

print flet("uro", "gled", "gulerod")
