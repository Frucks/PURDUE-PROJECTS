# Homework 4: Higher-order Functions
## Due: 02.11.2022 11:59 PM ET

This homework primarily covers defining and using higher-order functions.

# Goals

In this homework you will:

1. Write higher order functions that accept one or more functions as an input
2. Write higher order functions that return a function as output
3. Develop a basic signal processing algorithm (covariance)

# Background

## Higher Order Functions

This homework will get you familiar with several ways to build and use higher
order functions. Before attempting it, please review the notes from class on higher order functions (on brightspace). Feel free use and adapt any of the code that you have
seen in class (can also be found on brightspace).

## Stencils and Covariance

In Problem 2, we will ask you to write two functions. The first is a generic
*stencil* function, and the second is a function that calculates *covariance* between two series
that, when combined, will let you perform a sliding [covariance](https://mathworld.wolfram.com/Covariance.html) between two series. 

### Stencils

A stencil (in the most general sense) is a way of computing a value for a given
data point by using the values of neighboring data points. Suppose we have a
*stencil function*, `f`. `f` is a function that accepts a list of some fixed
length (for our purposes, let's say 3) and outputs a single value that is some
combination of the values in that list. Here is one example:

```
def f(L) :
	return L[0] * L[1] + L[2]
```

Applying a stencil function means treating the stencil function like a "window"
and "sliding" it across a list, computing the result of the stencil function at
each point. So if I start with the following list:

```
[a, b, c, d, e, f, g]
```

Applying the stencil function produces the following output list:

```
[f([a, b, c]), f([b, c, d]), f([c, d, e]), f([d, e, f]), f([e, f, g])]
```

> Note two things:
> 1. The length of the output list is smaller than the length of the input list. If the input list is of length `k`, the output list will be of length `k - width + 1`, where `width` is the width of the stencil that `f` applies.
> 2. You can think of a stencil as a generalization of map that uses neighboring elements to compute the output instead of just the element itself. If `f` has a window of width 1, the output is basically like using map.

We will ask you to write a function for applying stencils that takes in an input list, a stencil function, and a third parameter that tells you how wide the stencil function is.

### Sliding Covariance

#### Covariance

A covariance value is calculated between two random variables. We may sample these variables to get two series or lists of numbers. This value is a measure of how the values in these two lists vary linearly together. A large, positive covariance means that the two series grow larger or smaller together as you move along them, while a large negative covariance means that while one grows larger, the other diminishes in value. A near zero covariance means that the two series operate independently. The following examples may help the intuition.

```
Series A :  [10, 7, 5, 3]
Series B :  [10, 7, 5, 3]
Covariance :  6.6875

Series A :  [3, 5, 7, 10]
Series B :  [10, 7, 5, 3]
Covariance :  -6.5625

Series A :  [3, 5, 7, 10]
Series B :  [2, 2, 2, 2]
Covariance :  0.0
```

Please refer to this [link](https://mathworld.wolfram.com/Covariance.html) to view the formula for covariance, *cov(X,Y)*. 

**IMPORTANT:** Please note that many sites specify *N-1* as the denominator, however, we will be using *N*. Getting these mixed up will cause you to get the wrong answer.

#### Sliding Covariance

We know that we can find the covariance between two series of the same length. However, given a long series of data, we can use a shorter series to slide over the longer one, finding the covariance at each time step. The following example should make the process clear.

```
Long Series : [2,7,3,8,4,6,0]
Window : [1,2,3,4,5]

Series A : [2,7,3,8,4]
Series B : [1,2,3,4,5]
Covariance : 1.0

Series A : [7,3,8,4,6]
Series B : [1,2,3,4,5]
Covariance : -0.2

Series A : [3,8,4,6,0]
Series B : [1,2,3,4,5]
Covariance : -1.6

```

For this example, sliding covariance would return the list `[0.868, -0.104, 1.012]`

# Instructions

## 1) Problem 1: Higher-order functions

In this problem, we ask you to fill in the code for a number of missing functions in `problem1.py`:

1. `exponent_map`: This takes in an integer `n` as its argument and returns a new function. The new function should take in a list `L` as an argument and return a new list, which consists of the `n`th power of each element in `L`. (Consider using the `map` function for this.) 

2. `compose_map`: This takes in *two* functions, `fun1` and `fun2`, and a list, `L`, as its arguments and returns a list, which consists of applying `fun1` then `fun2` to each element of the input list, `L`. **Note that you must apply the functions in that order: call `fun1` first, then `fun2` on the output of `fun1`** for each element in the input list `L`. 

3. `compose`: This takes in two functions and returns a new function. The new function takes in a single argument, `i`, then calls `fun2` followed by `fun1` on that argument, returning the result. Note again that the order matters. *Expected return type for `compose` is a function and not a value.*

4. `repeater`: This takes in a function, `fun` and an integer, `num_repeats`, and returns a new function. The new function takes in an input `x` and calls `fun` on it `num_repeats` times (in other words, you call `fun` on the output of calling `fun` on the output of calling `fun` ... on the input, repeated as many times as `num_repeats`). *Expected return type for `repeater` is a function and not a value.*

### Testing

If your code works, and you run the test code provided in `problem1.py`, you should get the following output:

```
[4, 25, 100, 49, 49, 9, 1, 81, 64, 36]
[1, 7, -23, -17, -17, -9, -5, 15, 13, -15]
[-2, 4, -26, -20, -20, -12, -8, 12, 10, -18]
2
[-2, 4, -26, -20, -20, -12, -8, 12, 10, -18]
5
[1, 7, -23, -17, -17, -9, -5, 15, 13, -15]
repeat 0 times: 5
repeat 1 time: 10
repeat 2 times: 20
repeat 3 times: 40
```

## 2) Problem 2: Stencils

In this problem, we ask you to fill in the two functions in `problem2.py`:

1. `stencil(data, f, width)`: This function takes in a list of `k` elements, `data`, a function, `f`, and an int, `width`, and returns a list. This function returns the result (an output list of length `k-width+1`) of applying the stencil function `f` to the input list `data` as described in the Background section.

2. `find_covariance_of(series)` : This function takes in as input, a list of numbers called `series` and returns two items, a function and an integer, `width`. The value of `width` is equal to the length of the variable `series`. The returned function is a stencil function that takes in a list of size `len(series)`, and calculates the covariance between `series` list and its input list. The returned function should check, at the beginning, if the length in the input parameter is the same as the length of `series`. If not, the following error should be printed:

```
Both lists have to be of the same size!
```


### Testing

A function for calculating the moving average and another to calculates sum of squares over a given series is provided to test your code. 

`get_moving_average(data)`: This function accepts a list, `data`, and returns a list, which contains the windowed moving average of the series.

`sum_sq(data)`: This function accepts a list, `data`, and returns a list, which contains the sum of squares of a window in the series.

We also provided code to test your `find_covariance_of` function. Recall thet `find_covariance_of` returns two items, a function and an integeter value. After calling `find_covarience_of`, we call `stencil`, passing the first returned item from `find_cavariance_of` as the `f` parameter and the seconf returned item as the `width` parameter. This accomplishes the calculation of sliding covariance as described in Background section.

If your code works, and you run the test code provided in `problem2.py`, you should get the following output:

```
[2.733333333333333, 3.3666666666666667, 3.1999999999999997, 5.333333333333333, 8.0, 12.0]
[43.620000000000005, 139.21, 276.96000000000004, 460.0]
[1.0, 1.0, -1.0666666666666667, 4.0, 6.666666666666667, 2.6666666666666665]
[0.6584, -1.2227999999999999, -0.1968, 1.2239999999999998]
```

(The floating point numbers may be rounded a little bit differently, depending on exactly how you implement your covariance function.)

# What to Submit

For Problem 1, please submit `problem1.py` with all the appropriate functions filled in.

For Problem 2, please submit `problem2.py` with all the appropriate functions filled in.

# Submitting your code

Your final submission should have modified `problem1.py` and `problem2.py` files. Ensure to push all changes to your repository by 11:59PM on 2/11/2022. 
