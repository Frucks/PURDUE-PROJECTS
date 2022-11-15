#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

static int * findSequence(int size, int *saved)
{
  int interval = 1; //Initial interval
  int x = 1; //min int for h(x) >= n
  while (interval < size)
  {
    interval = interval * 3 + 1;
    x = x + 1;
  }
   
  interval = interval / 3; //adjust interval
  x = x - 1; //adjust passes
  *saved = x;
  int *sequence = malloc(x * sizeof(int)); //allocate mem for array
  while (x > 0)
  {
    sequence[x - 1] = interval;
    interval = interval / 3;
    x--;
  } //fill sequence with h(x)
  return sequence;
}

long *Array_Load_From_File(char *filename, int *size)
{
  FILE * input = fopen(filename, "rb");

  if (input == NULL)
  {
    *size = 0;
    return NULL;
  }

  fseek(input, 0L, SEEK_END);

  long int bytes = ftell(input);

  long * longArr = malloc(bytes);

  if (longArr == NULL)
  {
    fclose(input);
    *size = 0;
    return NULL;
  }

  *size = (int)(bytes / sizeof(long));

  fseek(input, 0L, SEEK_SET);

  fread(longArr, sizeof(long), *size, input);

  fclose(input);

  return longArr;
}

int Array_Save_To_File(char *filename, long *array, int size)
{
  int saved = 0;

  FILE * output = fopen(filename, "wb");

  if (array == NULL || size == 0)
  {
    fclose(output);
    return saved;
  }

  saved = fwrite(array, sizeof(long), size, output);

  fclose(output);

  return saved;
}

void Array_Shellsort(long *array, int size, long *n_comp)
{
  int saved;
  int *sequence;
  sequence = findSequence(size, &saved);
  for (int p = 0; p < saved; p++)
  {
    int k = sequence[p];

    for (int j = k; j < size; j++)
    {
      long temp_r = array[j];
      int i = j;

      while (i >= k && array[i-k] > temp_r)
      {
        array[i] = array[i-k];
        i = i - k;
        *n_comp = (*n_comp) + 1;
      }

      array[i] = temp_r;
    }
  }
  free(sequence);
}