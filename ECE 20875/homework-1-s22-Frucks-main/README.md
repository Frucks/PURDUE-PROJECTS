# Homework 1

## Due on: Friday, 01/21/2022 at 11:59 pm ET. 

Welcome to ECE 20875, Python for Data Science! In this class, you will learn the basics of various topics in data science, and, along the way, learn how to write code in Python.

## Goals

This homework has several objectives:

1. Get familiar with git and GitHub: cloning, committing, tagging, etc.
2. Get familiar with the GitHub Classroom submission system.
3. Write a simple Python script demonstrating Python fundamentals.

## Grading

1. 30% of the homework corresponds to committing and pushing (submitting) the homework. If you were able to commit and push the homework, we assume you know the basic Git commands.
2. 35% - Problem 1 
3. 35% - Problem 2

## Background

### Version Control

Git is a version control tool. What is version control? It is a means of retaining
organized versions of your code as you work on a project. This is especially important 
in industry for code organization, collaborative projects, and large projects spanning many files.
Further information on how GitHub might be used in collaborative projects can be found at https://guides.github.com/ 
if interested. You will not be concerned with branches in this class.

When working with repositories for this class, there are three main parts to working with git: 
1. The remote repository (on GitHub) 
2. The local repository (on your device/ Scholar account) 
3. Your working files (on your device/ Scholar account) 

Note: Git is the tool you use to do version control. GitHub is where your remote repository is hosted.

When you do a `git add` followed by `git commit`, you are updating your local repository.
When you do a `git push`, you are updating the remote repository on GitHub (supervisors or collaborators can now see your changes).

The key commands you will need to use in this assignment (and at other times) are:

1. `git clone <url>`: This sets up a local repository on your machine by "cloning" (copying) a remote repository; in this case, a repository is set up on GitHub.
2. `git add <filename>`: When you have changed a file, you can "stage" it for the next version (i.e., tell git that you want the changes in this file to appear in the next version) using this command. (Note, when you want to just add/stage changes made to all files in a directory, consider "git add --all". Changes may include deletion of certain files.)
3. `git commit -m "<message>"`: Creates a new version of your code. This new version contains all changes staged in the previous version of the code. This new version only exists in your local repository.
4. `git push`: Updates the remote repository (on GitHub) with all the changes that you have `commit`ted to your local repository. Note that uncommitted changes will not appear on GitHub.
5. `git pull`: Updates your local repository with any remote changes that are on GitHub and have not yet been reflected in your local repository. Note that there may be some conflicts between what GitHub knows about a file and what your local repository knows, and this command will notify you if that happens (fixing those conflicts requires more work). You should always run `git pull` and resolve any conflicts before running `git push`.
6. `git status`: This shows you the status of any files in your local repository. In particular, it shows you any files that you have modified, but not yet `add`ed, and any files that you have `add`ed but not yet `commit`ted.

We will be using the latest version of your code (files present after your most recent push) at 11:59pm on the submission deadline for grading.

Push your code to GitHub often. Not only does that prevent you from
losing any code if you accidentally delete anything, it helps us help you
debug, by giving us access to your latest code.

NOTE: You should verify that your code files are showing up correctly on GitHub once you have `push`ed them from your local machine.

### Python

Familiarize yourself with basic python scripting from the lecture notes. The Python language documentation is online at https://docs.python.org/3/

