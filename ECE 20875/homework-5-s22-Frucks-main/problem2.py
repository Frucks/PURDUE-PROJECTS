import math as m
import numpy as np
import scipy.stats as stats
from scipy.stats import ttest_1samp
from scipy.stats import norm
from scipy.stats import t

# import or paste dataset here

data = [3, -3, 3, 12, 15, -16, 17, 19, 23, -24, 32]

# code for question 1
print('Problem 1 Answers:')
# code below this line

size = len(data)
confidence = 0.9
alpha = 1 - confidence
avg = np.mean(data)
print("Sample mean:", avg)
stdev = np.std(data, ddof=0)
sterr = stdev / (size ** 0.5)
print("Standard Error:", sterr)
t_score = ttest_1samp(data, alpha)[0]
print("T-score:", t_score)
p = ttest_1samp(data, alpha)[1]
print("P-score:", p)
interval = (avg - t_score * sterr, avg + t_score * sterr)
print("90% confidence interval:", interval)


# code for question 2
print('Problem 2 Answers:')
# code below this line

size_1 = len(data)
confidence_1 = 0.95
alpha_1 = 1 - confidence_1
avg_1 = np.mean(data)
print("Sample mean:", avg_1)
stdev_1 = np.std(data, ddof=0)
sterr_1 = stdev_1 / (size_1 ** 0.5)
print("Standard Error:", sterr_1)
t_score_1 = ttest_1samp(data, alpha_1)[0]
print("T-score:", t_score_1)
p_1 = ttest_1samp(data, alpha_1)[1]
print("P-score:", p_1)
interval_1 = (avg_1 - t_score_1 * sterr_1, avg_1 + t_score_1 * sterr_1)
print("95% confidence interval:", interval_1)

range_0 = interval[1] - interval[0]
range_1 = interval_1[1] - interval_1[0]

print("Range 0:", range_0)
print("Range 1:", range_1)

# code for question 3
print('Problem 3 Answers:')
# code below this line

stdev_2 = 15.836
sterr_2 = stdev_2 / (size ** 0.5)
print("Standard Error:", sterr_2)
z_score = stats.norm.ppf(1 - alpha_1)
print("Z-score:", z_score)
interval_2 = (avg - z_score * sterr_2, avg + z_score * sterr_2)
print("95% interval:", interval_2)

range_2 = interval_2[1] - interval_2[0]
range_1 = interval_1[1] - interval_1[0]

print("Range 2:", range_2)
print("Range 1:", range_1)

# code for question 4
print('Problem 4 Answers:')
# code below this line

t_score_2 = avg / sterr
p_2 = 2 * stats.t.cdf(-abs(t_score_2), size - 1)
confidence_2 = (1 - p_2)

print("Level of confidence:", confidence_2)