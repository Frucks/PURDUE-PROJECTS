# Homework 1: Who Gets the Cake

### Due 9/7 at 11:59pm 

## Learning Goals 

In this homework, you will get familiar with arrays.

## Background

For this homework, you will work on a problem named "who gets the cake".
Let's start with the introduction of this problem.
Imagine that there is a piece of cake and several people want it. They decide who can have it
by playing a game: They form a circle and choose an integer k greater
than one. They count 1, 2, 3, ..., k. The k-th person is eliminated.
They keep counting until only one person is left. This person who is left gets the
cake.

Please notice that there are different definitions of this
problem. *Your solution must follow the definition here.*  More
precisely, this is how the method works: There are n people (n is an integer),
represented by n elements in an array. The elements are counted as
1, 2, 3, ... When the value k is counted, this element is removed in
future counting and the next element starts as 1 again. When reaching
the end of the array, the counting *wrap around* to the beginning of
the array (skipping the elements that have already been eliminated).
Please notice that in C arrays, indexes *always* start at zero but in
this problem counting starts at one. Both n and k have to be greater
than one. *It is possible that k is greater than n.*

## Array quick review

Arrays are sequences of data types laid out next to each other in memory. C treats
array data types specially, allowing you to access them by *indexing* from a base expression:

```
int a[10]; //10 integers next to each other
a[0] = 5; //access the first integer
a[9] = 10; //access the 10th integer
```

Remember that the first element of an array is at index `0`, and the last element
of an array is at index `size - 1`.

Note that if you don't know the size of the array ahead of time, you can
*dynamically allocate* the array:

```
int * a = malloc(20 * sizeof(* a)); //allocate an array of 20 integers
a[4] = 20; //access the fifth integer
```

Do not worry if the syntax of the first line looks mysterious. We will explain it
in detail when we discuss pointers and memory allocation. For now, just rely on
this making an array of 20 integers!

### Examples
* The following is an example when the array has 6 elements (n is 6) and
k is 3. The eliminated elements in each round are mared by `X`.  The
elements eliminated earlier are marked by `Y`.


array index | 0 | 1 | 2 | 3 | 4 | 5 
------------|---|---|---|---|---|---
count       | 1 | 2 | X | 1 | 2 | X 


array index | 0 | 1 | 2 | 3 | 4 | 5 
------------|---|---|---|---|---|---
count       | 1 | 2 | Y | X | 1 | Y 


array index | 0 | 1 | 2 | 3 | 4 | 5 
------------|---|---|---|---|---|---
count       | 2 | X | Y | Y | 1 | Y 

array index | 0 | 1 | 2 | 3 | 4 | 5
------------|---|---|---|---|---|---
count       | 2 | Y | Y | Y | X | Y

The element of index 0 is left.

* This is the second example. The array has 4 elements (n is 4) and k is 6. This is an example where k is greater than n.

array index | 0 | 1 | 2 | 3 
------------|---|---|---|---
count       | 1 | 2 | 3 | 4 

array index | 0 | 1 | 2 | 3 
------------|---|---|---|---
count       | 5 | X | 1 | 2 

array index | 0 | 1 | 2 | 3 
------------|---|---|---|---
count       | 3 | Y | 4 | 5 

array index | 0 | 1 | 2 | 3 
------------|---|---|---|---
count       | X | Y | 1 | 2 

array index | 0 | 1 | 2 | 3 
------------|---|---|---|---
count       | Y | Y | 3 | 4 

array index | 0 | 1 | 2 | 3 
------------|---|---|---|---
count       | Y | Y | 5 | X 

The element of index 2 is left.

* This is the third example. The array has 25 elements (n is 25) and k is 7.

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | 1 | 2 | 3 | 4 | 5 | 6 | X | 1 | 2 | 3 | 4  | 5  | 6  | X  |  1 | 2  |  3 |  4 | 5  | 6  | X  |  1 | 2  |  3 |  4 


