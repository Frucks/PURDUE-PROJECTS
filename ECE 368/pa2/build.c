#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include "build.h"

Tnode * new_node(int key)
{
    Tnode * newNode = malloc(sizeof(Tnode));
    newNode->key = key;
    newNode->balance = 0x00;
    newNode->left = NULL;
    newNode->right = NULL;

    return newNode;
}

Tnode * build_tree(FILE *input, Tnode *tree, int *inputCheck)
{
    int err_check1 = fseek(input, 0L, SEEK_END);

    if (err_check1 != 0)
    {
        *inputCheck = -1;
        printf("%d\n", 0);
        return tree;
    }

    long int bytes = ftell(input);
    if (bytes % (sizeof(int) + sizeof(char)) != 0)
    {
        *inputCheck = -1;
        printf("%d\n", 0);
        return tree;
    }

    int size = (int)(bytes / (sizeof(int) + sizeof(char)));
    fseek(input, 0L, SEEK_SET);
    int rotFactor = 0;
    int prevBal = 0;
    int predFactor = 0;
    
    for (int i = 0; i < size; i++)
    {
        int key;
        char op;
        int err_check2 = fread(&key, sizeof(int), 1, input);
        int err_check3 = fread(&op, sizeof(char), 1, input);

        if (err_check2 != 1 || err_check3 != 1 || (op != 'i' && op != 'd'))
        {
            *inputCheck = -1;
            printf("%d\n", 0);
            return tree;
        }
        
        if (op == 'i')
        {
            if ((i == 0) || (tree == NULL))
            {
                tree = new_node(key);
            }
            else
            {
                Tnode * newNode = new_node(key);
                Tnode * head = tree;
                rotFactor = 0;
                prevBal = 0;

                tree = insert_node(tree, head, newNode, &rotFactor, &prevBal);

            }
        }

        else if (op == 'd')
        {
            if ((i != 0) && (tree != NULL))
            {
                Tnode * head = tree;
                Tnode * predecessor = head;
                predFactor = 0;

                tree = delete_node(tree, head, predecessor, key, &predFactor, &prevBal);
            }
        }
    }

    printf("%d\n", 1);
    return tree;
}

Tnode * insert_node(Tnode *tree, Tnode * head, Tnode *newNode, int *rotFactor, int *prevBal)
{
    if (newNode->key <= head->key)
    {
        if (head->left == NULL)
        {
            head->left = newNode;
            *prevBal = head->balance;
            head->balance += 1;
            return tree;
        }

        tree = insert_node(tree, head->left, newNode, rotFactor, prevBal);

        if (*rotFactor == 1)
        {
            tree = rotate(tree, head->left, head);
            *rotFactor = -1;
        }

        if ((*rotFactor != -1) && (abs(*prevBal) < abs(head->left->balance)))
        {
            head->balance += 1;
        } 

        if (head->balance == 2)
        {
            if (head == tree)
            {
                tree = rotate(tree, head, head);
                *rotFactor = -1;
            }
            else
            {
                *rotFactor = 1;
            }
        }
    }

    else if (newNode->key > head->key)
    {
        if (head->right == NULL)
        {
            head->right = newNode;
            *prevBal = head->balance;
            head->balance -= 1;
            return tree;
        }

        tree = insert_node(tree, head->right, newNode, rotFactor, prevBal);

        if (*rotFactor == 1)
        {
            tree = rotate(tree, head->right, head);
            *rotFactor = -1;
        }

        if ((*rotFactor != -1) && (abs(*prevBal) < abs(head->right->balance)))
        {
            head->balance -= 1;
        } 

        if (head->balance == -2)
        {
            if (head == tree)
            {
                tree = rotate(tree, head, head);
                *rotFactor = -1;
            }
            else
            {
                *rotFactor = 1;
            }
        }
    }

    return tree;
}

