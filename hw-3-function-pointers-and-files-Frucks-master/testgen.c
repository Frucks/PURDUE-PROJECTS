// * DO NOT MODIFY THIS FILE * 
// If you modify this file, your program may be incompatible
// in grading and you may lose points.
// 
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "hw3.h"

static bool  genIntegrate(char * filename, double lowerlimit,
			  double upperlimit, int numintvl)
{
  FILE * fptr = fopen(filename, "w");
   if (fptr == NULL)
    {
      fprintf(stderr, "fopen fail\n");
      return false;
    }
   double val = func1(1234);
   printf("%f\n", val);
   funcptr funcs[] = {func1, func2, func3, func4, func5};
   int numfunc = sizeof(funcs) / sizeof(funcptr);
   Integration intrg;
   intrg.lowerlimit = lowerlimit;
   intrg.upperlimit = upperlimit;
   intrg.intervals    = numintvl;
   printf("lowerlimit = %f\n", intrg.lowerlimit);
   printf("upperlimit = %f\n", intrg.upperlimit);
   printf("intervals    = %d\n", intrg.intervals);
   fprintf(fptr, "%f\n", intrg.lowerlimit);
   fprintf(fptr, "%f\n", intrg.upperlimit);
   fprintf(fptr, "%d\n", intrg.intervals);
   for (int ind = 0; ind < numfunc; ind ++)
     {
       intrg.func = funcs[ind];
       integrate(& intrg);
       double answer = intrg.answer;
       printf("answer       = %f\n", answer);
       fprintf(fptr, "%f\n", answer);
     }
   fclose (fptr);
   return true;
}

// --------------------------------------------------------------
int main(int argc, char * * argv)
{
  // argv[1]: output file name
  // argv[2]: lower limit
  // argv[3]: upper limit
  // argv[4]: number of intervals
  if (argc < 5)
    {
      return EXIT_FAILURE;
    }
  double lowerlimit = strtod(argv[2], NULL);
  double upperlimit = strtod(argv[3], NULL);
  int numintvl = (int) strtol(argv[4], NULL, 10);
  if (lowerlimit >= upperlimit)
    {
      return EXIT_FAILURE;
    }
  if (numintvl <= 0)
    {
      return EXIT_FAILURE;
    }
  if (genIntegrate(argv[1], lowerlimit, upperlimit, numintvl) == false)
    {
      fprintf(stderr, "genIntegrate fail\n");
      return EXIT_FAILURE;
    }
  return EXIT_SUCCESS;
}
