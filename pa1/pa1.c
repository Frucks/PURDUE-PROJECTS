#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include "shell_array.h"
#include "shell_list.h"

int main(int argc, char *argv[])
{
  char * input = argv[2];
  char * output = argv[3];
  int size = 0;
  long * longArr;
  long n_comp = 0;
  if(strcmp(argv[1],"-a") == 0)
  {
  longArr = Array_Load_From_File(input, &size);
  if (longArr == NULL)
  {
    exit(EXIT_FAILURE);
  }
  Array_Shellsort(longArr, size, &n_comp);
  Array_Save_To_File(output, longArr, size);
  printf("%ld\n", n_comp);
  free(longArr);
  }

  if(strcmp(argv[1],"-l") == 0)
  {
    Node * head = List_Load_From_File(input);
    head = List_Shellsort(head, &n_comp);
    size = List_Save_To_File(output, head); 
    printf("%ld\n", n_comp);
    if (head != NULL)
    {
      while(head->next != NULL)
      {
        Node * temp = head->next;
        free(head);
        head = temp;
      }
      free(head);
    }
  }
  return EXIT_SUCCESS;
}