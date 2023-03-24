// ***
// *** You MUST modify this file
// ***

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h> 
#include <string.h>
#include "hw10.h"

// DO NOT MODIFY this function --->>>
void printListNode(ListNode * head)
{
	ListNode * p = head;
	printf("printListNode: ");
	while (p != NULL) // the linked list must end with NULL
	{
		printf("%7d ", p -> value);
		p = p -> next;
	}
	printf("\n");
}
// <<<--- until here

// You MUST modify the following functions

#ifdef TEST_CREATELIST
// create a linked list storing values 0, 1, 2, ... valn - 1
// The first node (head) stores 0, the next node stores 1,
// ..., the last node stores valn - 1
// return the head of the linked listn
// the linked list must end with NULL
ListNode * createList(int valn)
{
	ListNode* head = NULL;

	for (int i = valn - 1; i >= 0; i--)
	{
		ListNode * temp = malloc(sizeof(ListNode));

		temp -> next = NULL;

		temp -> value = i;

		temp -> next = head;

		head = temp;

	}

	return head;
}

#endif

#ifdef TEST_ELIMINATE
// eliminate the nodes in the linked list
// starting from the head, move one node at a time and count to valk.
// eliminate that node, keep counting
//
// when reaching the end of the list, continue from the beginning of
// the list
//
// print the values of the nodes to be deleted

void eliminate(ListNode * head, int valk)
{
#ifdef DEBUG
	// this #ifdef ... #endif should be inside the condition *BEFORE* a
	// node' value is printed and it is deleted

	ListNode * todelete = head;
	ListNode * temp;

	while (head -> next != NULL)
	{
		for (int i = 0; i < valk - 1; i++)
		{
			if (todelete -> next == NULL)
			{
				todelete = head;
			}

			else
			{
				todelete = todelete -> next;
			}
		}

		printListNode (todelete);
		printf("%d\n", todelete -> value);
		temp = todelete;

		if (temp -> next == NULL)
		{
			temp = head;
		}

		else
		{
			temp = temp -> next;
		}

		head = deleteNode(head, todelete);
		todelete = temp;
	}
	printf("%d\n", head -> value);
	free(head);
#endif
}
#endif

#ifdef TEST_DELETENODE
// head points to the first node in the linked list
// todelete points  to the node to be deleted
//
// delete the node and return the head of the linked list
// release the memory of the deleted node
//
// should check several conditions:
// 1. If head is NULL, the list is empty and this function returns NULL
// 2. If todelete is NULL, nothing can be deleted, return head
// 3. If todelete is not in the list, keep the list unchanged and
//    return head
// It is possible that todelete is the first node in the list (i.e.,
// the head). If this occurs, return the second node of the list.
ListNode * deleteNode(ListNode * head, ListNode * todelete)
{

	ListNode * p = head;

	if (p == NULL) 
	{
		return p;
	}

	if (todelete == NULL)
	{
		return p;
	}


	if ((p -> value) == todelete -> value)
	{
		p = p -> next;
		free (head);
		return p;
	}

	ListNode * q = p -> next;

	while ((q != NULL) && ((q -> value) != todelete -> value))
	{
		p = p -> next;
		q = q -> next;
	}

	if (q != NULL) 
	{ 
		p -> next = q -> next;
		free (q);
	}

	return head;

}
#endif


