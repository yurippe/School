
def getFileContents(filename):
    with open(filename, "r") as f:
        content = f.read()
        print("Read file: " + str(filename))
    return content + "\n\n"

def writeFile(filename, content):
    with open(filename, "w") as f:
        f.write(content)
        print("Wrote file: " + str(filename))

if __name__ == "__main__":
    string = ""
    
    string += getFileContents("input\Help.scm")
    string += getFileContents("input\Exercise8.scm")
    string += getFileContents("input\Exercise9.scm")
    string += getFileContents("input\Exercise11.scm")
    string += getFileContents("input\Exercise18.scm")
    string += getFileContents("input\Exercise22.scm")
    string += getFileContents("input\Exercise24.scm")
    string += getFileContents("input\Exercise27Summary.scm")
    #Write out combined result:
    writeFile("Aflevering6.scm", string)

    print("\nCombined files successfully")
