// ***
// *** You MUST modify this file.
// ***
#include <stdio.h>
#include <stdbool.h>
#include "hw3.h"

// must enclose the function by #ifdef TEST_INTEGRATE 
// and #endif to enable particial credits
#ifdef TEST_INTEGRATE
void integrate(Integration * intrg)
{
	// integrate the function stored in intrg's func
	// store the result in intrg's answer


	double deltax = (intrg -> upperlimit - intrg -> lowerlimit) / intrg -> intervals;
	double temp = 0;
	double sum = 0;
	double x = 0;

	for (int i = 0; i < intrg -> intervals; i++)
	{

		x = intrg -> lowerlimit + i * deltax;
		temp = intrg -> func(x) * deltax;
		sum += temp;
	}


	intrg -> answer = sum;


}
#endif // TEST_INTEGRATE

// must enclose the function by #ifdef RUN_INTEGRATE
// and #endif to enable particial credits

#ifdef RUN_INTEGRATE
bool  runIntegrate(char * infilename, char * outfilename)
	// return true if it can successfully open and read the input 
	// and open and write the output
	// return false when encountering any problem
{
	// open the input file name for reading

	FILE * input = fopen(infilename, "r");

	// if fopen fails, return false

	if (input == NULL)
	{
		fprintf(stderr, "fopen fail\n");

		return false;
	}


	// read one double from the input file and store it in 
	// intrg's lowerlimit
	// use fscanf
	// check the return value. If the return value is not one
	// close the file and return false

	Integration intrg;

	int scan = fscanf(input, "%lf", &intrg.lowerlimit);

	if (scan != 1)
	{
		fclose(input);

		return false;
	}


	// read one double from the input file and store it in 
	// intrg's upperlimit
	// use fscanf
	// check the return value. If the return value is not one
	// close the file and return false


	scan = fscanf(input, "%lf", &intrg.upperlimit);

	if (scan != 1)
	{
		fclose(input);

		return false;
	}

	// read one int from the input file and store it in 
	// intrg's intervals
	// use fscanf
	// check the return value. If the return value is not one
	// close the file and return false

	scan = fscanf(input, "%d", &intrg.intervals);

	if (scan != 1)
	{
		fclose(input);

		return false;
	}


	// close the input file


	fclose(input);


	// open the output file for writing
	// if fopen fails, return false


	FILE * output = fopen(outfilename, "w");

	if (input == NULL)
	{
		fprintf(stderr, "fopen fail\n");

		return false;
	}


	// create an array of funcptr called funcs with five elements:
	// func1, func2, ..., func5

	funcptr funcs[5] = {func1, func2, func3, func4, func5};

	// go through the elements in funcs 
	// for each element, call integrate for that function
	// write the result (stored in intrg's answer to 
	// the output file. each answer occupies one line (add "\n")
	// use fprintf

	for (int j = 0; j < 5; j++)
	{	
		intrg.func = funcs[j];
		integrate(&intrg);

		int print = fprintf(output, "%lf\n", intrg.answer);



		// check the return value of fprintf. 
		// If it is less one one, close the output
		// file and return false

		if (print < 1)
		{	
			fclose(output);

			return false;
		}

	}





		// after going through all functions in funcs
		// close the output file

	fclose(output);





		// if the function reaches here, return true




		return true;
	}
#endif // RUN_INTEGRATE
