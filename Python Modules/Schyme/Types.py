Symbol = str
List = list
Number = (int, float)
Boolean = bool

class String(object):
    def __init__(self, s):
        self.s = s

class SchemePair(object):

    def __init__(self, _left=None, _right=None):
        self.car = _left
        self.cdr = _right


    def __len__(self):
        if self.cdr == []:  #null
            return 1
        elif isinstance(self.cdr, SchemePair):
            return 1 + self.cdr.__len__()
        else:
            raise SyntaxError("Exception in length: " + str(self) + " is not a proper list")

    def __getitem__(self, key):
        if isinstance(key, slice):
            plist = self.toPythonList()
            return plist[key.start:key.stop:key.step]
        else:
            plist = self.toPythonList[key]

    def __eq__(self, other):
        if isinstance(other, list):
            if other == []: return False
            return other == self.toPythonList()
        elif isinstance(other, SchemePair):
            if self.car == other.car:
                return self.cdr == other.cdr
        else:
            return NotImplemented

    def __ne__(self, other):
        result = self.__eq__(other)
        if result is NotImplemented:
            return result
        return not result

    def isProperList(self):
        if self.car == [] and self.cdr == None: #our chosen representation of the empty list
            return True
        elif self.cdr == []:
            return True
        elif isinstance(self.cdr, SchemePair):
            return self.cdr.isProperList()
        else:
            return False

    @staticmethod
    def schemeNull():
        return []


    @staticmethod
    def fromPythonList(pythonList):
        if len(pythonList) == 0: return SchemePair.schemeNull()
        p = SchemePair(pythonList[0])
        q = p
        for element in pythonList[1:]:
            q.cdr = SchemePair(element)
            q = q.cdr
        q.cdr = []
        return p

    def toPythonList(self):
        if self.isProperList():
            if self.car == None and self.cdr == None:
                return []
            else:
                result = []
                c = self
                while isinstance(c, SchemePair):
                    result.append(c.car)
                    c = c.cdr
                if c == []:
                    return result
                else:
                    raise SyntaxError("List: " + str(self) + " is not a proper list")

        else:
            raise SyntaxError("List: " + str(self) + " is not a proper list")

class SchemeNull(object):
    def __call__(self):
        return []