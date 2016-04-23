from Node import Node
from FindMaxRating import FindMaxRating

def main():
    #Test case 2

    root = Node("Max", 3)
    john = root.setLeft(Node("John", 2))
    annie = john.setLeft(Node("Annie", 1))

    assert root.name == "Max"
    assert root.left.name == "John"
    assert root.left.rating == 2
    assert root.left.left.name == "Annie"
    assert root.left.right == None
    assert root.left.left.left == None

    maxRating, invitedPeople = FindMaxRating(root)

    assert maxRating == 4
    assert [n.name for n in invitedPeople] == ['Annie', 'Max']

    print "Max rating for people {" + ", ".join(root.allChildren()) + "}: \n" + str(maxRating)
    print "People invited: "
    print [n.name for n in invitedPeople]



if __name__ == "__main__":
    main()
    print "Test passed"