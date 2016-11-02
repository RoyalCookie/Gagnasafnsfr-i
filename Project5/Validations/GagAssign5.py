def generateTests():
    stringArr = []
    inputString = ""
    db = input()
    while inputString != "quit":
        inputString = input()
        if inputString != "quit":
            stringArr.append(inputString)

    querryString = ("SELECT '%key --> %value' AS FD, CASE WHEN COUNT(*) = 0 THEN 'HOLDS' ELSE 'DOES NOT HOLD' END AS VALIDITY\n"
     "FROM (\n"
     "SELECT %key, COUNT(DISTINCT %value)\n"
     "FROM %db\n"
     "GROUP BY %key\n"
     "HAVING COUNT(DISTINCT %value) > 1\n"
     ") X;")

    for s in stringArr:
        v = s.split()
        print(querryString.replace("%key", v[0]).replace("%value", v[1]).replace("%db", db))

generateTests()