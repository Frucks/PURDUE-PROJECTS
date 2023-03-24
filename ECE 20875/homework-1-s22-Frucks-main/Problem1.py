#!/usr/bin/python3
import math
number = 100
# Your code should be below this line

if (number % 2 == 0 and number >= 0) and ((math.sqrt(5 * number ** 2 + 4) % 1 == 0) or (math.sqrt(5 * number ** 2 - 4) % 1 == 0)):
    print("Yes")
else:
    print("No")