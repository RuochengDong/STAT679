#"!/usr/bin/env python"
"""
Description: module with functions to calculate binomial function
Authors: Brian Su, Ruocheng Dong
Date: 10/31/2018
Version: v1.0
"""

# import module that will be used
import math
import argparse

# use an Argument Parser object to handle script arguments
parser = argparse.ArgumentParser()
parser.add_argument("-n", type=int, help="total number of items to choose from")
parser.add_argument("-k", type=int, help="number of items to choose")
parser.add_argument("-l", "--log", action="store_true", help="return the log binomial coefficient")
parser.add_argument("--test", action="store_true", help="tests the module and quits")
args = parser.parse_args()

# define the logfactorial() function
def logfactorial(n, k = 0):
    """
    Calculate log(n!) for k = 0 (the default k = 0) and positive integer n. 
    Calculate log(n!/k!) for non-nagative integer k and positive integer n.
    Examples:

    >>> logfactorial(5)
    4.787491742782046
    >>> logfactorial(5,2)
    4.0943445622221
    >>> logfactorial(5,5)
    0
    >>> logfactorial(5,6)
    'log(1)=0'

    """
    assert type(n) == int and n>=0,"error message: n should be a non-negative integer!"
    assert type(k) == int and k>=0,"error message: k should be a non-negative integer!"
    
    number = 0
    if k == 0:
        for i in range(1, n+1):
            number += math.log(i)
    elif k > n:
        return "log(1)=0"
    else:
        for i in range(k+1,n+1):
            number += math.log(i)

    return number

# define the choose() function
def choose(n, k):
    """
    Returns the binomial coefficient.
    Examples:

    >>> choose(5,3)
    10
    """

    if args.log:
        return logfactorial(n, k)-logfactorial(n-k)
    else:
        return int(round(math.exp(logfactorial(n, k)-logfactorial(n-k)),0))
        

def runTests():
    print("testing the module...")
    if args.n:
        print("ignoring n for testing purposes")
    import doctest
    doctest.testmod()
    print("done with tests.")

if __name__ == '__main__':
    if args.test:
        runTests()
    else:
        print(choose(args.n,args.k))