array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | 5 | 6 | X | 1 | 2 | 3 | Y | 4 | 5 | 6 | X  |  1 | 2  | Y  |  3 | 4  | 5  | 6  |  X |  1 | Y  |  2 | 3  | 4  |  5

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | 6 | X | Y | 1 | 2 | 3 | Y | 4 | 5 | 6 | Y  | X  | 1  | Y  | 2  | 3  | 4  | 5  |  Y |  6 | Y  |  X | 1  | 2  |  3

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | 4 | Y | Y | 5 | 6 | X | Y | 1 | 2 | 3 | Y  | Y  | 4  | Y  | 5  | 6  | X  | 1  | Y  |  2 | Y  |  Y | 3  | 4  |  5

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | 6 | Y | Y | X | 1 | Y | Y | 2 | 3 | 4 | Y  | Y  | 5  | Y  | 6  | X  | Y  | 1  | Y  |  2 | Y  |  Y | 3  | 4  |  5

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | 6 | Y | Y | Y | X | Y | Y | 1 | 2 | 3 | Y  | Y  | 4  | Y  | 5  | Y  | Y  | 6  | Y  | X  | Y  |  Y | 1  | 2  |  3

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | 4 | Y | Y | Y | Y | Y | Y | 5 | 6 | X | Y  | Y  | 1  | Y  | 2  | Y  | Y  | 3  | Y  | Y  | Y  |  Y | 4  | 5  |  6

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | X | Y | Y | Y | Y | Y | Y | 1 | 2 | Y | Y  | Y  | 3  | Y  | 4  | Y  | Y  | 5  | Y  | Y  | Y  |  Y | 6  | X  |  1

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | 2 | 3 | Y | Y  | Y  | 4  | Y  | 5  | Y  | Y  | 6  | Y  | Y  | Y  |  Y | X  | Y  |  1

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | 2 | 3 | Y | Y  | Y  | 4  | Y  | 5  | Y  | Y  | 6  | Y  | Y  | Y  |  Y | Y  | Y  |  X

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | 1 | 2 | Y | Y  | Y  | 3  | Y  | 4  | Y  | Y  | 5  | Y  | Y  | Y  |  Y | Y  | Y  |  Y

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | 6 | X | Y | Y  | Y  | 1  | Y  | 2  | Y  | Y  | 3  | Y  | Y  | Y  |  Y | Y  | Y  |  Y

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | 4 | Y | Y | Y  | Y  | 5  | Y  | 6  | Y  | Y  | X  | Y  | Y  | Y  |  Y | Y  | Y  |  Y

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | 1 | Y | Y | Y  | Y  | 2  | Y  | 3  | Y  | Y  | Y  | Y  | Y  | Y  |  Y | Y  | Y  |  Y

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | 4 | Y | Y | Y  | Y  | 5  | Y  | 6  | Y  | Y  | Y  | Y  | Y  | Y  |  Y | Y  | Y  |  Y

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | X | Y | Y | Y  | Y  | 1  | Y  | 2  | Y  | Y  | Y  | Y  | Y  | Y  |  Y | Y  | Y  |  Y

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y  | Y  | 3  | Y  | 4  | Y  | Y  | Y  | Y  | Y  | Y  |  Y | Y  | Y  |  Y

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y  | Y  | 5  | Y  | 6  | Y  | Y  | Y  | Y  | Y  | Y  |  Y | Y  | Y  |  Y

array index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
------------|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----
count       | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y  | Y  | X  | Y  | 6  | Y  | Y  | Y  | Y  | Y  | Y  |  Y | Y  | Y  |  Y

The element of index 14 is left.

The table uses `X` and `Y` for clarity.  Your program should use only `X`.



## What do you need to do?

Write the `eliminate` function in `eliminate.c` to print the index of the eliminated elements *in order*.

In the first example (n=6, k=3), the output is
```
2
5
3
1
4
0
```

In the second example (n=4, k=6), the output is

```
1
0
3
2
```

In the third example (n=25, k=7), the output is

```
6
13
20
2
10
18
1
11
21
5
16
3
15
4
19
9
0
23
22
24
8
17
7
12
14
```

The function is called `eliminate`, not `select` because `select` is a
C function for communication. If you want to know the definition of
the `select` function, search `Linux manual select`.

**Testing:** You are given the expected output for the three examples discussed above.
Feel free to create more to test your program.

In the provided Makefile, you will use the `diff` command to compare between your output
and the expected output.

The `diff` command: `diff $YOUR_OUTPUT $EXPECTED_OUTPUT` displays the differences between the
two files line-by-line. When the two files are identical, `diff` will be silent.


Grading
==========

You will receive zero if your program has error or warning from `gcc`.

The grading will be based on the test cases run by the teaching staffs. Your score is proportional
to the number of test cases that your program passes. Passing means the program returns `EXIT_SUCCESS` 
and provides correct outputs that match the expected outputs.

Additional reading
==================

A mathematical question is to determine which element is left
*without* counting 1, 2, ...  If you are interested in this topic,
please read the book Concrete Mathematics by Ronald L. Graham, Donald
E. Knuth, and Oren Patashnik.

Is this a real problem? Is there any real application? Yes. In
distributed systems (such as the Internet), sometimes different
machines need to agree on something. For example, a group of machines
want to find one representative for external communication. 

History
=======

This problem is inspired by the "Josephus problem".  History (based on
Wikipedia): Flavius Josephus and 40 soldiers were trapped in a cave by
Roman soldiers. They chose suicide over capture, and decided the order
is determined by the following method: they form a circle and set an
integer k greater than one.  Then, the group starts with 1, 2, ... The
person that counts k is eliminated.  The process continues until all
are eliminated.  The question is where Josephus should stand at the
beginning so that he is the last remaining person.
