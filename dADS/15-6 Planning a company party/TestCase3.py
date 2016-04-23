from Node import Node
from FindMaxRating import FindMaxRating

def main():
    #Test case 3

    root = Node("Max", 10000)
    john = root.setLeft(Node("John", 1))
    annie = john.setLeft(Node("Annie", 1))
    jens = annie.setLeft(Node("Jens", 10000))

    assert root.name == "Max"
    assert root.left.name == "John"
    assert root.left.rating == 1
    assert root.left.left.name == "Annie"
    assert root.left.right == None
    assert root.left.left.left.name == "Jens"

    maxRating, invitedPeople = FindMaxRating(root)

    assert maxRating == 20000
    assert [n.name for n in invitedPeople] == ['Jens', 'Max']

    print "Max rating for people {" + ", ".join(root.allChildren()) + "}: \n" + str(maxRating)
    print "People invited: "
    print [n.name for n in invitedPeople]



if __name__ == "__main__":
    main()
    print "Test passed"