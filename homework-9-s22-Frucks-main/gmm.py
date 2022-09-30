import numpy as np
from sklearn.mixture import GaussianMixture

def gaus_mixture(data, n_components):

    """Performs gaussian mixture model clustering.

    Args:
      data: an n-by-1 numpy array of numbers with n data points
      n_components: a list of digits that are possible candidates for the number of clusters to use

    Returns:
      A single digit (which is an element from n_components) that results in the lowest
      BIC when it is used as the number of clusters to fit a GMM

    """

    # initialize best number of clusters to first element in n_components by
    # (1) fitting a GMM on `data` using the first element in `n_components` as the number
    # of clusters (remember to set random_state=0 when you call GaussianMixture()),
    # (2) calculating the bic on `data` and making it the best bic, and (3) setting the
    # corresponding number of cluster (i.e., the first element of `n_components`
    # as the best number of clusters
    gm = GaussianMixture(
        n_components=n_components[0], random_state=0).fit(data)# fill in
    best_bic = gm.bic(data)# fill in
    best_no_clusters = n_components[0] # fill in

    # for all different k values in n_components, make GMM model and calculate BIC
    for i in n_components:

        # fit GMM (remember to set random_state=0 when you call GaussianMixture())
        gm = GaussianMixture(n_components=k, random_state=0).fit(data)
        # calculate BIC
        bic = gm.bic(data)
        # if current BIC is lowest, make it the best BIC and make its corresponding k the best_no_clusters
        if bic < best_bic:
            best_bic = bic
            best_no_clusters = i

    return best_no_clusters


if __name__ == "__main__":
    # load data and reshape to work with GMM implementation
    X = np.genfromtxt('gmm_data.csv', delimiter=',')
    X = np.reshape(X, (150, 1))

    # call function and get output
    best_k = gaus_mixture(data=X, n_components=[2, 3, 4, 6, 7, 8])
    print('Best fit is when k = %d clusters are used' % (best_k))
