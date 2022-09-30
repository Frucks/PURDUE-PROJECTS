# Homework 3: Histograms and Distributions
## Due: 02.04.2022 at 11:59 pm ET

This homework asks you to write and use the functions we discussed in the lecture on histograms to find the "optimal" number of bins for a data set. We then ask you to explore some data to identify its distribution.

# Goals

In this homework you will:

1. Learn how to install new Python modules
2. Build up a complex analysis code by building smaller functions first
3. Perform some basic data exploration

# Background

## Python modules

Python has a lot of built-in functionality right out of the box: basic data structures like lists, sets, and dictionaries, functions that help use those data structures (like `len`), etc. There are a vast number of Python modules that provide additional functionality too. This functionality is not built in -- not everyone needs it -- but Python comes with tools to make it easy to use those modules.

### Installing a module

To install a module, you can use Python's built-in package manager, `pip`. We will provide instructions for installing modules from the command line. These instructions will work with Python3 installations on Scholar, ECE Grid, most Linux distributions, and Mac OS. There are a number of different ways to get Python3 on Windows, so you will have to look at the documentation for your version to determine how to install a new module.

Modules can be installed globally (so everyone on a machine has access to them) or locally (so only you have access to them). Installing modules globally requires root access to the machine (or other specially-set permissions), so we will provide instructions for installing modules locally.

To install a module named `scipy`, you can use the following command:

`python3 -mpip install --user scipy`


This command can let you install the latest version of the module.
You can also install an exact version of the module by adding the version number after the module's name followed by the sign `==`: 

`python3 -mpip install --user scipy==2.0.8 # install the scipy module with version number 2.0.8 `

If `scipy` is already installed on your system but you want to upgrade to a new version of it, you can use the command:

`python3 -mpip install --user --upgrade scipy`

There are also other choices of package managers, for example if you are using `conda` to manage your python environment, you can do the same thing as `pip` does with the following commands:

`conda install scipy         # Install the latest version of scipy module`

`conda install scipy=2.0.8   # Install the scipy version 2.0.8`

`conda update scipy          # Update the module scipy`

Note: In order to specify a specific version number `pip` uses `==` while `conda` uses `=`.

To complete this homework, you will need to install the following modules with the specified versions or higher:

1. `numpy==1.14.0` : this is a module that provides array and matrix classes, and many mathematical operations on those classes. It is the foundation of many of the modules that are used in data science.
2. `scipy==1.0.0` : this module provides many other useful functions for data analysis, including functions for dealing with probability distributions.
3. `matplotlib==2.1.2` : a basic plotting/visualization library.

Note 1: You are welcome to use different versions of the above modules since a
lot of them may already have been installed in your environment. There might be
a slight chance that potential problems will occur if you are using modules
that are of a different version, especially older versions than the ones provided
above. Therefore, please make sure your version is at least large as the version number
provided above.

Note 2: If you encounter an error message of `ModuleNotFoundError: No module named 'tkinter'` then, in your code, replace the line:
```
import matplotlib.pyplot as plt
```
with the following lines:
```
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
```

### Using a module

The functions in a module are in that module's *namespace*. To make sure that the function names do not collide with functions in other modules (or Python's built-in functions), the functions need to be accessed through a prefix. To load a module, you have to tell Python (a) which module to load; and (b) what prefix to use when accessing the functions of that module. For example, the following code:

`import numpy as np`

Tells Python you want to use the module `numpy`, and that you want to access the functions of `numpy` using the prefix `np`. For example, the following code will read in a list of numbers stored in a text file and give you back a list with those numbers in it:

`data = np.loadtxt('input.txt')`

You can also use the `import` keyword to bring in functions from other files
(think of these like `#include` directives in C). The following command will
import `function1` from a file called `myfile.py`:

`from myfile import function1`

You can also import all functions defined in another file, like `helper.py` for example, using the asterisk operator:

`from helper import *`

## Incremental Development

In this homework, we will ask you to write a fairly complex piece of code:
finding the number of histogram bins that results in the lowest error for a
given data set. When you need to write complex code like this, your goal should
be to break the problem down into smaller pieces. Write functions that solve
each of the smaller pieces, then figure out how to connect those functions
together (some of them might call other functions you wrote) to solve the
overall problem.

