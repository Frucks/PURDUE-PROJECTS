#ifndef HUFFMAN_H
#define HUFFMAN_H	 

#define ASCII_SIZE 256

/* An example of a TreeNode and ListNode structure. You don't have to use exactly this */
typedef struct TreeNode {
   int label;
   long count;
   struct TreeNode *left;
   struct TreeNode *right;
} TreeNode;

typedef struct ListNode {
   TreeNode *ptr;
   struct ListNode *next;
} ListNode;


#endif