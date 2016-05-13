
##NOTE unpredictable results if doing any mathemathical operation like:
##NINFINITY + INFINITY (will be NINFINITY, while INFINITY + NINFINITY will be INFINITY)

class inf(object):

    def __cmp__(self, other):
        if type(other) == ninf:
            return 1
        elif type(other) == inf:
            return 0
        else:
            return 1


    def __lt__(self, other):
        if self.__cmp__(other) == -1: return True
        else: return False

    def __le__(self, other):
        if self.__cmp__(other) == -1: return True
        elif self.__cmp__(other) == 0: return True
        else: return False
        
    def __eq__(self, other):
        if self.__cmp__(other) == 0: return True
        else: return False

    def __ne__(self, other):
        if self.__cmp__(other) == 0: return False
        else: return True

    def __gt__(self, other):
        if self.__cmp__(other) == 1: return True
        else: return False
    
    def __ge__(self, other):
        if self.__cmp__(other) == 1: return True
        elif self.__cmp__(other) == 0: return True
        else: return False

    def __radd__(self, other):
        return self
    def __add__(self, other):
        return self

    def __sub__(self, other):
        return self
    def __rsub__(self, other):
        return self

    def __mul__(self, other):
        return self
    def __rmul__(self, other):
        return self

    def __div__(self, other):
        return self
    def __truediv__(self, other):
        return self

class ninf(object):

    def __cmp__(self, other):
        if type(other) == inf:
            return -1
        elif type(other) == ninf:
            return 0
        else:
            return -1

    def __lt__(self, other):
        if self.__cmp__(other) == -1: return True
        else: return False

    def __le__(self, other):
        if self.__cmp__(other) == -1: return True
        elif self.__cmp__(other) == 0: return True
        else: return False
        
    def __eq__(self, other):
        if self.__cmp__(other) == 0: return True
        else: return False

    def __ne__(self, other):
        if self.__cmp__(other) == 0: return False
        else: return True

    def __gt__(self, other):
        if self.__cmp__(other) == 1: return True
        else: return False
    
    def __ge__(self, other):
        if self.__cmp__(other) == 1: return True
        elif self.__cmp__(other) == 0: return True
        else: return False

    def __radd__(self, other):
        return self
    def __add__(self, other):
        return self

    def __sub__(self, other):
        return self
    def __rsub__(self, other):
        return self

    def __mul__(self, other):
        return self
    def __rmul__(self, other):
        return self

    def __div__(self, other):
        return self
    def __truediv__(self, other):
        return self

INFINITY = inf()
NINFINITY = ninf()
        

if __name__ == "__main__":

    
    assert not INFINITY < 10.1
    assert INFINITY > 10

    assert NINFINITY < 10
    assert not NINFINITY > 10

    assert INFINITY > NINFINITY
    assert NINFINITY < INFINITY
    assert not INFINITY == NINFINITY

    assert NINFINITY == NINFINITY
    assert INFINITY == INFINITY

    assert min(INFINITY, NINFINITY, 10, -10) == NINFINITY
    assert max(INFINITY, NINFINITY, 10, -10) == INFINITY

    assert INFINITY + 1 == INFINITY
    assert INFINITY - 1 == INFINITY

    assert NINFINITY + 1 == NINFINITY
    assert NINFINITY - 1 == NINFINITY

    assert INFINITY * 5 == INFINITY
    assert NINFINITY / 5 == NINFINITY

    print("Passed assertion tests")
