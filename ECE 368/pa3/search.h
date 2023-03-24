#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

typedef struct _Queue {
    int node;
    int dist;
    int prev;
    struct _Queue *next; 
} Queue;

void outputFast(FILE *fast, int cols, int *pathTimes);
short * buildGrid(FILE *input, FILE *text, int *rows, int *cols);
int dijkstra(int total, int cols, int rows, short *dist, int *prev, int *pathTimes, int *fastest);
Queue *enqueue(Queue *queue, int node, short *dist, int *visited, int prevNode);
Queue *newNode(int node, short *dist, int prevNode, Queue *queue);
Queue *buildQueue(Queue *queue, int node, int cols, int rows, short *dist, int *visited);
void outputPath(FILE *path, int fastest, int fastNode, int total, int cols, int *prev);
