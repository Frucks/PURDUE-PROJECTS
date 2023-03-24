import re

def problem1(searchstring):
    """
    Match phone numbers.

    :param searchstring: string
    :return: True or False
    +52 (XXX) XXX-XXXX
    +52 XXX-XXX-XXXX
    +52 XXXXXXXXXX
    XXX-XXXX
    """

    search1 = re.fullmatch(r'(\+(1|52)\s(((\(\d{3}\)\s)|(\d{3}\-)))\d{3}\-\d{4})|(\d{10})|(\d{3}\-\d{4})', searchstring)

    if (search1):
        return True;
    else:
        return False;

    pass
        
def problem2(searchstring):
    """
    Extract street name from address.

    :param searchstring: string
    :return: string
    """
    search2 = re.compile("(\d+\s([A-Z]([a-z])*\s)+)((Rd\.)|(Dr\.)|(Ave\.)|(St\.))")
   
    return(search2.search(searchstring).group(1).strip())

    pass
    
def problem3(searchstring):
    """
    Garble Street name.

    :param searchstring: string
    :return: string
    """

    search3 = re.compile("(\d+\s)(([A-Z]([a-z])*\s)+)((Rd\.)|(Dr\.)|(Ave\.)|(St\.))")

    search4 = re.compile("(\d+\s([A-Z]([a-z])*\s)+)((Rd\.)|(Dr\.)|(Ave\.)|(St\.))")

    if search3.search(searchstring):
        name = search3.search(searchstring).group(2).strip()
        rev = name[::-1]
        string = str(search3.search(searchstring).group(1) + rev + " ")
        replaced = re.sub(search4.search(searchstring).group(1), string, searchstring)

    return replaced
    pass


if __name__ == '__main__' :
    print("\nProblem 1:")
    print("Answer correct?", problem1('+1 765-494-4600') == True)
    print("Answer correct?", problem1('+52 765-494-4600 ') == False)
    print("Answer correct?", problem1('+1 (765) 494 4600') == False)
    print("Answer correct?", problem1('+52 (765) 494-4600') == True)
    print("Answer correct?", problem1('+52 7654944600') == True)
    print("Answer correct?", problem1('494-4600') == True)

    print("\nProblem 2:")
    print("Answer correct?",problem2('Please flip your wallet at 465 Northwestern Ave.') == "465 Northwestern")
    print("Answer correct?",problem2('Meet me at 201 South First St. at noon') == "201 South First")
    print("Answer correct?",problem2('Type "404 Not Found St" on your phone at 201 South First St. at noon') == "201 South First")
    print("Answer correct?",problem2("123 Mayb3 Y0u 222 Did not th1nk 333 This Through Rd. Did Y0u Ave.") == "333 This Through")
    print("\nProblem 3:")
    print("Answer correct?",problem3('The EE building is at 465 Northwestern Ave.') == "The EE building is at 465 nretsewhtroN Ave.")
    print("Answer correct?",problem3('Meet me at 201 South First St. at noon') == "Meet me at 201 tsriF htuoS St. at noon")