This approach makes it much easier to write complex code, both because you do not have to solve the problem all in one go, and because it makes it easier to *test* your code: you can test each of your smaller pieces individually to make sure that they work properly.

In this homework, we will walk you through one particular way you can break down the problem (and, in fact, we want you to solve the problem in this way -- we will test the individual pieces for partial credit).

## Store returned values from a function

Return the coordinates from the data points in the probability plot (https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.probplot.html)
to retun the values you can use the following command: 
```
val1,val2=stats.probplot(data, dist = 'uniform', plot=plt)
```
This will store both return values from probplot and will store them in val1 and val2 respectively. Only val1 (per documentation) will be related to the coordinates. 

# Instructions

## 0) Set up your repository for this homework

Click the link on Piazza to set up your repository for HW 3, then clone it.

The repository should contain 13 files:

1. This README
2. Four input data files : `input.txt`, which you will use in problem 1, and `sample_expon.csv`, `sample_norm.csv`, `sample_uniform.csv`, `sample_wald.csv`,`distA.csv`, `distB.csv`, and `distC.csv`, which you will use in problem 2
3. `Problem1.py`, a skeleton script for Problem 1
4. `Problem2.py`, a skeleton script for Problem 2
5. `testbin.py`, to help individually test the functions you will write in `Problem1.py`
6. `helper.py` contains some useful helper functions for use when writing/testing your code

## 1) Problem 1: Histogram Bin Width Optimization

In this problem, you will implement histogram bin width optimization from a data set. You will use the histogram function in `matplotlib.pyplot`, accessed as `matplotlib.pyplot.hist` or `plt.hist` if you `import matplotlib.pyplot as plt`. Please read the documentation: [`matplotlib.pyplot.hist`](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.hist.html). (Note in particular that the function returns a tuple of three elements: `n`, `bins`, and `patches`, but you only need `n`, so be sure to unpack the output accordingly.)

An example of tuple unpacking:
```
List1 = ['String1', 'String2']
str1, str2 = List1 # str1 == 'String1' and str2 == 'String2'
```

We have broken the problem down into smaller pieces for you. `Problem1.py` has four functions for you to fill in. **Keep the signatures of these functions the same as you are filling them in; we will use these to assign partial credit**. 

1. `norm_histogram` takes a histogram of counts and creates a histogram of probabilities.
2. `compute_j` computes the value of J for a given histogram and bin width (check histogram slides for more info).
3. `sweep_n` computes the `j` value for different *number of bins*, where *number of bins* will take values from *min_bins* to *max_bins*. Therefore, `sweep_n` should return a list of `compute_j` values. You will need to use the `compute_j` and  `matplotlib.pyplot.hist` functions in your implementation. Note that `sweep_n` cares about the number of bins while `j` cares about the width of the bins -- make sure to do the conversion!.
4. `find_min` is a generic function that takes a list of numbers and returns a tuple containing the average of the three smallest numbers in that list and the indexes of those three numbers.


You can use `input.txt`, provided in the repository, as test data. To test each function individually please refer to `testbin.py`. There are instructions provided in the file to test each portion of your code. 

