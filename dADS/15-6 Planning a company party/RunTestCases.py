from TestCase1 import main as TestCase1_main
from TestCase2 import main as TestCase2_main
from TestCase3 import main as TestCase3_main

def runTest(test):
    print "##########################"
    print "Running test: " + str(test)
    print "##########################"
    try:
        test()
        print "##########################"
        print "Test passed " + str(test)
        print "##########################"
    except AssertionError as e:
        print "TEST FAILED " + str(test) + ":"
        print "AssertionError"
        print "##########################"
        print "##########################"


runTest(TestCase1_main)
runTest(TestCase2_main)
runTest(TestCase3_main)