Tnode * rotate(Tnode *tree, Tnode *head, Tnode *parent)
{
    Tnode *child;
    Tnode *grand_child;
    char path[2];

    if (head->balance >= 0)
    {
        child = head->left;
        path[0] = 'l';
        
        if (child->balance >= 0)
        {
            grand_child = child->left;
            path[1] = 'l';
        }
        else
        {
            grand_child = child->right;
            path[1] = 'r';
        }
    }

    else
    {
        child = head->right;
        path[0] = 'r';
        if (child->balance > 0)
        {
            grand_child = child->left;
            path[1] = 'l';
        }
        else
        {
            grand_child = child->right;
            path[1] = 'r';
        }
    }

    if (path[0] == 'l' && path[1] == 'l')
    {
        int c_bal = child->balance;
        tree = rotate_right(tree, head, parent, child);

        if (c_bal == 0)
        {
            child->balance = -1;
            head->balance = 1;
        }
    }

    else if (path[0] == 'r' && path[1] == 'r')
    {
        int c_bal = child->balance;

        tree = rotate_left(tree, head, parent, child);

        if (c_bal == 0)
        {
            child->balance = 1;
            head->balance = -1;
        }
    }

    else if (path[0] == 'l' && path[1] == 'r')
    {
        int gc_bal = grand_child->balance;
        tree = rotate_left(tree, child, head, grand_child);
        tree = rotate_right(tree, head, parent, grand_child);
        if (gc_bal < 0)
        {
            child->balance = 1;
        }
        else if (gc_bal > 0)
        {
            head->balance = -1;
        }
    }

    else if (path[0] == 'r' && path[1] == 'l')
    {
        int gc_bal = grand_child->balance;
        tree = rotate_right(tree, child, head, grand_child);
        tree = rotate_left(tree, head, parent, grand_child);
        if (gc_bal > 0)
        {
            child->balance = -1;
        }
        else if (gc_bal < 0)
        {
            head->balance = 1;
        }

    }

    return tree;
}

Tnode *rotate_left(Tnode *tree, Tnode *head, Tnode *parent, Tnode *child)
{
    if (head == tree)
    {
        head->right = child->left;
        child->left = head;
        head->balance = 0;
        child->balance = 0;
        tree = child;
    }

    else if (parent->left == head)
    {
        head->right = child->left;
        parent->left = child;
        child->left = head;
        head->balance = 0;
        child->balance = 0;
    }
    
    else if (parent->right == head)
    {
        head->right = child->left;
        parent->right = child;
        child->left = head;
        head->balance = 0;
        child->balance = 0;
    }

    return tree;
}

Tnode *rotate_right(Tnode *tree, Tnode *head, Tnode *parent, Tnode *child)
{
    if (head == tree)
    {
        head->left = child->right;
        child->right = head;
        head->balance = 0;
        child->balance = 0;
        tree = child;
    }
    
    else if (parent->left == head)
    {
        head->left = child->right;
        parent->left = child;
        child->right = head;
        head->balance = 0;
        child->balance = 0;
    }
    else if (parent->right == head)
    {
        head->left = child->right;
        parent->right = child;
        child->right = head;
        head->balance = 0;
        child->balance = 0;

    }
    
    return tree;
}

