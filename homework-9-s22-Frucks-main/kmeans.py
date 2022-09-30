import numpy as np
from cluster import createClusters
from point import makePointList


def kmeans(point_data, cluster_data):
    """Performs k-means clustering on points.

    Args:
      point_data: a k-by-d numpy array used for creating a list of Points.
      cluster_data: A k-by-d numpy array used for creating a list of Clusters.

    Returns:
      A list of clusters (with update centers) after peforming k-means
      clustering on the points initialized from point_data
    """
    # Fill in

    # 1. Make list of points using makePointList and point_data

    # 2. Make list of clusters using createClusters and cluster_data

    # 3. As long as points keep moving:

    #   A. Move every point to its closest cluster (use Point.closest and
    #     Point.moveToCluster)
    #     Hint: keep track here whether any point changed clusters by
    #           seeing if any moveToCluster call returns "True"

    #   B. Update the centers for each cluster (use Cluster.updateCenter)

    # 4. Return the list of clusters, with the centers in their final positions
    
    pnt_list = makePointList(point_data)  # step 1

    clusters = createClusters(cluster_data)  # step 2

    move_point = True
    while (move_point):
        move_point = False
        for point in pnt_list:
            # step 3, adding points to the cluster
            cluster_name = point.closest(clusters)
            move_point |= point.moveToCluster(cluster_name)
        for clstr in clusters:
            clstr.updateCenter()
    
    return clusters


if __name__ == "__main__":
    data = np.array(
        [[0.5, 2.5], [0.3, 4.5], [-0.5, 3], [0, 1.2], [10, -5], [11, -4.5], [8, -3]],
        dtype=float,
    )
    centers = np.array([[0, 0], [1, 1]], dtype=float)

    clusters = kmeans(data, centers)
    for c in clusters:
        c.printAllPoints()
