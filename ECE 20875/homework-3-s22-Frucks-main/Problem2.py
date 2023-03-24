import scipy.stats as stats
import matplotlib.pyplot as plt
from helper import *
import os
import math
hw3_path = '/home/shay/a/jtafffre/homework-3-s22-Frucks'
os.chdir(hw3_path)

def get_coordinates(data, each_dist):
    # Part B
    """
    :param: np.ndarray, str
    :return: np.ndarray, np.ndarray
    """
    # Your code starts here...

    tuples = stats.probplot(data, dist = each_dist)

    (X, Y), (c, d, e) = tuples

    return [X, Y]

    pass


def calculate_distance(x, y):
    # Part B

    """
    :param: float, float
    :return: float
    """
    # Your code starts here...

    dist = math.sqrt(math.pow((x - (x + y) / 2), 2) + math.pow((y - (x + y) / 2), 2))

    return dist

    pass


def find_dist(sum_err, dists):
    # Part B
    """
    :param: list[float], list[str]
    :return: str, float
    """
    # Your code starts here...

    min_num = sorted(sum_err)[0]
    min_dist = dists[sum_err.index(min_num)]

    return [min_dist, min_num]
    pass


def main(data_file):
    """
        Input a csv file and return distribution type, the error corresponding to the distribution type (e.g. return 'norm',0.32)
    :param: *.csv file name (str)
    :return: str, float
    """
    # Part B
    data = get_data(data_file)
    dists = ("norm", "expon", "uniform", "wald")
    sum_err = [0] * 4
    for ind, each_dist in enumerate(dists):
        X, Y = get_coordinates(data, each_dist)
        for x, y in zip(X, Y):
            sum_err[ind] += calculate_distance(x, y)
    return find_dist(sum_err, dists)


if __name__ == "__main__":
    for each_dataset in [
        "sample_norm.csv",
        "sample_expon.csv",
        "sample_uniform.csv",
        "sample_wald.csv",
    ]:
        print(main(each_dataset))
