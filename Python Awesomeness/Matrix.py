class Matrix(object):

    class MatrixKeyException(Exception):
        def __init__(self, *args):
            self.message = "Matrix key should be a tuple, either in the form: matrix[1,2] or matrix[(1,2)]"
            super(Exception, self).__init__(self.message)

    class MatrixIndexOutOfBoundException(Exception):
        def __init__(self, arggiven, matrix, *args):
            self.message = "Matrix index out of bound, key given: " + str(arggiven) + " ; real size: " + "(" + str(matrix.n) + ", " + str(matrix.m) + ")"
            super(Exception, self).__init__(self.message)


    def __init__(self, n, m, initvalue=None, outOfBoundValue=Exception):
        self.n = n
        self.m = m
        self.startindex = 0
        self.initvalue = initvalue
        self.outofbound = outOfBoundValue

        self.matrix = {}
        for i in range(self.startindex, n + self.startindex):
            self.matrix[i] = {}
            for j in range(self.startindex, m + self.startindex):
                self.matrix[i][j] = self.initvalue

    def __getitem__(self, key):
        if type(key) == tuple:
            if (key[0] > self.n + self.startindex) or (key[1] > self.m + self.startindex):
                if self.outofbound == Exception:
                    raise self.MatrixIndexOutOfBoundException(key, self)
                    return self.outofbound
                else:
                    return self.outofbound
            return self.matrix[key[0]][key[1]]
        else:
            raise self.MatrixKeyException()

    def __setitem__(self, key, value):
        if type(key) == tuple:
            if (key[0] > self.n + self.startindex) or (key[1] > self.m + self.startindex):
                if self.outofbound == Exception:
                    raise self.MatrixIndexOutOfBoundException(key, self)
                else:
                    print("WARNING: setting out of bound value in indexes: " + str(key))
            self.matrix[key[0]][key[1]] = value
        else:
            raise self.MatrixKeyException()
        
if __name__ == "__main__":

    matrix = Matrix(5, 10, "Initial Value")
    matrix[1,3] = "Pretty matrix"
    print(matrix[3,1])
    print(matrix[1,3])
    print(matrix[3,3])
