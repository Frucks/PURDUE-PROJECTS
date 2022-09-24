# Homework 4: QSort

### Due 9/26 at 11:59pm 

## Learning Goals 

In HW3 you've learned how to read and write file in C program.
You will continue to use the file operation function in this assignment.

This assignment asks you to write a program that uses *qsort*
to sort an array of integers in the ascending order.

You will learn to
* Count the number of integers in a file
* Allocate memory (an array) to store the integers
* Read integers from the file and store them in the array
* Call `qsort` function to sort the integers
* Release memory
* Check memory error using `valgrind`
* Write the sorted array to another file

## Background

### **1. Dynamic memory allocation**

In this assignment, you will use `malloc` function to allocate dynamic function.

`void * malloc(size_t size)` allocates the requested memory, and returns a pointer to it,
or returns NULL if the allocation fails.

You should always deallocate the memory with the `void free(void *ptr)` function when you are done using the memory.

* For example, `int * arr = (int *) malloc(10 * sizeof(int));` allocates the memory for 10 integers, 
and `free(arr)` releases the allocated memory.

You will use the `valgrind` tool to debug memory, and detect memory leak.
Check [this page](http://cs.ecs.baylor.edu/~donahoo/tools/valgrind/messages.html) for the various types of errors that you may have.

* For example, to use a valgrind to check a program hw4 for memory errors with input file `filename`, run the following command:

`> valgrind --tool=memcheck --leak-check=full ./hw4 filename`


### **2. QSort**

QSort is a generic function in C for sorting arrays. 
In this assignment, you will not need to implement the qsort function.
Instead, you will need to read the [`qsort` function](https://linux.die.net/man/3/qsort)
and understand how to use this `qsort` function. The QSort algorithm is based on recusion.
You will learn the algorithm later when we discuss recussion in class.


## What do you need to do?

You need to complete the following functions:
 * `int main(int argc, char * * argv)` in main.c, this file contains your `main` function, which gets the names of
  the input and output files from the command line (`argv[1]` and `argv[2]`), allocate memory, and calls `qsort`.
 * `int countInt(char* filename)` in hw4.c
 * `bool readInt(char* filename, int * intArr, int size)` in hw4.c
 * `bool writeInt(char* filename, int * intArr, int size)` in hw4.c
 * `int compareInt(const void *p1, const void *p2)` in hw4.c

## Grading

You will receive zero if your program has error or warning from `gcc`.

You will lose 1 point for every 1 byte of memory leak. In other words, if your program leaks 100 or more bytes, you will **receive zero**.

You will receive zero if your program terminates abnormally (e.g., segmentation fault).

You will lose 1 point for every error detected by valgrind even though the program continues.

The grading will be based on the test cases run by the teaching staffs. 
Your score is proportional to the number of test cases that your program passes. 
Passing means the program returns EXIT_SUCCESS and provides correct outputs that match the expected outputs.

You **must** follow the instructions precisely. Failing to follow
these instructions will likely make you receive zero in this
assignment.
