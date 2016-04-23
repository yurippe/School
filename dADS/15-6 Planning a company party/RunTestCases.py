from TestCase1 import main as TestCase1_main
from TestCase1 import time_test as TestCase1_time

from TestCase2 import main as TestCase2_main
from TestCase2 import time_test as TestCase2_time

from TestCase3 import main as TestCase3_main
from TestCase3 import time_test as TestCase3_time

from TestCase4 import main as TestCase4_main
from TestCase4 import time_test as TestCase4_time

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

def timeTest(test):
    print "Timed " + str(test) + ":" + str(test())

runTest(TestCase1_main)
runTest(TestCase2_main)
runTest(TestCase3_main)
runTest(TestCase4_main)

print "################ Time Tests: ################"
print "Test Case 1 (14 nodes)"
timeTest(TestCase1_time)
print "Test Case 2 (3 nodes)"
timeTest(TestCase2_time)
print "Test Case 3 (4 nodes)"
timeTest(TestCase3_time)
print "Test Case 4 (9 nodes)"
timeTest(TestCase4_time)