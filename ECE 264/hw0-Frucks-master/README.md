# Homework 0: `git` and `make` and `gcc`, Oh My!

### Due 8/29 at 11:59pm

## Goals

This homework serves several purposes:

1. Get you familiar with the homework submission system, which uses `git`
2. Get you familiar with using `make` to build, run, and test your programs
3. Get you familiar with some `gcc` options including conditional compilation

## Background

### Unix environments

The build and test environments that the course staff will use when grading your homeworks are Unix-based. In particular, we will be building and testing your code on `ecegrid` machines, which you can `ssh` to using the following command:

```
> ssh ecegrid.ecn.purdue.edu
```

> **See below for details on SSH**

You can also use ThinLinc to access the `ecegrid` machines. Through your web browser, you can go to [https://ecegrid.ecn.purdue.edu/main/](https://ecegrid.ecn.purdue.edu/main/), or you can download the desktop client.

If you are using Linux or macOS, you already have access to a Unix-like environment, which will let you develop your code in an environment similar to the test environment. If you are using Windows, we recommend installing the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

> Note that these environments do not have exactly the same versions of compilers, etc., that 
>`ecegrid` does. For the kinds of programs we are developing in this class, it should not matter. 
>Nevertheless, you are responsible for making sure that your code runs properly in our test environment.

### ssh

You will be using the tool `ssh` (Secure Shell) in a couple of different ways in this class. You may be using it to connect remotely to `ecegrid`. You may (should) also be using it to connect to GitHub to develop and submit assignments. If you have a Unix environment set up, you will also have `ssh` installed, so you can use it immediately. You may also choose to install a tool like [https://www.putty.org](https://www.putty.org).

### git and GitHub

Our homework submission system is built around [GitHub Classroom](https://classroom.github.com). What this means is that your homeworks will be distributed as *git repositories*, and you will submit your homework by ``push''ing your code to GitHub. Part of the goal of this homework is to familiarize yourself with this process.

But even if we weren't using Github classroom, you should *still* use *version control* like git. Version control, especially backed by a cloud provider like GitHub gives you several benefits:

1. Being able to reverse changes you've made to a program if you made a mistake
2. Having a backed-up version of your program in case your computer crashes or storage fails
3. Being able to collaborate with other people [this one doesn't matter so much for this course]

The key feature of version control is that it maintains multiple *versions* of each file you have in your "repository." When you make a change to a file, like `foo.c`, you can tell `git` that you want to track the changes to the file:

```
> git add foo.c
```

You can add multiple changed files to a version:

```
> git add bar.c
```

And when you ready to "commit" the new version, you can tell `git` to do so:

```
> git commit -m "some message describing the changes"
```

Note that until you run `git commit`, there is no "new" version of either `foo.c` or `bar.c` created.

If you then make more changes to `foo.c`, *git remembers the old version, too*, and you can get back to it by either reverting the changes you've made, or explicitly "checking out" the older versions. If you're interested in the details of `git`, we recommend the guides at either [GitHub](https://guides.github.com/) or [Atlassian](https://www.atlassian.com/git). 

> Those of you that really want to dig into how `git` manages versions might find Atlassian's pages on (the three trees of git)[https://www.atlassian.com/git/tutorials/undoing-changes/git-reset] and (the different ways of managing versions)[https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting]

You can create as many versions of your code as you want. We recommend `add`ing and `commit`ing your changes fairly frequently -- whenver you figure out one part of your code, for example -- to make sure that you don't lose work or accidentally delete important changes.

If your repository has a version stored *remotely*, like at GitHub, then you can further take advantage of `git`'s ability to manage copies of code in multiple places. You can get a copy (a "clone") of the repository by running:

```
> git clone [url]
```

Then you can manage versions using `add` and `commit` like above. When you're ready to update the remote copy of your code, you can "push" your local changes to GitHub using:

```
> git push
```

This syncs up your local repository with GitHub, which means that your code is now safely on the cloud. We recommend `push`ing often -- certainly whenever you get one part of the assignment "solved."

Note that if there are updates to your assignment code on GitHub that you don't have on your local copy (say, if you're working on multiple computers), you can update your *local* repository by typing:

```
> git pull
```

One of the ways that `git` and `ssh` interact is that you can use *SSH keypairs* to authenticate with GitHub (in fact, as of this August, you cannot use a regular password to authenticate `push`es and `pull`s). You can see instructions for setting up SSH authentication [here](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).

### gcc

A compiler is the tool that translates the source code you write (the C program) into the machine code your computer understands. You will be getting very familiar with compilers in this course (and you should take ECE 46800 if you want to learn more!)

While to a large extent the code we write will not depend hugely on *which* C compiler you use, the compiler we will use to build and test your code is `gcc`. (Other popular compilers include `llvm` and Microsoft Visual C, or `msvc`.)

gcc takes one or several `.c` files as input. If you want to specify the output file's name add `-o name`
If you do not specify the name, the default output file is called `a.out`.

If you read the manual (also called the "man page") of `gcc`, you can find many options. In this class, you should always use `gcc` in the following way.

`> gcc -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror`

* `-std=c99` means using the C standard announced in 1999
* `-g` means enabling debugging
* `-Wall` means enable warning messages
* `-Wshadow` means detect the use of shadow variables
* `-pedantic` means restricting standard C
* `-Wvla` means detecting the use of variable length arrays
* `-Werror` means treating warnings as errors (so your program will not compile)

These warnings are your first "line of defense" in writing good programs. There have been many cases when students forgot to use these options, failed to detect these problems early, and spent many hours debugging.

Here are some common warning messages:

* Creating a variable but never using it (most likely it is mistyped)
* Creating a function but never using it (most likely it is mistyped)
* Reading  a variable before a value is assigned (C does not initialize variables. If a variable is not assigned, its value is garbage, not necessarily zero)
* Writing code that can never be reached
* Assigning a value to a wrong type
* Creating two variables that have overlapping scopes (called shadow variables)

While many of these issues are not necessarily going to break your code, when they arise they are usually the results of mistakes. It is better to let the compiler catch these issues for you then let them mess up your program.

### Compiling multiple files

We will often compile programs that use multiple files. For example, `foo.c` may contain a `main` function that you want to run, but it will invoke a function defined in `bar.c`. When dealing with multi-file projects, we need to make sure of a few things:

1. Files can see the necessary function *declarations* --- if I invoke a function in `foo.c` that is defined in `bar.c`, the compiler needs to know the *signature* of the function: how many arguments it has, what its name is, what its return type is. This information is contained in a function *declaration* that needs to be in `foo.c` even though the function itself is in `bar.c`. The way we usually do this is by putting the function declaration in a *header* file, `bar.h` that is *included* in `foo.c` using the directive `#include "bar.h"`
2. We compile each source file. You can do this by running `gcc -c foo.c`, which will create an output file called `foo.o`. This output file is *not* an executable. It an *object file* that contains the compiled code that was in `foo.c`.
3. We *link* the object files together into an executable, by running `gcc foo.o bar.o -o out`, which will combine the two object files into an executable called `out`.

Note that there are other ways to combine code from multiple files into an executable (such as statically and dynamically linked libraries), but they are beyond the scope of this course.

### Conditional compilation

In some cases, you want to turn on or off sections of code. For example, you may want to print debug messages showing the progress and states of your programs, such as:

`printf("The value of x is %d\n", x);`

Once you're done with your program, deleting these debug messages can be tedious. (And you might miss some, or accidentally delete the wrong line!)

Fortunately, *conditional compilation* can come to our rescue. The following code:

`#ifdef DEBUG`
`printf("The value of x is %d\n", x);`
`#endif`

will only execute if the symbol `DEBUG` is defined somwhere earlier in the program:

`#define DEBUG`

If that symbol is not defined, then everything between `#ifdef` and `#endif` is ignored by the compiler. We can also define symbols on the command line, by using the `-D` flag:

`gcc -c foo.c -DDEBUG`

means to compile `foo.c` with the symbol `DEBUG` defined. As you can imagine, this can make it easier to add debugging code to your program.

We will make heavy use of conditional compilation to test your code---it will allow us to turn off different parts of your code and substitute our own implementations to test.

> You might notice that `#ifdef`, `#define`, `#endif` and `#include` all start with the `#` symbol. These are examples of *preprocessor directives* that the **C preprocessor** uses to rewrite your C file into a different C file that `gcc` will ultimately compile. The ins and outs of the preprocessor are beyond the scope of this course, though we might discuss some tricks in class.

You can define multiple symbols. For example, if you want to test two different solutions of the same function, you can do the following:

```
#ifdef SOLUTION1
void func(....) // solution 1
{
    ....
}
#endif

#ifdef SOLUTION2
void func(....) // solution 2
{
    ....
}
#endif
```

If you have `-DSOLUTION1` after `gcc`, the first solution is included. If you have `-DSOLUTION2` after `gcc`, the second solution is included.

Just like you can check for whether a symbol is defined, you can also check to see if it is undefined, using `#ifndef`. You can also create an "if-then-else" setup:

```
#ifdef SYMBOL
...
#else
...
#endif
```

(See `main.c` in the included files for an example of this construction)


### make and Makefiles

*Makefiles* let you define complicated sets of commands to build your projects.

Makefiles consist of a series of rules:

```
[target] : [dependences] [command 1]
	[command 2] ...
```

A *rule target* is the name of the rule. The dependences are the files the rule depends on. The commands are what to do when the rule is “fired.” Note: there *must* be a tab before each command.

A rule is fired in one of two ways: (i) it is directly invoked (by calling “make [target]”) or (ii) it is invoked by another rule that is fired.

When a rule is fired, it goes through the following process:

1. If a dependence has a rule in the Makefile, fire that rule (using this same process)
2. Once all dependences have been fired, check to see if `target` is “out of date”: interpret `target` as a filename, and see if the timestamp on the file is older than the time stamp on any of its dependences. If it is, the target is “out of date.” If there is no file named `target`, the target is always assumed to be out of date. If there are no dependences and `target` exists, `target` is assumed to be up to date.
3. If the target is out of date, execute the list of commands

You can use Makefiles to orchestrate complicated build processes.

If you type `make` without a target, make will fire the first rule in the Makefile. Otherwise, if you type `make [target]`, it will fire the rule named `target`.

We usually define a target called `clean` whose job it is to clean up any intermediate files generated during the build process. This can also be used to remove all generated targets to force recompiling everything.

We can also use Makefiles to test our code. For example, we might want to run a number of tests after building the project:

```
test : all
	./a.out testfile1
	./a.out testfile2
```

Running `make test` will build the target `all` (compiling your project), followed by running the commands to test your code. (Note that because there is no file named `all`, `make` assmes that the target is out of date and runs it every time.)

Makefiles also let you define macros to reuse the same commands over and over. For example, we can define GCC as a macro that invokes gcc the way we want:

```
DEBUG = -DDEBUG
CFLAGS = CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
GCC = gcc $(CFLAGS) $(DEBUG)
```

Note that we use `$(MACRO_NAME)` to insert the macro into other places, including commands.

There are some "recipes" for making files that you may want to use over and over again. For example, to create  `foo.o`  from a `foo.c` file, you might write the rule:

```
foo.o : foo.c
	gcc -c foo.c -o foo.o
```

And similarly to create `bar.o` from `bar.c`, you might write:

```
bar.o : bar.c
   gcc -c bar.c -o bar.o
```

Which looks pretty redundant! You can instead use a *pattern rule* to create a generic recipe that follows this pattern:

```
%.o : %.c
	gcc -c $< -o $@
```

Makefiles can get much more complicated than this, but their full power is beyond the scope of this course.

## Tasks

In this homework, you will need to do the following:

1. Write a selectin sort routine
2. Use conditional compilation so that the selection sort routine can sort ascending or descending based on a compiler flag
3. Write a new make target to generate code that sorts in ascending order
4. Learn to submit your code

## What you need to do

### 1. Set up your GitHub account and repository

To submit code in this class, you need to have a GitHub account so that you can clone repositories and submit homeworks. If you do not already have a GitHub account, please create one at [https://www.github.com].

Once you have a GitHub username, let us know what it is so we can link your submissions to your Purdue account. To do so, fill out [this form](https://forms.gle/AE6aTFzrNAw6ydfP8). **If you do not fill out this form, we will not be able to assign your grades properly.**

Then, create your HW0 repository. To do this, click on the link provided in Brightspace. This will set up a repository containing this README as well as starter code for HW0.

### 2. Clone your repository

To set up your repository on your local machine to write the code we want, you'll have to do the following:

```
> git clone git@github.com:PurdueECE264/hw0-<username>.git
```

Then you can `add`, `commit`, and `push` as described above.

The starter files in your repository are:

1. `main.c`: a file that contains the `main` function that reads an array of integers from a file. It also contains some helper functions to print an array or tell if an array is sorted. You do not have to alter this file in this homework. Though it can be helpful to look
2. `sort.c`: a file that contains an implementation of selection sort that sorts an array in descending order.
3. `sort.h`: a header file with the declaration of the selection sort routine.
4. `Makefile`: a Makefile that builds the project.

### 3. Implement selection sort

The routine `ssort` in `sort.c` is intended to use selection sort to sort elements in descending order. We will discuss selection sort in class, and you may also find the [Wikipedia article](https://en.wikipedia.org/wiki/Selection_sort) helpful. 

In a nutshell, selection sort works by scanning the entire array for the minimum element, then swapping it into location 1, then scanning the entire array *except for the first element* for the smallest element and swapping it into location 2, and so on. In this way, it builds up the sorted list from left to right, constantly looking for the smallest element in the *rest* of the list to put at the end of the sorted section.

> Selection sort is *not* the fastest way to build a sorting routine. Later in class, we will discuss other, faster sorting routines like merge sort and quicksort.

Your task is to implement `ssort.c` so it can sort the array in *descending* order. If you run `make test` and see sorted arrays in *descending order* when you are done, then you will have gotten this step right.

### 4. Add conditional compilation

We now want to add conditional compilation to your code. If you pass the flag `-DASCENDING` during compilation, you should generate a version of the project that sorts the array in *ascending* order instead.

You should thus do two things:

1. Modify `sort.c` to add conditional compilation flags that will compile a version of selection sort that sorts in ascending order if the symbol `ASCENDING` is defined. (You can look at `main.c` for some inspiration). You should be able to do this by only modifying a line or two of code from step 3, but we will not penalize you for doing more work.
2. Add a new compilation target to `Makefile` called `ascending`. When you type `make ascending`, it should set up compilation so the ascending version of selection sort is used. When you type `make` or `make all`, it should generate the default descending version of selection sort.

Note that the make target `test-ascending` will use the same test cases as `test` to check that your selection sort routine correctly sorts numbers into ascending order.

### 5. Submit your code!

As you develop your code, do not forget to use version control. As you solve parts of the problem, use `git add` and `git commit` to preserve the latest version of the code. Periodically use `git push` to sync your code with your GitHub repository.

When you are ready to submit your code for grading, you need to *tag* the version you want us to grade. A tag is a way of assigning a name to a particular version of code. We look for the tag `final_ver` to decide what to grade.

1. Tag your local code: `> git tag final_ver`
2. Push the tag to GitHub: `> git push origin final_ver`

If you later decide you want to update the version you submit, you can tag a different version:

1. Update the tag: `> git tag final_ver -f`
2. Push the tag to GitHub: `git push origin final_ver -f`

We will grade whichever version has the `final_ver` tag at the due date.

## Good luck!

Good luck
