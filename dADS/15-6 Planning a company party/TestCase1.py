from Node import Node
from FindMaxRating import FindMaxRating

def main():
    #Test case 1

    root = Node("Max", 23)
    john = root.setLeft(Node("John", 18))
    mark = john.setRight(Node("Ann", 22)).setRight(Node("Mark", 2))
    rob = john.setLeft(Node("Rob", 12))
    rob.setRight(Node("Bob", 4)).setLeft(Node("Mie", 6))
    rob.setLeft(Node("Steven", 3)).setRight(Node("Sarah", 2))

    annie = mark.setLeft(Node("Annie", 9))
    annie.setRight(Node("Barnie", 42))
    annie.setLeft(Node("Malcolm", 7)).setRight(Node("Susan", 5)).setRight(Node("Terry", 4))

    assert root.left.right.right.left.right.name == "Barnie"
    assert root.left.left.left.name == "Steven"
    assert root.left.right.name == "Ann"
    assert root.left.right.left == None
    assert root.left.left.right.left.name == "Mie"

    maxRating, invitedPeople = FindMaxRating(root)

    assert maxRating == 109
    assert [n.name for n in invitedPeople] == ['Steven', 'Sarah', 'Mie', 'John', 'Ann', 'Malcolm', 'Susan', 'Terry', 'Barnie']

    print "Max rating for people {" + ", ".join(root.allChildren()) + "}: \n" + str(maxRating)
    print "People invited: "
    print [n.name for n in invitedPeople]



if __name__ == "__main__":
    main()
    print "Test passed"