import pandas
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import Ridge
from sklearn.metrics import r2_score
import scipy


__course__ = 'ECE 20875'
__authors__ = ['Mateusz Romaniuk', 'Joao Freire']
__date__ = '2022/04/24'
__description__ = 'The final mini-project for the class. The code covers path number 1'



"""The function trains the model.
Args:
X: feature matrix.
y: target vector.
l: regulirization parameter.
Returns:
return: a trained model.
"""
def train_model(X,y,l):

    model = Ridge(alpha = l, fit_intercept=True)
    model.fit(X,y)
    return model

"""Calculates the MSE error.
Args:
X: feature matrix.
y: target vector.
model: trained model.
Returns:
return: calculated error.
"""
def calculateMSE(X,y,model):

    y = np.array(y)
    predictY = model.predict(X)
    mse = np.mean((y-predictY)**2)
    return mse

"""Reads Excel file.
Args:
filename: the name of the file to read.
Returns:
return: the data type.
"""
def readExcelFile(filename):

    dataset_1 = pandas.read_csv('NYC_Bicycle_Counts_2016_Corrected.csv')
    dataset_1['Brooklyn Bridge']      = pandas.to_numeric(dataset_1['Brooklyn Bridge'].replace(',','', regex=True))
    dataset_1['Manhattan Bridge']     = pandas.to_numeric(dataset_1['Manhattan Bridge'].replace(',','', regex=True))
    dataset_1['Queensboro Bridge']    = pandas.to_numeric(dataset_1['Queensboro Bridge'].replace(',','', regex=True))
    dataset_1['Williamsburg Bridge']  = pandas.to_numeric(dataset_1['Williamsburg Bridge'].replace(',','', regex=True))
    dataset_1['Williamsburg Bridge']  = pandas.to_numeric(dataset_1['Williamsburg Bridge'].replace(',','', regex=True))
    dataset_1['Total']                = pandas.to_numeric(dataset_1['Total'].replace(',','', regex=True))


    return dataset_1

"""Normalize the training data.
Args:
X_train: the feature matrix.
Returns:
return: normilized feature matrix.
"""
def normalize_train(X_train):
    X_train = np.array(X_train).transpose()
    std = []
    mean = []
    X = []
    
    for sideColumn in X_train:
        stdDevColumn = np.std(sideColumn)
        std.append(stdDevColumn)
        meanColumn = np.mean(sideColumn)
        mean.append(meanColumn)
        columnList = []
        for index in range(len(sideColumn)):
            columnList.append((sideColumn[index] - meanColumn) / stdDevColumn)       
        X.append(columnList)    
    
    return np.array(X).T, np.array(mean), np.array(std)

"""Normalize the testing data.
Args:
X_test: the feature matrix.
trn_mean: mean value
trn_std: standard deviation
Returns:
return: normilized feature matrix.
"""
def normalize_test(X_test, trn_mean, trn_std):
    
    X = []
    #fill in
    X_test = np.array(X_test).transpose()
    for sideColumnIndex in range(len(X_test)):
        
        columnList = []

        for index in range(len(X_test[sideColumnIndex])):
            columnList.append((X_test[sideColumnIndex][index] - trn_mean[sideColumnIndex]) / trn_std[sideColumnIndex])
        X.append(columnList) 
        
    return np.array(X).T

"""Creates the model based on the feature matrix and target.
Args:
X: the feature matrix.
y: the target
Returns:
return: the model.
"""
def createModel(X, y):

    [X_train, X_test, y_train, y_test] = train_test_split(X, y, test_size=0.25, random_state=101)

    [X_train, trn_mean, trn_std] = normalize_train(X_train)

    X_test = normalize_test(X_test, trn_mean, trn_std)

    lmbda = np.logspace(-1,2,num=51)
    
    MODEL = []
    MSE = []
    for l in lmbda:
        model = train_model(X_train,y_train,l)
        mse = calculateMSE(X_test,y_test,model)
        MODEL.append(model)
        MSE.append(mse)

    plt.figure(1)
    plt.plot(lmbda, MSE)
    plt.xlabel("Lambda values")
    plt.ylabel("Mean Squared Errors")
    plt.title("Graph of MSE vs Lambda")
    plt.show()

    ind = MSE.index(min(MSE))
    
    [lmda_best,MSE_best,model_best] = [lmbda[ind],MSE[ind],MODEL[ind]]

    print('Best lambda: ' + str(lmda_best) + ', that give the MSE of ' + str(MSE_best))
    y_pred	= model_best.predict(X_test)
    
    print(r2_score(y_pred, y_test))

    return model_best

