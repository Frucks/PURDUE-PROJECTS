# Homework 9: K-Means and GMM Clustering

## Due: 15 April, 2022 11:59pm ET

This homework asks you to fill in portions of classes that you can then use to perform k-means analysis.

# Goals

In this assignment you will:
* Get familiar with using objects and classes by defining some methods and using objects to perform a computation
* Implement k-means
* Get practice with implementing Gaussian Misture Models (GMMs) using sklearn

# Background

## Classes and Objects

Please see the class notes on objects and classes on Brightspace.

## k-means and GMMs

Please see the class notes on clustering and specifically k-means and GMMs on Brightspace.

# Instructions

## 0) Set up your repository for this homework.

Use the link on Piazza to set up Homework 9.

The repository should contain the following files:

1. This README.
2. `cluster.py` which contains the definition of the `Cluster` class and some testing code.
3. `point.py` which contains the definition of the `Point` class and some testing code.
4. `kmeans.py` which contains the skeleton of the k-means algorithm and some testing code.
5. `gmm.py` which contains the skeleton of the `gaus_mixture()` function.  
6. `gmm_data.csv` which contains the data that will be used to test your GMM function. 

## 1) Homework Problem 1: Complete Point class

Complete the missing portions of the `Point` class, defined in `point.py`:

1. `distFrom`, which calculates the (Euclidean) distance between the current point and the target point. Be sure to account for the fact that a point may be in more than two dimensions (Euclidean distance generalizes: square the difference in each dimension and take the square root of the sum). It is okay to use `math.sqrt()` to calculate the square root.
2. `makePointList`, which takes in a data p-by-k input matrix `data` and returns a list of p `Point` objects. Hint: Instantiate a point object for every row in the input, `data`. Note that `makePointList` is outside the `Point` class. 

If you test your code by running `python3 point.py`, you should get the following:

```
[Point([0.5 2.5]), Point([0.3 4.5]), Point([-0.5  3. ]), Point([0.  1.2]), Point([10. -5.]), Point([11.  -4.5]), Point([ 8. -3.])]
2.009975124224178
```

(Your floating point numbers may be a little off due to rounding)

## 2) Homework Problem 2: Complete Cluster class

Complete the missing portions of the `Cluster` class, defined in `cluster.py`:

1. `avgDistance`, which computes the average distance from the center of the cluster (stored in `self.center`) to all of the points currently in the cluster (stored in `self.points`). This can most easily be done by summing the distances between each point and the current center and then dividing the sum by the total number of points.
2. `updateCenter`, which updates the center of the cluster (stored in `self.center`) to be the average position of all the points in the cluster. Note that if there are no points in the cluster, you should return without updating (i.e., if there are no points, just `return`).

> Note that we have defined `dim` and `coords` as properties that return information about the center of the cluster -- this means that if you pass a cluster into a method that is expecting a point, operations that access `dim` and `coords` will use the center of the cluster. Think about how that might be useful in conjunction with the `closest` method defined for `Point`.

If you test your code by running `python3 cluster.py`, you should get the following:

```
Cluster: 0 points and center = [0.5, 3.5]
Cluster: 2 points and center = [0.5, 3.5]
1.4976761962286425
Cluster: 2 points and center = [1.75, 2.75]
0.3535533905932738
```

(Your floating point numbers may be a little off due to rounding)

## 3) Homework Problem 3: Implement k-means

Use the methods in `Point` and `Cluster` to implement the missing `kmeans` method in `kmeans.py`. The basic recommended procedure is outlined in `kmeans.py`.

If you test your code by running `python3 kmeans.py`, you should get the following:

```
Cluster: 4 points and center = [0.075 2.8  ]
   [0.3 4.5]
   [0.  1.2]
   [0.5 2.5]
   [-0.5  3. ]
Cluster: 3 points and center = [ 9.66666667 -4.16666667]
   [ 8. -3.]
   [10. -5.]
   [11.  -4.5]
```

Note, the order of the points in each cluster doesn't matter (neither does the order of clusters), all
that's important is that each cluster contains the correct points. Your floating point numbers may be
a little off due to rounding.

## 4) Homework Problem 4: Find best number of clusters to use on GMM algorithms
Note that this problem is independent of the three problems above. In addition, **you are permitted** to use the GMM implementation in the sklearn library.

Here, you will complete the function `gaus_mixture()` in `gmm.py`. Given a 1-d array of data and a list of candidate cluster numbers as input, the function should return the best number of clusters to use (from the input list of candidate cluster numbers) on the GMM. 

The best number of clusters is determined by (1) fitting a GMM model using a specific number of clusters, (2) calculating its corresponding Bayes Information criterion (BIC - see formula below), and then (3) setting the number of clusters corresponding to the lowest BIC as the best number of clusters to use.

This function should be completed using the algorithm outlined in the skeleton code. In addition, consider the following hints: 

1. The GMM algorithm can be implemented using the sklearn library using `gm = GaussianMixture(n_components=d, random_state=0).fit(dataset)`, where `d` corresponds to the number of clusters to use and dataset is a (for our case) `n-by-1` array of data. Lastly, `random_state=0` is a random seed that allows for reproducibility. **In your code, you must set**  `random_state=0` when you call `GaussianMixture`.


2. The BIC formula is given by `BIC = -2log(L) + log(N)d`, where `L` is the maximum likelihood of the model, `d` is the number of parameters, and `N` is the number of data samples. When using the sklearn library, however, the BIC is given by `bic = gm.bic(dataset)`, where `gm` is the object returned when `GaussianMixture()` from Hint 1 is instantiated. `gm.bic` is how the BIC should be calculated in your implementation. 

When you run your code on the given data in `gmm_data.csv` using `n_components=[2, 3, 4, 6, 7, 8]` as the possible number of clusters, your output should be:

`Best fit is when k = 3 clusters are used`

# What you need to submit

Push your completed versions of `kmeans.py`, `cluster.py`, `point.py`, and `gmm.py`.