This assignment has the potential to involve:
1. Initializing variables. Recall that unlike C, C++, etc., Python does not require a data type declaration.
2. Arithmetic (+, -, \*, /, %, **, //), logical (`and`, `or`, `not`), and comparison (<, >, <=, >=, ==, !=) operations.
3. Control flow (if, elif, else) structures.
4. A basic understanding of lists and how to index them.

A caution: DO NOT use `&` and `|` as logical operators. They are for bitwise operations, which should not be used for conditional statements. Using them could lead to very hard bugs to find. As an example, `2 & 1` will give `0`, which will be read as `False` whereas `2 and 1` gives `1`, which is read as `True`. Instead of `&` and `|` you should use `and` and `or` in Python. 

Remember that indentation is Python's inherent way of organizing code blocks.

Ex:

```
if True:
    print('HW1 is truly fantastic.')
print('I concur.')
```



## Getting Started

Clone your HW1 repository by clicking on the GitHub classroom link distributed through Piazza. This will create a repository on GitHub with your username. Use `git clone` to clone that repository locally. If you face issues with this, then you might want to look into using 'ssh key' to clone (directions at the end of this README). 

There should be three files in your repository when you begin:

1. This README file.
2. `Problem1.py`, a python file with one line of code, which contains a single number.
3. `Problem2.py`, a python file with one line of code, which contains a single number.

## Instructions

After completing the 'Getting Started' section above, you will complete 'Problem1.py', 'Problem2.py' and verify it works using the provided test cases. You may then submit your code to GitHub using the git commands above and following the 'What to Submit and How' section below.

### Problem 1

Modify Problem1.py by adding additional lines of code so that it solves the following problem:

Determine whether a given number is even _and_ part of the Fibonacci Sequence. The Fibonacci Sequence is as follows 0, 1, 1, 2, 3, 5, 8, 13.... 
For more information about Fibonacci sequences Click [here](https://www.geeksforgeeks.org/program-for-nth-fibonacci-number/)
The sequence is comprised exclusively of positive integers.

Hint 1: A positive number, n, is part of the Fibonacci sequence if either (5n^2 + 4) or (5n^2 - 4) is a perfect square. That is, if the square root of either (5n^2 + 4) or (5n^2 - 4) is a whole number, then n is a perfect square, and thus a Fibonacci number.

Hint 2: Recall that multiple conditions can be checked in one statement. For example, 
```
if (condition 1) and (condition 2) and (condition 3):
    # do some action 
```

If a number is even, positive, and part of the Fibonacci sequence, your code should print "Yes". If any one of these conditions is not met, your code should print "No".
If your input is number = 2 or 34 or 144, the output should be "Yes".
If your input if number = 4 or 1 or 5 or -8, the output should be "No". Note that 1 and 5 in this example are part of the Fibonacci Sequence but they're not even. Additionally, negative numbers, e.g., -8, can *not* be part of the Fibonacci Sequence.

You may change the variable "number" to any number you want to check your code against, be sure to change it back to "100" before submitting.

### Problem 2

Modify Problem2.py by adding additional lines of code so that it solves the following problem:

Determine whether a given day of January 2022 is a 'Weekend' or a 'Weekday'.  We will consider a Weekend as Saturday or Sunday. 
For example, if the input is n = 21 the your code should print "Weekday".

The input `n` is limited to being in the range of [1, 31] (inclusive). If the number is not valid (e.g. 35) then your code should print "Not valid".

Hint: You can solve this problem in multiple ways, feel free to consider your own approach. One existing approach is to use the Zeller formula Click [here](https://www.geeksforgeeks.org/zellers-congruence-find-day-date/).

You may change the variable n to any number you want to check your code against, be sure to change it back to "21" before submitting.

## What to Submit and How

The only files you need to modify for this homework are `Problem1.py` and `Problem2.py`.

Once you have a version of your code (that you have `commit`ted using `git commit` and `push`ed using `git push`) that you are happy with, you are done! Do not make changes to code that has been provided to you except where specified.

**NOTE: You should verify that your code files are showing up correctly on GitHub once you have `push`ed them from your local machine.**

You might want to try using the ssh key if you face issues while submitting homework1, see the final section of the README for information on this.

## Resubmitting:
If you want to update your submission before the deadline then re-commit and re-push your files. Ensure that you do both `git commit` and `git push` on your updated files so that they appear on GitHub. 


## SSH key (if needed)
Directions for adding ssh key on GitHub:
Here is a link to instructions if you need more help: https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

You may want to use ssh keys to clone your repository if cloning using https gives you problems. To do this, you need to first generate an ssh key pair on your local machine. On your local machine, open a terminal and type:

1. ssh-keygen -t rsa -C "your_email@example.com"
   make sure "your_email@example.com" is the same email used on GitHub

2. Press "Enter" when prompted where to store keys. This will result is saving the keys to a default location.

3. Enter a secure pass phrase that you will remember. 

4. That's it! Keys will be saved in .ssh/

Now, you must enter your public key on GitHub. To do this, type 'cd .ssh/' on your local machine and then copy your PUBLIC key. Then, login to your GitHub repo, click on your profile picture in the upper right hand corner, click on Settings, click on SSH and GPG Keys, click New SSH Key, create a title so you will know which computer the ssh key corresponds to, paste the PUBLIC key, and finally click Add SSH Key. 
