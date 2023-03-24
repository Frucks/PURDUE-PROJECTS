#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include "search.h"

Queue *newNode(int node, short *dist, int prevNode, Queue *queue)
{
  Queue* temp = malloc(sizeof(Queue));
  temp->node = node;
  temp->prev = prevNode;
  temp->next = NULL;

  if (prevNode == -1)
  {
    temp->dist = (int)dist[node];
  }

  else
  {
    temp->dist = (int)dist[node] + queue->dist;
  }

  return temp;
}

Queue *enqueue(Queue *queue, int node, short *dist, int *visited, int prevNode)
{
  if (node != -1 && visited[node])
  {
    return queue;
  }
  Queue *new = newNode(node, dist, prevNode, queue);
  if (queue == NULL)
  {
    queue = new;
    return queue;
  }

  Queue *temp = queue;

  while ((temp->next != NULL) && (temp->next->dist < new->dist))
  {
    temp = temp->next;
  }
  
  if (temp == queue)
  {
    if(temp->dist > new->dist)
    {
      new->next = temp;
      queue = new;
    }
    else
    {
      new->next = temp->next;
      temp->next = new;
    }
    return queue;
  }

  if (temp->next == NULL)
  {
    temp->next = new;
    return queue;
  }

  if (temp->next->dist == new->dist)
  {
    if(new->node > temp->next->node || temp->next->prev == -1)
    {
      new->next = temp->next;
      temp->next = new;
    }
    else
    {
      new->next = temp->next->next;
      temp->next->next = new;
    }
  }

  else
  {
    new->next = temp->next;
    temp->next = new;
  }

  return queue;
}

Queue *buildQueue(Queue *queue, int node, int cols, int rows, short *dist, int *visited)
{
  int col = (int)(node % cols);
  int row = (int)(node / cols);

  if (row == 0)
  {
    if (col == 0)
    {
      queue = enqueue(queue, node + 1, dist, visited, node);
      queue = enqueue(queue, node + cols, dist, visited, node);
    }
    else if (col == (cols - 1))
    {
      queue = enqueue(queue, node - 1, dist, visited, node);
      queue = enqueue(queue, node + cols, dist, visited, node);
    }

    else
    {
      queue = enqueue(queue, node + 1, dist, visited, node);
      queue = enqueue(queue, node - 1, dist, visited, node);
      queue = enqueue(queue, node + cols, dist, visited, node);
    }
  }

  else if (row == (rows - 1))
  {
    if (col == 0)
    {
      queue = enqueue(queue, node + 1, dist, visited, node);
      queue = enqueue(queue, node - cols, dist, visited, node);
    }
    else if (col == (cols - 1))
    {
      queue = enqueue(queue, node - 1, dist, visited, node);
      queue = enqueue(queue, node - cols, dist, visited, node);
    }

    else
    {
      queue = enqueue(queue, node + 1, dist, visited, node);
      queue = enqueue(queue, node - 1, dist, visited, node);
      queue = enqueue(queue, node - cols, dist, visited, node);
    }    
  }

  else
  {
    if (col == 0)
    {
      queue = enqueue(queue, node + 1, dist, visited, node);
      queue = enqueue(queue, node - cols, dist, visited, node);
      queue = enqueue(queue, node + cols, dist, visited, node);
    }
    else if (col == (cols - 1))
    {
      queue = enqueue(queue, node - 1, dist, visited, node);
      queue = enqueue(queue, node - cols, dist, visited, node);
      queue = enqueue(queue, node + cols, dist, visited, node);
    }

    else
    {
      queue = enqueue(queue, node + 1, dist, visited, node);
      queue = enqueue(queue, node - 1, dist, visited, node);
      queue = enqueue(queue, node - cols, dist, visited, node);
      queue = enqueue(queue, node + cols, dist, visited, node);
    }
  }

  return queue;
}

int dijkstra(int total, int cols, int rows, short *dist, int *prev, int *pathTimes, int *fastest)
{
  int count = 0;
  int lastCount = 0;
  int *visited = calloc(total, sizeof(int));
  int fastNode = -1;
  Queue *queue = NULL;

  for (int i = total - cols; i < total; i++) 
  {
    queue = enqueue(queue, i, dist, visited, -1);
  }

  int node = queue->node;

  while (count < total)
  {
    if (visited[node])
    {
      Queue *temp = queue;
      queue = queue->next;
      free(temp);
      node = queue->node;
    }
    else
    {

      if (node < (cols))
      {
        if (lastCount == 0)
        {
          *fastest = queue->dist;
          fastNode = node;
          lastCount = 1;
        }

        pathTimes[node] = queue->dist;
      }

      visited[node] = 1;

      prev[queue->node] = queue->prev;

      queue = buildQueue(queue, node, cols, rows, dist, visited);
      count++;

      Queue *temp = queue;
      queue = queue->next;
      free(temp);
      node = queue->node;
    }
  }
  
  prev[queue->node] = queue->prev;

  while (queue->next != NULL)
  {
    Queue *temp = queue;
    queue = queue->next;
    free(temp);
  }
  
  free(queue);
  free(visited);

  return fastNode;
}

short * buildGrid(FILE *input, FILE *text, int *rows, int *cols)
{
  fseek(input, 0L, SEEK_SET);
  fread(rows, sizeof(short), 1, input);
  fread(cols, sizeof(short), 1, input);
  fprintf(text, "%hd %hd\n", *rows, *cols);
  int total = (*rows) * (*cols);

  int col;
  short temp;
  short *dist = malloc(total * sizeof(short));
  for (int i = 0; i < total; i++)
  {
    col = (int)(i % *cols);

    fread(&temp, sizeof(short), 1, input);
    fprintf(text, "%hd", temp);
    dist[i] = temp;

    if(col == (*cols - 1))
    {
      fprintf(text, "\n");
    }
    else
    {
      fprintf(text, " ");
    }
  }

  return dist;
}

void outputFast(FILE *fast, int cols, int *pathTimes)
{
  fwrite(&cols, sizeof(short), 1, fast);
  fwrite(pathTimes, sizeof(int), cols, fast);

  return;
}

void outputPath(FILE *path, int fastest, int fastNode, int total, int cols, int *prev)
{
  int node = fastNode;
  int count = 0;
  int *pathArr = calloc(total, sizeof(int));

  while (node != -1)
  {
    pathArr[count] = node;
    count++;
    node = prev[node];
  }

  fwrite(&fastest, sizeof(int), 1, path);
  fwrite(&count, sizeof(int), 1, path);

  for(int i = 0; i < count; i++)
  {
    node = pathArr[i];
    int col = (int)(node % cols);
    int row = (int)(node / cols);
    fwrite(&row, sizeof(short), 1, path);
    fwrite(&col, sizeof(short), 1, path);
  }

  free(pathArr);
  return;
}