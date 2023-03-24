// ***
// *** You MUST modify this file.
// ***

#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#ifdef TEST_COUNTINT
int countInt(char * filename)
{
	// count the number of integers in the file
	// Please notice that if a file contains
	// 124 378 -56
	// There are three integers: 124, 378, -56
	// DO NOT count individual character '1', '2', '4' ...
	//
	// If fopen fails, return -1

	int count = 0;
	int i = 0;

	FILE * input = fopen(filename, "r");

	if (input == NULL)
	{
		fprintf(stderr, "fopen fail\n");
		return -1;
	}

	while(fscanf(input, "%d", &i) == 1)
	{
		count++;
	}

	// remember to fclose if fopen succeeds
	
	fclose(input);

	return count;
}
#endif

#ifdef TEST_READINT
bool readInt(char* filename, int * intArr, int size)
{
	// if fopen fails, return false
	// read integers from the file.
	
        FILE * input = fopen(filename, "r");
	int count = 0;
	
        if (input == NULL)
        {
                fprintf(stderr, "fopen fail\n");
                return false;
        }
	
	for (int i = 0; i < size; i++)
	{
		fscanf(input, "%d", &intArr[i]);
		count++;
	}
	
	// if the number of integers is different from size (too
	// few or too many) return false
	
	int length = count;
	
	if (size != length)
	{
		fclose(input);
		return false;
	}

	// if everything is fine, fclose and return true
	
	fclose(input);

	return true;
}

#endif

#ifdef TEST_COMPAREINT
int compareInt(const void *p1, const void *p2)
{
	// needed by qsort
	
	int * e1 = (int *) p1;
	int * e2 = (int *) p2;
	
	int less = -1;
	int more = 1;
	int equal = 0;

	// return an integer less than, equal to, or greater than zero if
	// the first argument is considered to be respectively less than,
	// equal to, or greater than the second.
	

	if (*e1 < *e2)
	{
		return less;
	}

	else if (*e1 > *e2)
	{
		return more;
	}	

	return equal;
}
#endif

#ifdef TEST_WRITEINT
bool writeInt(char* filename, int * intArr, int size)
{
	// if fopen fails, return false
	// write integers to the file.
	// one integer per line
	
	FILE * output = fopen(filename, "w");

	if (output == NULL)
	{
		fprintf(stderr, "fopen fail\n");
		return false;
	}
	
	
	for (int j = 0; j < size; j++)
	{	
		fprintf(output, "%d\n", intArr[j]);
	}

	// fclose and return true
	
	fclose(output);

	return true;
}
#endif

