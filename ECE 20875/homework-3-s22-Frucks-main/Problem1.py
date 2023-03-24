import numpy as np
import matplotlib.pyplot as plt
from helper import *


def norm_histogram(hist):
    """
    takes a histogram of counts and creates a histogram of probabilities
    :param hist: a numpy ndarray object
    :return: list
    """
    list1 = []
    total = sum(hist)

    for num in hist:
        prob = num / total
        list1.append(prob)

    return list1

    pass


def compute_j(histo, width):
    """
    takes histogram of counts, uses norm_histogram to convert to probabilties, it then calculates compute_j for one bin width
    :param histo: list
    :param width: float
    :return: float
    """
    sum = 0
    m = 0
    k = 0

    prob = norm_histogram(histo)
    
    sq =[0] * len(prob)
    
    while k < len(prob):
        sq[k] = prob[k] ** 2
        sum += (sq[k])
        m += histo[k]
        k += 1


    j = 2 / ((m - 1) * width) - (((m + 1) / ((m-1) * width)) * (sum))
    
    return(j)

    pass


def sweep_n(data, minimum, maximum, min_bins, max_bins):
    """
    find the optimal bin
    calculate compute_j for a full sweep [min_bins to max_bins]
    please make sure max_bins is included in your sweep
    :param data: list
    :param minimum: int
    :param maximum: int
    :param min_bins: int
    :param max_bins: int
    :return: list
    """

    J_list = []

    for bins in range(min_bins, max_bins + 1):
        J_value = compute_j(plt.hist(data, bins, (minimum, maximum))[0], (maximum - minimum) / bins)
        
        J_list.append(J_value)

    return(J_list)

    pass


def find_min(l):
    """
    takes a list of numbers and returns the mean of the three smallest number in that list and their index.
    return as a tuple i.e. (the_mean_of_the_3_smallest_values,[list_of_the_3_smallest_values])
    For example:
        A list(l) is [14,27,15,49,23,41,147]
        The you should return ((14+15+23)/3,[0,2,4])

    :param l: list
    :return: tuple
    """
    l2 = sorted(l)[:3]
    index_min_1 = l.index(l2[0])
    index_min_2 = l.index(l2[1])
    index_min_3 = l.index(l2[2])

    return ((l2[0] + l2[1] + l2) / 3, [index_min_1, index_min_2, index_min_3])

    """ min_index = []
    min_sum = 0

    for i in range(0,3) :
        minimum = min(l)
        min_sum += minimum
        min_index.append(l.index(minimum))
        l.remove(minimum)

    average = min_sum / 3
    return (average,min_index) """

    pass


if __name__ == "__main__":
    data = np.loadtxt("input.txt")  # reads data from input.txt
    lo = min(data)
    hi = max(data)
    bin_l = 1
    bin_h = 100
    js = sweep_n(data, lo, hi, bin_l, bin_h)
    """
    the values bin_l and bin_h represent the lower and higher bound of the range of bins.
    They will change when we test your code and you should be mindful of that.
    """
    print(find_min(js))
