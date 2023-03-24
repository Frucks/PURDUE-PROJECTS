import numpy as np
import math as m
import scipy.stats as stats
from scipy.stats import norm
from scipy.stats import t
import os
hw5_path = '/home/shay/a/jtafffre/homework-5-s22-Frucks'
os.chdir(hw5_path)

# import or paste dataset here
File0 = open('engagement_0.txt')
data0 = File0.readlines()
data0 = [float(x) for x in data0]
File0.close()

File1 = open('engagement_1.txt')
data1 = File1.readlines()
data1 = [float(j) for j in data1]
File1.close()


# code for question 2
print('Problem 2 Answers:')
# code below this line

null_1= 0.75

size_1 = len(data1)
print("Sample size is:", size_1)
mean_1 = np.mean(data1)
print("Mean is:", mean_1)
stdev_1 = np.std(data1, ddof=1)
sterr_1 = stdev_1 / (size_1 ** 0.5)
print("Standard Error is:", sterr_1)
stscore_1 = (mean_1 - null_1) / sterr_1
print("Standard Score is:", stscore_1)
pval_1 = 2 * stats.norm.cdf(-abs(stscore_1))
print("P value is:", pval_1)

if pval_1 < 0.05:
    print("We can reject the null hypothesis for the 95% confidence level, and the p-value is not statistically significant.")
else:
    print("We failed to reject the null hypothesis for the 95% confidence level, and the p-value is statistically significant.")

if pval_1 < 0.1:
    print("We can reject the null hypothesis for the 90% confidence level, and the p-value is not statistically significant.")
else:
    print("We failed to reject the null hypothesis for the 90% confidence level, and the p-value is statistically significant.")

# code for question 3
print('Problem 3 Answers:')
# code below this line

alpha = 0.05

stdev_alpha = norm.ppf(alpha)
sterr_alpha = (mean_1 - null_1) / stdev_alpha
size_alpha = (stdev_1 / sterr_alpha) ** 2

print("At a level of 0.05, the largest standard error for which the test will be significant is:", sterr_alpha)
print("The minimum sample size is:", int(size_alpha))

# code for question 5
print('Problem 5 Answers:')

null_0 = 0.75

size_0 = len(data0)
print("Sample size is:", size_0)
mean_0 = np.mean(data0)
print("Mean is:", mean_0)
stdev_0 = np.std(data0, ddof=1)
sterr_0 = stdev_0 / (size_0 ** 0.5)
print("Standard Error is:", sterr_0)
stscore_0 = (mean_0 - null_0) / sterr_0
print("Standard Score is:", stscore_0)
pval_0 = 2 * stats.norm.cdf(-abs(stscore_0))
print("P value is:", pval_0)

if pval_0 < 0.05:
    print("We can reject the null hypothesis for the 95% confidence level, and the p-value is not statistically significant.")
else:
    print("We failed to reject the null hypothesis for the 95% confidence level, and the p-value is statistically significant.")

if pval_0 < 0.1:
    print("We can reject the null hypothesis for the 90% confidence level, and the p-value is not statistically significant.")
else:
    print("We failed to reject the null hypothesis for the 90% confidence level, and the p-value is statistically significant.")
# code below this line


