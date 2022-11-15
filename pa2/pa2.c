#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include "hbt.h"
#include "build.h"

int main(int argc, char *argv[])
{
    char * flag = argv[1];
    char * inputArg = argv[2];

    if (strcmp(flag,"-b") == 0)
    {
        char * outputArg = argv[3];
        FILE * input = fopen(inputArg, "rb");
        FILE * output = fopen(outputArg, "wb");
        int inputCheck = 0;

        if (input == NULL)
        {
            printf("%d\n", -1);
            exit(EXIT_FAILURE);
        }

        Tnode * tree = NULL;   
        tree = build_tree(input, tree, &inputCheck);

        output_tree(output, tree);

        fclose(input);
        fclose(output);

        if (inputCheck == -1)
        {
            printf("%d\n", 0);
            exit(EXIT_FAILURE);
        }
    }

    else if (strcmp(flag,"-e") == 0)
    {
        FILE * input = fopen(inputArg, "rb");
        int inputCheck;
        int bstCheck;
        int heightCheck;
        int key = 0;
        char branch = 0;

        if (input == NULL)
        {
            inputCheck = -1;
        }

        else
        {
            evaluate(input, key, branch, &inputCheck, &bstCheck, &heightCheck);
        }


        if (inputCheck == -1 || inputCheck == 0)
        {
            printf("%d, %d, %d\n", inputCheck, 0, 0);
        }

        else
        {
            printf("%d, %d, %d\n", inputCheck, bstCheck, heightCheck);
        }

    }

    return EXIT_SUCCESS;
}