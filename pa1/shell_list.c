#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include "shell_list.h"

static Node * findSequence(Node * list, int *saved, int * size)
{
  long interval = 1;
  int x = 1;
  Node * sequence = NULL;
  sequence = malloc(sizeof(Node));
  sequence->value = interval;
  sequence->next = NULL;

  Node * temp = NULL;
  Node * head = list;

  while (head->next != NULL)
  {
    head = head->next;
    *size += 1;
  }

  while ((interval * 3 + 1) < *size)
  {
    temp = malloc(sizeof(Node));
    interval = interval * 3 + 1;
    temp->value = interval;
    temp->next = sequence;
    sequence = temp;
    x += 1;
    temp = NULL;
    free(temp);
    }

  *saved = x;
  //temp = NULL;
  //free(temp);
  return sequence;
}

static Node * findPos(Node * head, int pos)
{
  Node * temp = head;
  for (int i = 0; i < pos; i++)
  {
    temp = temp->next;
  }
  return temp;
}

Node *List_Load_From_File(char *filename)
{
  Node * head = NULL;
  int size = 0;
  FILE * input = fopen(filename, "rb");
  if (input == NULL)
  {
    return head;
  }
  fseek(input, 0L, SEEK_END);
  long int bytes = ftell(input);
  size = (int)(bytes / sizeof(long));
  fseek(input, 0L, SEEK_SET);
  Node * temp = NULL;
  Node * last = NULL;

  for (int i = 0; i < size; i++)
  {
    if (head == NULL)
    {
      head = malloc(sizeof(Node));
      fread(head, sizeof(long), 1, input);
      head->next = NULL;
      last = head;
    }
    else
    {
      temp = malloc(sizeof(Node));
      fread(temp, sizeof(long), 1, input);
      temp->next = NULL;
      last->next = temp;
      last = temp;
      temp = NULL;
      free(temp);
    }
  }
  //temp = NULL;
  fclose(input);
  return head;
}

int List_Save_To_File(char *filename, Node *list)
{
  int saved = 0;
  FILE * output = fopen(filename, "wb");
  if (list == NULL)
  {
    fclose(output);
    return 0;
  }


  while (list->next != NULL)
  {
    saved += fwrite(list, sizeof(long), 1, output);
    list = list->next;
  }

  saved += fwrite(list, sizeof(long), 1, output);
  fclose(output);
  return saved;
}

Node *List_Shellsort(Node *list, long *n_comp)
{
  int saved;
  int size = 1;
  if (list == NULL)
  {
    return list;
  }
  Node * sequence = findSequence(list, &saved, &size);
  for (int p = 0; p < saved; p++)
  {
    int k = (int)sequence->value;

    for (int j = k; j < size; j++)
    {
      Node * temp_r = findPos(list, j);
      int i = j;
      while (i >= k && findPos(list, i - k)->value > temp_r->value)
      {
        *n_comp = (*n_comp) + 1;
        Node * arr_ik = findPos(list, i-k);
        Node * temp_r1 = findPos(list, i - 1);
        Node * arr_ik2 = arr_ik->next;
        if ((i - k) == 0)
        {
          arr_ik->next = temp_r->next;
          if(temp_r1->value == arr_ik->value)
          {
            temp_r->next = arr_ik;
          }
          else
          {
            temp_r1->next = arr_ik;
            temp_r->next = arr_ik2;
          }
          list = temp_r;
          i = i - k;
        }
        else
        {
          Node * arr_ik1 = findPos(list, i - k - 1);
          if(temp_r1->value == arr_ik->value)
          {
            arr_ik1->next = temp_r;
            arr_ik->next = temp_r->next;
            temp_r->next = arr_ik;
          }
          else
          {
            arr_ik1->next = temp_r;
            temp_r1->next = arr_ik;
            arr_ik->next = temp_r->next;
            temp_r->next = arr_ik2;
          }
          i = i - k;
        }
      }
    }
    Node * tempseq = sequence->next;
    free(sequence);
    sequence = tempseq;
  }
  sequence = NULL;
  free(sequence);
  return list;
}