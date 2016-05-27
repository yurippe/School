from SchymeExceptions import ParserError
from Types import *

class Parser(object):
    
    def __init__(self, debug=False):
        self.debug = debug

    def stripComments(self, string):
        i = 0
        checkPoint = 0
        waitForNextLB = False
        finalString = ""
        while i < len(string):
            if waitForNextLB:
                if string[i] == "\n":
                    waitForNextLB = False
                    checkPoint = i
                    continue
                else:
                    i += 1
                    continue
                
            if string[i] == ";":
                finalString += string[checkPoint:i]
                i += 1
                waitForNextLB = True
                continue

            i += 1
        if checkPoint < i:
            finalString += string[checkPoint:i]
        return finalString

    def tokenize(self, string):
        string = string.replace("\r", " ")
        string = string.replace("\n", " ")
        string = string.replace("\t", " ")
        string = string.replace("(", " ( ")
        string = string.replace(")", " ) ")
        string = string.replace("[", " ( ")
        string = string.replace("]", " ) ")
        string = string.replace("'", " ' ")
        if self.debug: print(string.split())
        return string.split()

    def _atomize(self, token):
        try:
            atom = int(token)
            return atom
        except ValueError: pass
        try:
            atom = float(token)
            return atom
        except ValueError:
            pass
        try:
            atom = Symbol(token)
            return atom
        except ValueError: pass

        raise ParserError("Didn't understand token") #this wont happen, since token already is a string
    
    def _read_tokens(self, tokens):
        if len(tokens) == 0:
            #Unexprected End Of File
            raise ParserError("Unexpected EOF while reading")
        tok = tokens.pop(0)
        if tok == ")":
            raise ParserError("Unexpected ')'")

        elif tok == "(":
            tmp = []
            while not tokens[0] == ")":
                tmp.append(self._read_tokens(tokens))
            tokens.pop(0)
            return tmp
        else:
            return self._atomize(tok)
        
    def parse(self, string):
        tokens = self.tokenize(self.stripComments(string))
        r = []
        while len(tokens) > 0:
            r.append(self._read_tokens(tokens))
        if self.debug:
            print ("----Tokens----")
            print r
        return r