Tnode * delete_node(Tnode *tree, Tnode *head, Tnode *predecessor, int key, int *predFactor, int *prevBal)
{
    if (head->key == key)
    {
        if (head == tree)
        {
            if(head->left == NULL)
            {
                Tnode *temp = head->right;
                free(head);
                tree = temp;

                return tree;
            }
            else
            {
                predecessor = head->left;
                *predFactor = 0;
                *prevBal = predecessor->balance;
                tree = find_pred(tree, head, predecessor, predFactor);
                if(*predFactor == 2)
                {
                    tree = rotate(tree, predecessor, head);
                    *predFactor = 1;
                }

                if ((*predFactor == -2) && (head->left == NULL))
                {
                    *prevBal = head->balance;
                    head->balance -= 1;
                }

                else if ((*predFactor == -2) && (abs(*prevBal) > abs(head->left->balance)))
                {
                    *prevBal = head->balance;
                    head->balance -= 1;
                }

                else if ((*predFactor == 1) && (head->left == NULL))
                {
                    *prevBal = head->balance;
                    head->balance -= 1;
                }

                else if ((*predFactor == 1) && (abs(*prevBal) > abs(head->left->balance)))
                {
                    *prevBal = head->balance;
                    head->balance -= 1;
                }

                if ((head->balance == -2) || (head->balance == 2))
                {
                    tree = rotate(tree, head, head);
                    *predFactor = 3;
                }
            }
        
            return tree;
        }

        else
        {
            if(head->left == NULL)
            {
                *predFactor = -3; // JUST DELETE
                return tree;
            }
            predecessor = head->left;
            *prevBal = predecessor->balance;
            *predFactor = 0;
            tree = find_pred(tree, head, predecessor, predFactor);

            if ((*predFactor == -2) && (head->left == NULL))
            {
                *prevBal = head->balance;
                head->balance -= 1;
            }

            else if ((*predFactor == -2) && (abs(*prevBal) > abs(head->left->balance)))
            {
                *prevBal = head->balance;
                head->balance -= 1;
            }

            else if ((*predFactor == 1) && (head->left == NULL))
            {
                *prevBal = head->balance;
                head->balance -= 1;
            }

            else if ((*predFactor == 1) && (abs(*prevBal) > abs(head->left->balance)))
            {
                *prevBal = head->balance;
                head->balance -= 1;
            }

            else if(*predFactor == 2)
            {

                tree = rotate(tree, predecessor, head);
                *predFactor = 3;
            }

            if (head->balance == -2 || head->balance == 2)
            {
                if (head == tree)
                {
                    tree = rotate(tree, head, head);
                    *predFactor = 3; // ROTATED
                }
                else
                {
                    *predFactor = 2; // NEED TO ROTATE
                }
            }
        }
    }

    else if (key < head->key)
    {
        if (head->left != NULL)
        {
            tree = delete_node(tree, head->left, predecessor, key, predFactor, prevBal);
        }
        else
        {
            return tree;
        }

        if (*predFactor == -3)
        {
            Tnode *temp = head->left->right;
            free(head->left);
            head->left = temp;
            //head->left = head->left->right;
            *prevBal = head->balance;
            *predFactor = 1;
        }

        else if (*predFactor == 2)
        {
            tree = rotate(tree, head->left, head);
            *predFactor = 3; // PROBABLY CHANGE TO 1
        }

        if ((*predFactor == -2) && (head->left == NULL))
        {
            *prevBal = head->balance;
            head->balance -= 1;
        }

        else if ((*predFactor == -2) && (abs(*prevBal) > abs(head->left->balance))) // NEED TO BALANCE NEGATIVE
        {
            *prevBal = head->balance;
            head->balance -= 1;
        }

        else if ((*predFactor == 1) && (head->left == NULL))
        {
            *prevBal = head->balance;
            head->balance -= 1;
        }

        else if ((*predFactor == 1) && (abs(*prevBal) > abs(head->left->balance)))
        {
            *prevBal = head->balance;
            head->balance -= 1;
        }

        if (head->balance == -2 || head->balance == 2)
        {
            if (head == tree)
            {
                tree = rotate(tree, head, head);
                *predFactor = 3; // ROTATED
            }
            else
            {
                *predFactor = 2; // NEED TO ROTATE
            }
        }
    }

    else if (key > head->key)
    {
        if (head->right != NULL)
        {
            tree = delete_node(tree, head->right, predecessor, key, predFactor, prevBal);
        }
        else
        {
            return tree;
        }

        if (*predFactor == -3)
        {
            Tnode *temp = head->right->right;
            free(head->right);
            head->right = temp;
            // head->right = head->right->right;
            *prevBal = head->balance;
            *predFactor = 1;
        }

        else if (*predFactor == 2)
        {
            tree = rotate(tree, head->right, head);
            *predFactor = 1;
        }

        else if ((*predFactor == -2) && (head->left == NULL))
        {
            *prevBal = head->balance;
            head->balance -= 1;
        }

        else if ((*predFactor == -2) && (abs(*prevBal) > abs(head->left->balance))) // NEED TO BALANCE NEGATIVE
        {
            *prevBal = head->balance;
            head->balance -= 1;
        }

        if ((*predFactor == 1) && (head->right == NULL))
        {
            *prevBal = head->balance;
            head->balance += 1;
        }
    
        else if ((*predFactor == 1) && (abs(*prevBal) > abs(head->right->balance)))
        {
            *prevBal = head->balance;
            head->balance += 1;
        }

        if (head->balance == -2 || head->balance == 2)
        {
            if (head == tree)
            {
                tree = rotate(tree, head, head);
                *predFactor = 3; // ROTATED
            }
            else
            {
                *predFactor = 2; // NEED TO ROTATE
            }
        }
    }

    return tree;
}

