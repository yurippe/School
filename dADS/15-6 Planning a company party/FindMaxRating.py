NumberOfCalls = 0
def onNodeVisit(node):
    global NumberOfCalls
    NumberOfCalls += 1

def FindMaxRating(node):

    ##Basically the saving procedure
    if node.childsum != None and node.childreninvited != None:
        return node.childsum, node.childreninvited

    if node.left == None:
        onNodeVisit(node) #for debug info
        if 0 <= node.rating:
            node.childsum = node.rating
            node.childreninvited = [node]
            return node.rating, [node]
        else:
            node.childsum = 0
            node.childreninvited = []
            return 0, []
    else:
        #sum of all children
        currentChild = node.left
        maxofcurrent = FindMaxRating(currentChild)
        maxChildrenSum = maxofcurrent[0]
        childrenInvited = maxofcurrent[1]
        while currentChild.right != None:
            currentChild = currentChild.right
            maxofcurrent = FindMaxRating(currentChild)
            maxChildrenSum += maxofcurrent[0]
            childrenInvited += maxofcurrent[1]


        #sum of all grandchildren
        currentChild = node.left
        maxGrandchildrenSum = 0
        grandchildrenInvited = []

        currentGrandChild = currentChild.left
        if currentGrandChild != None:
            maxofcurrent = FindMaxRating(currentGrandChild)
            maxGrandchildrenSum += maxofcurrent[0]
            grandchildrenInvited += maxofcurrent[1]

            ## Loop1
            while currentGrandChild.right != None:
                currentGrandChild = currentGrandChild.right
                maxofcurrent = FindMaxRating(currentGrandChild)
                maxGrandchildrenSum += maxofcurrent[0]
                grandchildrenInvited += maxofcurrent[1]

            while currentChild.right != None:
                currentChild = currentChild.right
                currentGrandChild = currentChild.left
                if currentGrandChild != None:
                    maxofcurrent = FindMaxRating(currentGrandChild)
                    maxGrandchildrenSum += maxofcurrent[0]
                    grandchildrenInvited += maxofcurrent[1]

                    ## Loop1
                    while currentGrandChild.right != None:
                        currentGrandChild = currentGrandChild.right
                        maxofcurrent = FindMaxRating(currentGrandChild)
                        maxGrandchildrenSum += maxofcurrent[0]
                        grandchildrenInvited += maxofcurrent[1]

        onNodeVisit(node) #for debug info
        if maxChildrenSum < maxGrandchildrenSum + node.rating:
            #Save the values
            node.childsum = maxGrandchildrenSum + node.rating
            node.childreninvited = grandchildrenInvited + [node]
            #return results
            return maxGrandchildrenSum + node.rating, grandchildrenInvited + [node]
        else:
            #Save the values
            node.childsum = maxChildrenSum
            node.childreninvited = childrenInvited
            #return results
            return maxChildrenSum, childrenInvited

if __name__ == "__main__":
    from RunTestCases import *
