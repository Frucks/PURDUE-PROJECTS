#!/usr/bin/python3
import math
n = 21
# Your code should be below this line

m = 13

year = 2022 - 1

k = year % 100

j = year // 100

h = (n  + 13 * (m + 1) // 5 + k + k // 4 + j // 4 + 5 * j) % 7

if n >= 1 and n <= 31:
    if h == 0 or h == 1:
        print("Weekend")
    else:
        print("Weekday")
else:
    print("Not Valid")