Tnode * find_pred(Tnode *tree, Tnode *head, Tnode *predecessor, int *predFactor)
{
    if (*predFactor == 0) // LOOKING FOR PRED
    {
        if (predecessor->right == NULL)
        {
            head->key = predecessor->key;
            *predFactor = -1; // FOUND PRED
            if (predecessor == head->left)
            {
                Tnode *temp = predecessor->left;
                free(head->left);
                head->left = temp;
                // head->left = predecessor->left;
                *predFactor = -2; // NEED TO BALANCE NEGATIVE
            }

            return tree;
        }

        else
        {
            tree = find_pred(tree, head, predecessor->right, predFactor);

            if (*predFactor == 2) // NEED TO ROTATE
            {
                tree = rotate(tree, predecessor->right, predecessor);
                *predFactor = 3; // ROTATED
            }

            if (*predFactor == -1) // FOUND PRED
            {
                Tnode *temp = predecessor->right->left;
                free(predecessor->right);
                predecessor->right = temp;
                // predecessor->right = predecessor->right->left;
                predecessor->balance += 1;
                *predFactor = 1;

                if (predecessor->left == NULL)
                {
                    *predFactor = 1; // NEED TO BALANCE POSITIVE
                }
            }

            else if (*predFactor == 1 && predecessor->right->balance == 0) // NEED TO BALANCE POSITIVE
            {
                predecessor->balance += 1;
            }

            if (predecessor->balance == 2)
            {
                *predFactor = 2; // NEED TO ROTATE
            }
        }
    }

    return tree;
}

void output_tree(FILE *output, Tnode *head)
{
    if (head == NULL)
    {
        return;
    }

    int key = head->key;
    char pattern;

    if (head->left != NULL)
    {
        if (head->right != NULL)
        {
            pattern = 0x03;
        }
        else
        {
            pattern = 0x02;
        }
    }
    else
    {
        if (head->right != NULL)
        {
            pattern = 0x01;
        }
        else
        {
            pattern = 0x00;
        }
    }

    fwrite(&key, sizeof(int), 1, output);
    fwrite(&pattern, sizeof(char), 1, output);

    output_tree(output, head->left);
    output_tree(output, head->right);
    free(head);

    return;
}

