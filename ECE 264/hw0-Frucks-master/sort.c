#include "sort.h"

#ifdef DESCENDING
void ssort(int * arr, int size) 
{

	/* For step 3, fill this in to perform a selection sort
	   For step 4, add conditional compilation flags to perform an ascending selection sort instead */

	int i;
	int j;
	int max_idx;

	// One by one move boundary of unsorted subarray

	for (i = 0; i < size - 1; i++)
	{
		// Find the maximum element in unsorted array

		max_idx = i;

		for (j = i + 1; j < size; j++)
		{
			if (arr[j] > arr[max_idx])
			{
				max_idx = j;
			}
		}	

		// Swap the found maximum element with the first element

		int temp = arr[max_idx];
		arr[max_idx] = arr[i];
		arr[i] = temp;
	}

}
#endif

//#ifdef ASCENDING
void ssort(int * arr, int size)
{

	/* For step 3, fill this in to perform a selection sort
	 *            For step 4, add conditional compilation flags to perform an ascending selection sort instead */

	int i;
	int j;
	int min_idx;

	// One by one move boundary of unsorted subarray

	for (i = 0; i < size - 1; i++)
	{
		// Find the maximum element in unsorted array

		min_idx = i;

		for (j = i + 1; j < size; j++)
		{
			if (arr[j] < arr[min_idx])
			{
				min_idx = j;
			}
		}

		// Swap the found maximum element with the first element

		int temp = arr[min_idx];
		arr[min_idx] = arr[i];
		arr[i] = temp;
	}

}
//#endif