if __name__ == '__main__':

    print("\n" +'# ' + '=' * 78)
    print('Authors: '  + ', '.join(__authors__))
    print('Course: ' + __course__)
    print('Date: ' + __date__)
    print('Description: ' + __description__)
    print('# ' + '=' * 78 + "\n")

    data = readExcelFile('NYC_Bicycle_Counts_2016_Corrected.csv')
    

    print("\n" +'# ' + '=' * 78)
    print("Problem 1")
    print('# ' + '=' * 78 + "\n")

    plt.hist(data['Brooklyn Bridge'].values, alpha=0.5, label='Brooklyn Bridge')
    plt.hist(data['Manhattan Bridge'].values, alpha=0.5, label='Manhattan Bridge')
    plt.hist(data['Queensboro Bridge'].values, alpha=0.5, label='Queensboro Bridge')
    plt.hist(data['Williamsburg Bridge'].values, alpha=0.5, label='Williamsburg Bridge')
    labels= ["Brooklyn Bridge","Manhattan Bridge", "Queensboro Bridge", "Williamsburg Bridge"]
    plt.legend(labels)
    plt.show()

    manhattanAVG = np.average(data['Manhattan Bridge'])
    brooklynAVG = np.average(data['Brooklyn Bridge'])
    williamsburgAVG = np.average(data['Williamsburg Bridge'])
    queensboroAVG = np.average(data['Queensboro Bridge'])
    totalAVG = np.average(data['Total'])
    totalAvgDivided = totalAVG / 4

    print('Manhattan Bridge:')
    print(manhattanAVG)
    print('Brooklyn Bridge:')
    print(brooklynAVG)
    print("Queensboro Bridge:")
    print(queensboroAVG)
    print('Williamsburg Bridge:')
    print(williamsburgAVG)
    print('Total:')
    print(totalAvgDivided)

    print("\n" +'# ' + '=' * 78)
    print("Problem 2")
    print('# ' + '=' * 78 + "\n")

    highTemp = data['High Temp']
    lowTemp = data['Low Temp']
    precipitation = data['Precipitation']
    avgTemp = np.array([])
    for iteration in range(len(highTemp)):
        step = ( highTemp[iteration] + lowTemp[iteration] ) /2
        avgTemp = np.append(avgTemp,step)
        


    X = np.array([precipitation, lowTemp, highTemp]).T
    y = np.array(data['Total'])
    model = createModel(X,y)

    print(model.coef_)
    print(model.intercept_)

    print("\n" + '# ' + '=' * 78)
    print("Problem 3")
    print('# ' + '=' * 78 + "\n")

    total = data['Total']

    trafficPrecipitation = []
    trafficNOprecipitation = []
    for iteration in range(len(precipitation)):
        if  precipitation[iteration] > 0 :
            trafficPrecipitation.append(float(total[iteration]))
        elif  precipitation[iteration] <= 0:
            trafficNOprecipitation.append(float(total[iteration]))

    [trafPrecipitation_train, trafPrecipitation_test] = train_test_split(trafficPrecipitation,test_size=0.25, random_state=101)  
    [trafNOprecipitation_train, trafNOprecipitation_test] = train_test_split(trafficNOprecipitation, test_size=0.25, random_state=101) 

    mean_precipitation = np.mean(trafPrecipitation_train)
    standard_deviation_precipitation = np.std(trafPrecipitation_train)

    x_values_precipitation = np.arange(0, 35000, 1)
    y_values_precipitation = scipy.stats.norm(mean_precipitation, standard_deviation_precipitation)

    mean_NOprecipitation = np.mean(trafNOprecipitation_train)
    standard_deviation_NOprecipitation = np.std(trafNOprecipitation_train)

    x_values_NOprecipitation = np.arange(0, 35000, 1)
    y_values_NOprecipitation = scipy.stats.norm(mean_NOprecipitation, standard_deviation_NOprecipitation)

    plt.figure(1)
    plt.plot(x_values_precipitation, y_values_precipitation.pdf(x_values_precipitation),label ="Precipitation Day")
    plt.plot(x_values_NOprecipitation,y_values_NOprecipitation.pdf(x_values_NOprecipitation), label ="No Precipitation Day")
    plt.xlabel('Cyclists in a day')
    plt.ylabel('Probability in %')
    plt.legend()
    plt.title("Gaussian Distributions")

    plt.show()

    correct_predic =[]
    wrong_predict = []
    for iteration, value in enumerate(trafPrecipitation_test):
        if  y_values_precipitation.pdf(x_values_precipitation)[int(value)-1] > y_values_NOprecipitation.pdf(x_values_NOprecipitation)[int(value)-1]:
            correct_predic.append(value)
        else:
            wrong_predict.append(value)
    precipitation_correct_len = len(correct_predic)
    precipitation_accuracy = 100* len(correct_predic)/ ( len(wrong_predict) + len(correct_predic))
    for iteration, value in enumerate(trafNOprecipitation_test):
        if  y_values_NOprecipitation.pdf(x_values_NOprecipitation)[int(value)-1] > y_values_precipitation.pdf(x_values_precipitation)[int(value)-1]:
            correct_predic.append(value)
        else:
            wrong_predict.append(value)
    NOprecipitation_accuracy = 100* ( len(correct_predic) - precipitation_correct_len )/ len(trafNOprecipitation_test)
    print("Accuracy of raining day tests:",precipitation_accuracy,'%' )
    print("Accuracy of no precipitation day tests:",NOprecipitation_accuracy,'%' )
    print('Total accuracy:', 100* len(correct_predic)/ ( len(wrong_predict) + len(correct_predic)),'%' )     