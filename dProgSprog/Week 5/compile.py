
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
    string += getFileContents("input\Exercise4.scm")
    string += getFileContents("input\Exercise9a.scm")
    string += getFileContents("input\Exercise9b.scm")
    string += getFileContents("input\Exercise9c.scm")
    string += getFileContents("input\Exercise9d.scm")
    string += getFileContents("input\Exercise9e.scm")
    string += getFileContents("input\Exercise9f.scm")
    string += getFileContents("input\Exercise17.scm")
    string += getFileContents("input\Exercise25.scm")
    string += getFileContents("input\Exercise29.scm")
    string += getFileContents("input\Exercise46.scm")
    string += getFileContents("input\Exercise48.scm")
    string += getFileContents("input\Exercise64Summary.scm")
    #Write out combined result:
    writeFile("Aflevering5.scm", string)

    print("\nCombined files successfully")
