// You must modify this file
#include "student.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

// --------------------------------------------------------------
int main(int argc, char **argv) {

  // argv[1]: input file name
  // argv[2]: output file name, sorted by ID
  // argv[3]: output file name, sorted by first name
  // argv[4]: output file name, sorted by last name
  if (argc < 5) {
    return EXIT_FAILURE;
  }
  Student *stu;
  int numelem;
  if (StudentRead(argv[1], &stu, &numelem) == false) {
    return EXIT_FAILURE;
  }

  sortStudents(stu, numelem, compareID); // sort students by ID
  if (!areStudentsSorted(stu, numelem, compareID)) {
      return EXIT_FAILURE;
  }
    if (StudentWrite(argv[2], stu, numelem) == false) {
      return EXIT_FAILURE;
    }

  sortStudents(stu, numelem, compareFirstName); //sort students by first name
  if (!areStudentsSorted(stu, numelem, compareFirstName)) {
      return EXIT_FAILURE;
  }
  if (StudentWrite(argv[3], stu, numelem) == false) {
    return EXIT_FAILURE;
  }
  
  sortStudents(stu, numelem, compareLastName); //sort students by last name
  if (!areStudentsSorted(stu, numelem, compareLastName)) {
      return EXIT_FAILURE;
  }
  StudentPrint(stu, numelem);
  if (StudentWrite(argv[4], stu, numelem) == false) {
    return EXIT_FAILURE;
  }
  free(stu);
  return EXIT_SUCCESS;

  return EXIT_SUCCESS;
}