Within `testbin.py` if:
1. `norm_histogram` runs correctly then the output (shown only up to 4 points post decimal) will be `[0.104 0.096 0.094 0.079 0.108 0.092 0.114 0.109 0.121 0.083]`
2. `compute_j` works then the output will be `-0.0101`
3. `sweep_n` works then the output (shown only up to 4 points post decimal) should be `[-0.0101 -0.0101 -0.0101 -0.0101 -0.0101 -0.0101 -0.0101 -0.0101 -0.0101
 -0.0101 -0.0101 -0.0101 -0.01   -0.0101 -0.01   -0.01   -0.01   -0.01
 -0.01   -0.01   -0.01   -0.01   -0.0099 -0.01   -0.01   -0.0099 -0.0099
 -0.0099 -0.0098 -0.0099 -0.0098 -0.0099 -0.0099 -0.0099 -0.0098 -0.0098
 -0.0098 -0.0098 -0.0097 -0.0098 -0.0098 -0.0098 -0.0098 -0.0098 -0.0097
 -0.0097 -0.0097 -0.0097 -0.0097 -0.0096 -0.0097 -0.0097 -0.0096 -0.0096
 -0.0096 -0.0095 -0.0096 -0.0097 -0.0095 -0.0096 -0.0095 -0.0095 -0.0096
 -0.0095 -0.0094 -0.0095 -0.0095 -0.0095 -0.0094 -0.0093 -0.0094 -0.0093
 -0.0095 -0.0094 -0.0093 -0.0094 -0.0094 -0.0094 -0.0093 -0.0094 -0.0092
 -0.0094 -0.0093 -0.0092 -0.0093 -0.0092 -0.0091 -0.0092 -0.0093 -0.0093
 -0.0092 -0.0093 -0.0091 -0.0092 -0.0092 -0.0092 -0.0091 -0.0091 -0.0091
 -0.0091]`

4. `find_min` executes then your output should be `(-0.0101, [0, 7, 1])`
Please note: you are not to truncate the values. We have only done so to keep the write up brief. The output from `find_min` will be checked up to four points post decimal. 


If your functions all work, and you run the test code that is included in `Problem1.py`, you should produce the following output: `(-0.0101, [0, 7, 1])`. (Again, we truncated our value here only to keep this document brief.)

The expected outputs show only up to three points of precision, your result from running `testbin.py` may contain longer floating points.

> The `if __name__ == '__main__'` line in `Problem1.py` is a useful way to write tests for your code: this is code that will *only* run if you run this file as the main script; if this file is included from another script, this test code will not run.

## Problem 2: Distributions

In this problem we will draw from your probability plot understanding to create a function that for any dataset reports what is the closest distribution fit between:

* Gaussian (`norm`)
* Exponential (`expon`)
* Uniform (`uniform`)
* Wald (`wald`)

> Note: for this problem we will assume that the best fit distribution is that in which the sum of squared distances from the coordinates of the probplot to the identity line (X=Y) is minimized.

To complete this problem, do the following steps.
1. Complete the `get_coordinates` function. This function takes in an array of data and the name of a distribution. It then calculates the QQ plot by calling the `stats.probplot` function with the dataset and the named distribution. The `stats.probplot` function returns a bizarre data structure: a tuple of two tuples; we're concerned with the two values first tuple in the returned tuple. More concretely, the `stats.probplot` function returns something with a structure like `((X, Y), (c, d, e))`, you will need to return the elements in the position of `X` and `Y` from the `get_coordinates` function (return it as a tuple like `(X, Y)`).

2. Complete the `calculate_distance()` function. This function takes in two floats and returns the calculated distance. The formula you need to use for this function is (in LaTeX form): $$\sqrt{(x - \frac{x+y}{2})^2 + (y - \frac{x+y}{2})^2}$$ It performs vector projection to the identity line.

> NOTE: If you can't read LaTeX, you can copy and paste that formula in an online LaTeX compiler like QuickLaTeX.

3. Complete the `find_dist` function. This function takes in a list of the sum of squared distances and a list of distributions. Your code must find the minimum value in the `sum_err` list of sums and the distribution at the same index in `dists`. Returns a tuple that contains the distribution selected and the error calculated. For example `('norm', 9.87546)`.

If your code is correct you should get the following results for the files  `sample_norm.csv`, `sample_expon.csv`,`sample_uniform.csv`, `sample_wald.csv` respectively:
```
('norm', 96.90230310278383)
('expon', 155.95940064211737)
('uniform', 30.477151216719985)
('wald', 2366.701864399592)
```
> NOTE: we will only check your values to 4 decimal places.

# What to Submit

For Problem 1, please submit `Problem1.py` with all the appropriate functions filled in.

For Problem 2, please submit `Problem2.py` with all the appropriate functions filled in.


# Submitting your code

Please push the latest version of your code as you did in HW2. Do not make further modifications to your repository.
