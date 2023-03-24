// * DO NOT MODIFY THIS FILE * 
// If you modify this file, your program may be incompatible
// in grading and you may lose points.
// 
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "hw2.h"

static bool  genIntegrate(char * filename, double lowerlimit,
			  double upperlimit, int numintvl)
{
  FILE * fptr = fopen(filename, "w");
   if (fptr == NULL)
    {
      fprintf(stderr, "fopen fail\n");
      return false;
    }
   Range rng;
   rng.lowerlimit = lowerlimit;
   rng.upperlimit = upperlimit;
   rng.intervals    = numintvl;
#ifdef INTEGRATE_1
   double answer = integrate1(rng);
#endif

   printf("lowerlimit = %f\n", rng.lowerlimit);
   printf("upperlimit = %f\n", rng.upperlimit);
   printf("intervals    = %d\n", rng.intervals);
   printf("answer       = %f\n", answer);

   fprintf(fptr, "%f\n", rng.lowerlimit);
   fprintf(fptr, "%f\n", rng.upperlimit);
   fprintf(fptr, "%d\n", rng.intervals);
   fprintf(fptr, "%f\n", answer);
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
