def stencil(data, f, width):
    """

    Params : data(list), f(function), width(int)
    Return : list

    - Perform a stencil using the filter f with width w on list data output the resulting list
    - Note that if len(data) = k, len(output) = k - width + 1; f will accept as input a list of size width and return a single number

    """

    # Fill in

    list = []

    for i,k in enumerate(data):
        if len(list) == len(data) - width + 1:
            break
        list.append(f(data[i: i + width]))

    return list
    pass


def find_covariance_of(series):
    """
    Params  : series : list
    Return  : function, int

    - Create a function to find the covariance between the variable "series" and any input list "window"
    - The function should check if the length of both lists is the same
    - Recall that covariance between two series (lists), let's call them A and B; is calculated as 
        sum( (x_i - u)(y_i - v) )/ N for all i

    - Where,
        - x_i, y_i are the ith elements from A and B respectively
        - u is the mean of list A
        - v is the mean of list B
        - N is the number of elements in either A or B (note that both have to be of the same length.)

    - The function you write should return a function and the width of the sliding window, which is the length of B

    """

    # Fill in
    def covariance(window):
        
        covar = 0

        if len(series) == len(window):

            u = sum(series) / len(series)
            v = sum(window) / len(window)

            for i in range(len(series)):
                covar = covar + ((series[i] - u) * (window[i] - v)) / len(series)

        return covar

    return covariance, len(series)

    pass
        
if __name__ == '__main__':
    def mov_avg(L):
        if len(L) != 3:
            raise ValueError(f'Expected list of length 3 but got list of length {len(L)}.')
        return float(sum(L)) / 3
    
    def sum_sq(L):
        if len(L) != 5:
            raise ValueError(f'Expected list of length 5 but got list of length {len(L)}.')
        return sum([i ** 2 for i in L])
    
    
    data = [2.1,2.5,3.6,4.0,2.0,10.0,12.0,14.0]
    
    print(stencil(data, mov_avg, 3))
    print(stencil(data, sum_sq, 5))
    
    cov1, width1 = find_covariance_of([8.0,10.0,12.0])
    print(stencil(data, cov1, width1))
    
    cov2, width2 = find_covariance_of([2.1,2.5,3.6,4.0,2.0])
    print(stencil(data, cov2, width2))
    
