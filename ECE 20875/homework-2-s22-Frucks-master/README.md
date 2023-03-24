# Homework 2: Data Structures in Python

### Due Friday, 02.28.2022 at 11:59 PM ET

## Goals

This homework has several objectives:

1. Write some basic Python programs.
2. Get familiar with the different data structures available in Python.
3. Leverage the concept of functions to write modular code.

## Instructions

In this homework, you need to write two Python functions, one per problem described below. Both of these function definitions are provided to you in `homework2.py`. `testhisto.py` and `testname.py` can be used by you to execute your functions in `homework2.py`. We have provided you with some test cases, you may make your own test case and execute to make sure your code runs properly.

### Problem 1

Create a function called `histogram` that takes as input a dataset `data`, a lower bound `b`, an upper bound `h`, and a number of bins `n`, and returns a histogram representation of `data` with `n` bins between these bounds. More specifically, your function should:

1. Have input arguments `histogram(data, n, b, h)`, expecting `data` as a list of floats, `n` as an integer, and `b` and `h` as floats.
2. Print the error message `b and h are the same value` and return an empty list if b and h are the same number (the width of the histogram is 0)
3. If b is larger than h, re-assign b to h and h to b.
4. If n is equal to 0, return an empty list
5. Initialize the histogram `hist` as a list of `n` zeros.
6. Calculate the bin width as `w = (h-b)/n`, so that `hist[0]` will represent values in the range `(b, b + w)`, `hist[1]` in the range `[b + w, b + 2w)`, and so on through `hist[n-1]`. (Remember that `[` is inclusive while `)` is not!). 
7. Ignore any values in `data` that are less than or equal to `b` and greater than or equal to `h`. *Remember if you have changed `h` and 'b' in step 3, you would need to work with the new value of `h` and 'b'.
8. Increment `hist[i]` by 1 for each value in `data` that belongs to bin `i`, i.e., in the range `[b + i*w, b + (i+1)*w)`.
9. Return `hist`.

At the beginning of your function, be sure to check that `n` is a positive integer; if not, your code should just return an empty list for `hist`. Please remember to return an empty list. 

For example, typing in

```
data = [-2, -2.2, 0, 5.6, 8.3, 10.1, 30, 4.4, 1.9, -3.3, 9, 8]
hist = histogram(data, 15, -5, 10)
print(hist)
```

should return

```
[0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 2, 1]
```
Some other test cases are:
 
```
data = [-4, -3.2, 0, 7.6, 1.0, 2.2, 30, 2.2, 1.9, -8.3, 6, 5]
hist = histogram(data, 10, 10, 0)
print(hist)
```

should return

```
[0, 2, 2, 0, 0, 1, 1, 1, 0, 0]
```
and,
```
data = [2,2,2]
hist = histogram(data, 5, -2, 3)
print(hist)
```
returns
```
[0, 0, 0, 0, 3]
```
also, 
```
data = [-1,-1,-1,10,10]
hist = histogram(data, 5, -1, 10)
print(hist)
```
returns 
```
[0, 0, 0, 0, 0]
```
Note: Please include all conditions specified in this problem into your code. 

### Problem 2

Create a function called `happybirthday` that takes as input three dictionaries, `name_to_day`, `name_to_month`, and `name_to_year`, and combines them into a single dictionary `month_to_all` that contains the month as the `key` and the `name, (day, year, age)` as the `value` of the `month_to_all` dictionary. For this problem, you may assume that the current year is 2022 - i.e. age = 2022 - year. Specifically, your function should:

1. Have input arguments `happybirthday(name_to_day, name_to_month, name_to_year)`, expecting `name_to_day` as a dictionary mapping a name (string) to a day in the month (integer), `name_to_month` as a dictionary mapping a name (string) to a month (integer)and `name_to_year` as a dictionary mapping a name to a year(integer). You may assume all inputs to be valid.
2. Create a new dictionary `month_to_all` where the keys are all the months contained in `name_to_month` (note: if a month does not appear in 'name_to_month', it should not be included in 'month_to_all'), and contains information in the following structure `name, (day, year, age)`, with `(day, year, age)` being the tuple of values from `name_to_day`, and `name_to_year` corresponding to `name`. **Note**: the *value* we want in this new dictionary is a *tuple*, where the first element of the tuple is the name from 'name_to_month' and the second element of the tuple is a *tuple* of `day, year, age`. 
3. Return `month_to_all`.

For example, typing in

```
name_to_day={'jack':14,'helen':2,'zach':20}
name_to_month={'jack':4,'helen':2,'zach':10}
name_to_year={'jack':2014,'helen':2002,'zach':1969}
```

should return

```
{'4': ('jack', (14, 2014, 8)), '2': ('helen', (2, 2002, 20)), '10': ('zach', (20, 1969, 53))}
```
*Note that the integer values for each month are not in ascending order: dictionaries are unordered data structures, and do not have a set 'order' for keys. Your output may be in a different order than the examples provided, and that is ok.*

also,
```
name_to_day={'Stive':24,'Bill':28,'Elon':28,'Jeff':12,'Mark':14}
name_to_month={'Stive':2,'Bill':11,'Elon':6,'Jeff':1,'Mark':5}
name_to_year={'Stive':1955,'Bill':1955,'Elon':1971,'Jeff':1964,'Mark':1984}
```
should output

```
{'2': ('Stive', (24, 1955, 67)), '11': ('Bill', (28, 1955, 67)), '6': (Elon, (28, 1971, 51)), '1': ('Jeff', (12, 1964, 58)), '5': ('Mark', (14, 1984, 38))}
```

*Each dictionary key will have only ONE associated value*

## Testing

We have provided two test programs for you, that recreate the examples from above, in `testhisto1.py`, `testhisto2.py`, `testhisto3.py`,`testhisto4.py`, `testname1.py` and `testname2.py`, which test problems 1 and 2, respectively. Note that these test programs will only work "out of the box" if you have your solution in `homework2.py`. You may verify your code by running the test programs from the terminal. The concept of importing functions from modules or `.py` files are being used here.


## What to Submit

Put the two functions `histogram` and `happybirthday` in a single file called `homework2`.

Once you have a version of this file (that you have `commit`ted using `git commit` and `push`ed using `git push`) that you are happy with, you are done!
Sit back, relax and enjoy your lectures :)
