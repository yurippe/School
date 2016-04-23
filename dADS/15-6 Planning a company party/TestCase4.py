from Node import Node
from FindMaxRating import FindMaxRating

def main():
    #Test case 4

    root = Node("Max", -2)
    john = root.setLeft(Node("John", 18))
    mark = john.setRight(Node("Ann", 22)).setRight(Node("Mark", 2))
    rob = john.setLeft(Node("Rob", 12))
    rob.setRight(Node("Bob", 4)).setLeft(Node("Mie", 6))
    annie = mark.setLeft(Node("Annie", 9))
    annie.setRight(Node("Barnie", 42))

    assert root.left.right.right.left.right.name == "Barnie"
    assert root.left.right.name == "Ann"
    assert root.left.right.left == None
    assert root.left.left.right.left.name == "Mie"

    maxRating, invitedPeople = FindMaxRating(root)

    assert maxRating == 91
    assert [n.name for n in invitedPeople] == ['Rob', 'Mie', 'Ann', 'Annie', 'Barnie']

    print "Max rating for people {" + ", ".join(root.allChildren()) + "}: \n" + str(maxRating)
    print "People invited: "
    print [n.name for n in invitedPeople]

def time_test():
    import timeit

    def r():
        root = Node("Max", -2)
        john = root.setLeft(Node("John", 18))
        mark = john.setRight(Node("Ann", 22)).setRight(Node("Mark", 2))
        rob = john.setLeft(Node("Rob", 12))
        rob.setRight(Node("Bob", 4)).setLeft(Node("Mie", 6))
        annie = mark.setLeft(Node("Annie", 9))
        annie.setRight(Node("Barnie", 42))

        FindMaxRating(root)

    return timeit.timeit(r, number=10000)

if __name__ == "__main__":
    main()
    print "Test passed"