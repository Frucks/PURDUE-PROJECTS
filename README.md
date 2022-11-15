# PURDUE-PROJECTS

Hi!

  If you're seeing this I probably applied to your company. These projects are from all my coding classes, excluding labs (Assembly, Verilog, VPython) and CS 159 (C Programming).

## Data Structures (ECE 368)

  This class has been the hardest programming class so far. Throughout the course we learned about time complexity, sorting algorithms, searching algorithms, data structures (such as trees, stacks and queues) and graph theory. These projects are the ones named "paX.zip" (where X is a number).
  
  Personally, I thought pa2 was the most fun. The main goal of this assignment was to create a height-balanced binary search tree through insertion and deletion operations. The professor had given us most of the code for the insertion and rotation functions, but I wanted to challenge myself and therefore didn't bother looking at it. I ended up developing my own recursive insertion algorithm (as opposed to the given iterative method), as well as my own rotation function. However, the hardest part of the assignment was definitely designing the delete function. Because I wanted to minimize the time complexity of my program, the balance adjustments were made while both the insert and delete functions were being recursed. And while in the insertion it was clear which height was increasing (based on how the program traveled through the tree), the deletion process not only had more complex rotations, but where the replacement node was located made it much harder to determine how the heights were changing. This led me to create a variable to track how the balances should change (positively, negatively, whether a rotation happened, etc), but the meaning of this variable changed depending on the recursion path. For example, the variable could indicate that the balance should increase (balance + 1), but after a certain point that could mean the balance should decrease (balance - 1) instead.

## Advanced C Programming (ECE 264)

  The projects for this class are the ones that start with "hw". The earlier ones familiarized us with simpler concepts such as gcc, makefiles and sorting algorithms, but as the course progressed they got more complex, ending with stacks, recursion and binary trees.

  My personal favorite was Homework 11. In this assignment, the aim was to traverse a maze and build a sorted linked list with all possible routes. To accomplish this I had to use recursion, which is always fun to think about, as well as different structures (including enum).

## Python for Data Science (ECE 20875)

  All the folders starting with "homework" are part of this class, as well as the mini project. At first this class taught us how to apply data science in python, but afterwords we learned how to apply machine learning algorithms to data. Some of these algorithms include k-NN, GMM, SVM, MLP and naive Bayes classifiers as well as linear regression.
