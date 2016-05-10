

def getFileContents(filename):
    with open(filename, "r") as f:
        content = f.read()
    return content + "\n\n"

if __name__ == "__main__":

    string = ""
    string += getFileContents("in/help.scm")
    string += getFileContents("in/constructors.scm")
    string += getFileContents("in/predicates.scm")
    string += getFileContents("in/accessors.scm")
    string += getFileContents("in/checkers.scm")

    with open("out.scm", "w") as f:
        f.write(string)

    with open(r"C:\Program Files (x86)\Chez Scheme Version 8.4\bin\i3nt\out.scm", "w") as f:
        f.write(string)

    print("COMPILED")
#(load "E:\SkyDrive\Skole\2016\proglang\uge 4\out.scm")
