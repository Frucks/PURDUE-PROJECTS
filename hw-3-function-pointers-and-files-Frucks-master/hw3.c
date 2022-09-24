// ***
// *** DO NOT modify this file
// ***
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "hw3.h"
#define TOLERANCE 0.1 // acceptable difference in floating point numbers

// --------------------------------------------------------------
int main(int argc, char * * argv)
{
  if (argc < 3)
    {
      fprintf(stderr, "need the names of input file and output files\n");
      return EXIT_FAILURE;
    }
  if (runIntegrate(argv[1], argv[2]) == false)
    {
      fprintf(stderr, "testIntegrate fail\n");
      return EXIT_FAILURE;
    }
  return EXIT_SUCCESS;
}
