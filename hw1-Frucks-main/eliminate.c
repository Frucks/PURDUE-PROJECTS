// ***
// *** You MUST modify this file
// ***

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h> 
#include <string.h> 

#ifdef TEST_ELIMINATE
// 100% of the score
void eliminate(int n, int k)
{
	// allocate an arry of n elements
	int * arr = malloc(sizeof(* arr) * n);
	// check whether memory allocation succeeds.
	// if allocation fails, stop
	if (arr == NULL)
	{
		fprintf(stderr, "malloc fail\n");
		return;
	}

	// Note that from here on, you can access elements of the arr with
	// expressions like a[i]

	// initialize all elements

	for (int j = 0; j < n; j++)
	{
		arr[j] = j + 1;
	}
	
	int * removed = malloc(sizeof(* arr) * (n - 1));
	int count = 0;
	int i = -1;
	int j = -1;
	int eliminate = 0;

	// counting to k,
	// mark the eliminated element
	// print the index of the marked element
	// repeat until only one element is unmarked

	while (j < (n - 1))
	{
		i += 1;
		if (arr[i] != 0)
		{	
        	        count += 1;
	                eliminate = count % k;

			if (eliminate == 0)
			{
				j += 1;	
				removed[j] = arr[i] - 1;
				arr[i] = 0;
				
				if (j != (n - 1))
				{
				printf("%d\n", removed[j]);
				}
			}
		}
			if (i == (n - 1))
			{
				i = -1;
			}
	}
	// print the last one

	printf("%d\n", removed[n - 1]);
	
	// release the memory of the array
	
	free (arr);
}
#endif
