import numpy as np
import pandas as pd
from sklearn.linear_model import Ridge
from sklearn.model_selection import train_test_split
from sklearn import linear_model

import matplotlib.pyplot as plt


# Part 1
# Function that normalizes features in training set to zero mean and unit variance.
# Input: training data X_train
# Output: the normalized version of the feature matrix: X, the mean of each column in
# training set: trn_mean, the std dev of each column in training set: trn_std.
def normalize_train(X_train):
    if len(X_train) == 0:
        return [], [], []

    X = X_train.copy()
    mean = []
    std = []

    for j in range(len(X_train[0])):
        column = X_train[:, j]
        mean.append(np.mean(column))
        std.append(np.std(column))
        column = (column - mean[-1]) / std[-1]

        X[:, j] = column

    return X, mean, std


# Part 2
# Function that normalizes testing set according to mean and std of training set
# Input: testing data: X_test, mean of each column in training set: trn_mean, standard deviation of each
# column in training set: trn_std
# Output: X, the normalized version of the feature matrix, X_test.
def normalize_test(X_test, trn_mean, trn_std):
    X = X_test.copy()
    x, y = X_test.shape

    for k in range(y):
        X[:, k] = X[:, k] - trn_mean[k]
        X[:, k] = X[:, k] / trn_std[k   ]

    return X


# Part 3
def get_lambda_range():
    rng = np.logspace(start=-1, stop=3, num=51, base=10.0)

    return rng
    # Comment out 'pass' after completing this function
    # pass


# Part 4
# Function that trains a ridge regression model on the input dataset with lambda=l.
# Input: Feature matrix X, target variable vector y, regularization parameter l.
# Output: model, a numpy object containing the trained model.
def train_model(X, y, l):
    model = Ridge(alpha=l, fit_intercept=True)
    model.fit(X, y)
    return model


# Part 5
# Function that calculates the mean squared error of the model on the input dataset.
# Input: Feature matrix X, target variable vector y, numpy model object
# Output: mse, the mean squared error
def error(X, y, model):
    predict = model.predict(X)

    mse = ((y - predict) ** 2).mean()
    return mse


def main():
    # Importing dataset
    # step 1 : read csv
    df = pd.read_csv("AAPL.csv")
    # step 2 : identify the column(s) we want to remove
    remove_features = ["Date"]
    # step 3: create extra column for prediction by shifting
    # rows of `Close` columns by one to obtain next day's closing price
    df["Prediction"] = pd.Series(np.append(df["Close"][1:].to_numpy(), [0]))
    # step 4: drop the last row because it would have invalid value after the shift.
    df.drop(df.tail(1).index, inplace=True)
    # step 5: remove the columns identified in step 2
    df.drop(remove_features, axis=1, inplace=True)
    # step 6: create X by dropping the `Prediction` column
    X = np.array(df.drop(["Prediction"], axis=1))
    # step 7: Store `Prediction` column in y array
    y = np.array(df["Prediction"])
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, shuffle=False
    )

    # Normalizing training and testing data
    [X_train, trn_mean, trn_std] = normalize_train(X_train)
    X_test = normalize_test(X_test, trn_mean, trn_std)

    # Define the range of lambda to test
    lmbda = get_lambda_range()
    # lmbda = [1,3000]
    MODEL = []
    MSE = []
    for l in lmbda:
        # Train the regression model using a regularization parameter of l
        model = train_model(X_train, y_train, l)

        # Evaluate the MSE on the test set
        mse = error(X_test, y_test, model)

        # Store the model and mse in lists for further processing
        MODEL.append(model)
        MSE.append(mse)
    # Part 6
    # Plot the MSE as a function of lmbda
    plt.figure()
    plt.plot(lmbda, MSE)
    plt.xlabel("Lambda Value")
    plt.ylabel("Mean Squared Error Value")
    plt.title("Mean Square Error as a Function of Lambda in Ridge Regression")

    # part 7
    # Find best value of lmbda in terms of MSE
    ind = np.argmin(MSE)
    [lmda_best, MSE_best, model_best] = [lmbda[ind], MSE[ind], MODEL[ind]]

    print(
        "Best lambda tested is "
        + str(lmda_best)
        + ", which yields an MSE of "
        + str(MSE_best)
    )
    # Part 8
    # Load GOOG.csv similar to steps 1-5 (where AAPL.csv is loaded)
    
    data = pd.read_csv('GOOG.csv')
    remove_features = ['Date']
    data['Prediction'] = pd.Series(np.append(data['Close'][1:].to_numpy(), [0]))
    data.drop(data.tail(1).index, inplace=True)
    data.drop(remove_features, axis=1, inplace=True)
    X_prediction = np.array(data.drop(['Prediction'], axis=1))
    y_prediction = np.array(data['Prediction'])

    X_prediction = normalize_test(X_prediction, trn_mean, trn_std)
    y_hat = model.predict(X_prediction)

    plt.figure()
    plt.plot(y_hat, label='prediction')
    plt.plot(y_prediction, label='actual')
    plt.legend(fontsize=10, loc='upper left')
    plt.title('Google Test')

    plt.show()
    return model_best


if __name__ == '__main__':
    model_best = main()
    print(model_best.coef_)
    print(model_best.intercept_)