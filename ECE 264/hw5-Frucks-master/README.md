# HW5: Sorting student records
## Due Wednesday, 10/6 @ 11:59pm

## Learning Goals 

You will learn
* Read unsorted data from files
* Write sorted data to another file
* Use the C built-in qsort function to sort the data

## Background

This assignment is relatively short: you will learn about using different comparison functions to sort records in different ways. You will also make use of `strcmp`.

### Use qsort to sort the students

C has a built-in function for quick sort. This function sorts an
array.  To use qsort, you need to provide four arguments:

* the address of the first element
* the number of elements
* the size of each element
* the function for comparing elements

The comparison function has three steps

* cast the type from `void *` to the proper type (it is a pointer)
* retrieve the values from the pointer
* compare the values and return negative, zero, or positive numbers

You can find two examples here:

Comparing two elements in an array of integers

https://github.com/yunghsianglu/IntermediateCProgramming/blob/3eee24660f99a641cc2a445733bd154595ff1915/Ch9/compareint.c

Comparing two elements in an array of string

https://github.com/yunghsianglu/IntermediateCProgramming/blob/3eee24660f99a641cc2a445733bd154595ff1915/Ch9/comparestr.c

Please use the numeric difference to compare two IDs.
Please use `strcmp` to compare two names.

`strcmp`s signature is: `int strcmp(const char *s1, const char *s2)`. It takes two char arrays (i.e., strings) and compares them alphabetically. It returns a negative number if the first string is alphabetically earlier, 0 if the two strings are the same, and a positive number if the second string is alphabetically earlier.

> Note that `strcmp` handles capitalization weird: it assumes that all capital letters are alphabetically earlier than all lowercase letters (so "aardvark" is before "zebra" (as expected); "Zebra" is before "aardvark" (because all capital letters come before any lower-case letters); and "Aardvark" is before "Zebra" (because when both letters are capitalized, it goes back to "regular" alphabetical order). In this assignment, you can assume that all names are consistently capitalized, so the weird handling of capitalization doesn't matter.

## What do you need to do?

Your repository starts with several files:
* `student.h`: This file defines a structure named `Student`, and declares several functions
  1. `StudentRead` that reads in students from a file. Note that it returns a newly-allocated
     array of students (`stu`), and the number of students in the array (`numelem`)
  2. `StudentWrite` that writes an array of students to a file.
  3. `StudentPrint` that prints out an array of student records (you can use this to help debug).
  4. `sortStudents` that sorts an array of students based on the comparison function passed in.
* `student.c`: You will need to define several functions (declared in `students.h`)
  to:
  1. Functions to compare students by ID, first name, or last name. The sorts should always be in ascending order (i.e., if you sort by IDs they should increase; if you sort by names, they should go alphabetically from A to Z)
  2. Process an array of students to tell whether it is sorted given a comparison function. 
     > Hint: write a for loop that compares consecutive elements of the array to make sure that they are sorted according to the function. Don't forget to make sure you don't index past the end of the array.
  
     > Hint: get your comparisons working before trying to write this function. Just return `true` so the code runs properly, and visually inspect the outputs to make sure they look sorted. Then write this function once you know your sorts work.
* `hw5.c`: The driver program that reads in student records from a file and sorts them in three ways, writing the results to three output files.

> You only have to write four functions: the three comparison functions and the test function in student.c

Please submit to GitHub as before. Note that you should:

1. `git add` the code that you have changed (suggested use: `git add student.c`)
2. `git commit` to create a new version (suggested use: `git commit -m "some message here"`)
3. `git push` to push the new version to GitHub (suggested use: `git push`)
4. `git tag` to add a tag to that version (suggested use: `git tag final_ver -m "some message here"`)
5. `git push --tags` to push the tags to GitHub (suggested use: `git push --tags`)