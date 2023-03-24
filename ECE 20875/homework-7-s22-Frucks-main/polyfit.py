import matplotlib.pyplot as plt
import numpy as np
import os
hw7_path = '/home/shay/a/jtafffre/homework-7-s22-Frucks'
os.chdir(hw7_path)

# Return fitted model parameters to the dataset at datapath for each choice in degrees.
# Input: datapath as a string specifying a .txt file, degrees as a list of positive integers.
# Output: paramFits, a list with the same length as degrees, where paramFits[i] is the list of
# coefficients when fitting a polynomial of d = degrees[i].
def main(datapath, degrees):
    paramFits = []
    
    with open(datapath, 'r') as data:
        lines = data.readlines()
    samples = [j.strip().split(" ") for j in lines]
    x = []
    y = []

    for k in samples:
        x.append(float(k[0]))   
        y.append(float(k[1]))    
    
    for l in degrees:
        featureMatrix = feature_matrix(x, l)
        paramFits.append(least_squares(featureMatrix, y))
    
    
    Y_val = []
    for poly in paramFits:
        pow = np.arange(len(poly)-1, -1, -1)
        yPoly = []
        
        for xSamp in x:
            ySamp = 0
            
            for index in range(len(pow)):
                ySamp += (xSamp ** pow[index]) * poly[index] 
            yPoly.append(ySamp)
            
        Y_val.append(yPoly)
        
    
    plt.figure(1)
    plt.scatter(x,y)
    for index in range(len(paramFits)):
        xPlot, yPlot = zip(*sorted(zip(x, Y_val[index])))
        plt.plot(xPlot,yPlot, label = f'degree = {len(paramFits[index]) - 1}')
    plt.legend()
    plt.show()

    return paramFits 


# Return the feature matrix for fitting a polynomial of degree d based on the explanatory variable
# samples in x.
# Input: x as a list of the independent variable samples, and d as an integer.
# Output: X, a list of features for each sample, where X[i][j] corresponds to the jth coefficient
# for the ith sample. Viewed as a matrix, X should have dimension #samples by d+1.
def feature_matrix(x, d):

    # fill in
    # There are several ways to write this function. The most efficient would be a nested list comprehension
    # which for each sample in x calculates x^d, x^(d-1), ..., x^0.
    X = []
    d = np.array(np.arange(d, -1, -1))
    for sample in x:
        xArr = []
        for degree in d:
            xArr.append(sample ** degree)
        X.append(xArr)   
    
    return X

# Return the least squares solution based on the feature matrix X and corresponding target variable samples in y.
# Input: X as a list of features for each sample, and y as a list of target variable samples.
# Output: B, a list of the fitted model parameters based on the least squares solution.
def least_squares(X, y):
    X = np.array(X)
    y = np.array(y)
    B = np.dot(np.dot(np.linalg.inv(np.dot(X.T, X)),X.T), y)
    return B


if __name__ == "__main__":
    datapath = "poly.txt"
    degrees = [2, 4]
    paramFits = main(datapath, degrees)
    print(paramFits)
