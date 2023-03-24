// You must modify this file
#ifndef PA05_H
#define PA05_H
#include "constant.h"
#include <stdbool.h>

// create a structure type that has the following attributes
// please make sure the names are exactly the same
//  int- IO
//  char- firstname[NAME_LENGTH]
//  char- lastname[NAME_LENGTH]
typedef struct
{
  int ID;
  char firstname[NAME_LENGTH] ;
  char lastname[NAME_LENGTH] ;
} Student;


bool StudentRead(char * filename, Student * * stu, int * numelem);
bool StudentWrite(char * filename, Student * stu, int numelem);
void StudentPrint(Student * stu, int num);
void sortStudents(Student * stu, int numelem, int (*compar)(const void *, const void *));

// functions to be implemented
int compareID(const void * p1, const void * p2);
int compareFirstName(const void * p1, const void * p2);
int compareLastName(const void * p1, const void * p2);


/* stu: an array of Students. numelem: number of elements in the array. compar: comparison function */
bool areStudentsSorted(Student * stu, int numelem, int (*compar)(const void *, const void *));

#endif