void evaluate(FILE *input, int key, char branch, int *inputCheck, int *bstCheck, int *heightCheck)
{
    int err_check1 = 1;
    int err_check2 = 1;
    long int bytes = ftell(input);
    
    if (bytes % (sizeof(int) + sizeof(char)) != 0)
    {
        *inputCheck = 0;
        exit(EXIT_FAILURE);
    }

    int size = (int)(bytes / (sizeof(int) + sizeof(char)));
    int *key_arr = malloc(size * sizeof(int));
    char *branch_arr = malloc(size * sizeof(char));
    fseek(input, 0L, SEEK_SET);

    for (int i = 0; i < size; i++)
    {
        err_check2 = fread(&key, sizeof(int), 1, input);
        err_check2 = fread(&branch, sizeof(char), 1, input);

        if (err_check1 != 1 || err_check2 != 1 || branch < 0 || branch > 3)
        {
            *inputCheck = 0;
            exit(EXIT_FAILURE);
        }

        key_arr[i] = key;
        branch_arr[i] = branch;
    }

    *inputCheck = 1;
    int heightLeft = 0;
    int heightRight = 0;
    int minKey = key_arr[0];
    int maxKey = key_arr[0];
    int count = 0;

    check_bst(key_arr, branch_arr, &heightLeft, &heightRight, bstCheck, heightCheck, &minKey, &maxKey, &count, size);   
    free(key_arr);
    free(branch_arr);
}

void check_bst(int *key_arr, char *branch_arr, int *heightLeft, int *heightRight, int *bstCheck, int *heightCheck, int *minKey, int *maxKey, int *count, int size)
{
    if(*count > size)
    {
        return;
    }

    else if (branch_arr == 0)
    {
        *count += 1;
        return;
    }

    else if (branch_arr[*count] == 1)
    {
        int currKey = key_arr[*count];

        if ((key_arr[*count + 1] < currKey) || (key_arr[*count + 1] < *minKey))
        {
            *bstCheck = 0;
        }
        
        *count += 1;

        check_bst(key_arr, branch_arr, heightLeft, heightRight, bstCheck, heightCheck, minKey, maxKey, count, size);
        *heightRight += 1;
        *maxKey = max(*maxKey, currKey);

        if (abs(*heightLeft - *heightRight) >= 2)
        {
            *heightCheck = 0;
        }   
    }

    else if (branch_arr[*count] == 2)
    {
        int currKey = key_arr[*count];

        if (key_arr[*count + 1] > currKey  || (key_arr[*count + 1] > *maxKey))
        {
            *bstCheck = 0;
        }

        *count += 1;

        check_bst(key_arr, branch_arr, heightLeft, heightRight, bstCheck, heightCheck, minKey, maxKey, count, size);
        *heightLeft += 1;
        *minKey = min(*minKey, currKey);

        if (abs(*heightLeft - *heightRight) >= 2)
        {
            *heightCheck = 0;
        }   
    }

    else if (branch_arr[*count] == 3)
    {
        int currKey = key_arr[*count];

        if (key_arr[*count + 1] > currKey  || (key_arr[*count + 1] > *maxKey))
        {
            *bstCheck = 0;
        }

        *count += 1;

        check_bst(key_arr, branch_arr, heightLeft, heightRight, bstCheck, heightCheck, minKey, maxKey, count, size);
        *heightLeft += 1;
        *minKey = min(*minKey, currKey);

        currKey = key_arr[*count];
        if ((key_arr[*count + 1] < currKey) || (key_arr[*count + 1] < *minKey))
        {
            *bstCheck = 0;
        }

        check_bst(key_arr, branch_arr, heightLeft, heightRight, bstCheck, heightCheck, minKey, maxKey, count, size);
        *heightRight += 1;
        *maxKey = max(*maxKey, currKey);

        if (abs(*heightLeft - *heightRight) >= 2)
        {
            *heightCheck = 0;
        }   
    }
}
int max(int x1, int x2)
{
    if (x1 >= x2)
    {
        return x1;
    }

    else
    {
        return x2;
    }

    return x1;
}

int min(int x1, int x2)
{
    if (x1 <= x2)
    {
        return x1;
    }

    else
    {
        return x2;
    }

    return x1;
}

void printTree(Tnode * tree, int height)
{
    if (tree == NULL)
    {
        return;
    }
    printTree(tree->right, height + 1);
    for (int i = 0; i < height; i++)
    {
        fprintf(stderr, "       ");
    }
    fprintf(stderr, "(%d, %d)\n", tree->key, tree->balance);   
    printTree(tree->left, height + 1);
    return;
}
