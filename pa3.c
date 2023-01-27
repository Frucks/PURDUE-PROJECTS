#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include "search.h"


int main(int argc, char *argv[])
{
    char * inputArg = argv[1];
    char * textArg = argv[2];
    char * fastArg = argv[3];
    char * pathArg = argv[4];
    FILE * input = fopen(inputArg, "rb");
    FILE * text = fopen(textArg, "w");
    FILE * fast = fopen(fastArg, "wb");
    FILE * path = fopen(pathArg, "wb");

    if ((input == NULL) || (argc != 5))
    {
        exit(EXIT_FAILURE);
    }

    int rows = 0;
    int cols = 0;
    short *dist = buildGrid(input, text, &rows, &cols);
    int total = rows * cols;
    int fastNode;
    int fastest;
    int *prev = malloc(total * sizeof(int));
    int *pathTimes = malloc(cols * sizeof(int));

    fastNode = dijkstra(total, cols, rows, dist, prev, pathTimes, &fastest);

    outputFast(fast, cols, pathTimes);
    outputPath(path, fastest, fastNode, total, cols, prev);
    free(prev);
    free(pathTimes);
    free(dist);
    fclose(input);
    fclose(text);
    fclose(fast);
    fclose(path);

    return EXIT_SUCCESS;
}