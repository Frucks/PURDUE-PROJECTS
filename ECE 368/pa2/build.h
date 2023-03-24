#ifndef __BUILD_TREE__
#define __BUILD_TREE__
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include "hbt.h"

Tnode * new_node(int key);
Tnode * build_tree(FILE *input, Tnode *tree, int *inputCheck);
Tnode * insert_node(Tnode *tree, Tnode * head, Tnode *newNode, int *rotFactor, int *prevBal);
void printTree(Tnode * tree, int height);
Tnode * rotate(Tnode *tree, Tnode *head, Tnode *parent);
Tnode *rotate_left(Tnode *tree, Tnode *head, Tnode *parent, Tnode *child);
Tnode *rotate_right(Tnode *tree, Tnode *head, Tnode *parent, Tnode *child);
Tnode * delete_node(Tnode *tree, Tnode *head, Tnode *predecessor, int key, int *predFactor, int *prevBal);
Tnode * find_pred(Tnode *tree, Tnode *head, Tnode *predecessor, int *predFactor);
void output_tree(FILE *output, Tnode *head);
void evaluate(FILE *input, int key, char branch, int *inputCheck, int *bstCheck, int *heightCheck);
void check_bst(int *key_arr, char *branch_arr, int *heightLeft, int *heightRight, int *bstCheck, int *heightCheck, int *minKey, int *maxKey, int *count, int size);
int max(int x1, int x2);
int min(int x1, int x2);

#endif