#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "list.h"

/** INTERFACE FUNCTIONS **/

PathLL * buildPaths() {
	PathLL * retval = malloc(sizeof(PathLL));
	retval->head = NULL;
	return retval;
}

void freePaths(PathLL * p) {
	//fill in

	PathNode * curr = p -> head;
	PathNode * next;

	while (curr != NULL)
	{
		next = curr -> next;
		freeNode(curr);
		curr = next;
	}

	free(p);
}

PathNode * buildNode(char * path) {
	//fill in

	//WARNING: don't forget to use strcpy to copy path into the
	//new node. Don't just set them equal, otherwise if the input path changes
	//the node will have the wrong path.

	PathNode * newNode = (PathNode *) malloc (sizeof (PathNode));

	newNode -> next = NULL;
	newNode -> path = malloc ((strlen(path) + 1) * sizeof (char));

	strcpy(newNode -> path, path);

	return newNode;
}

void freeNode(PathNode * p) {
	//fill in

	free(p -> path);
	free(p);
}

bool addNode(PathLL * paths, char * path) {

	//fill in

	if (containsNode(paths, path))
	{
		return false;
	}

	PathNode * pathNode = buildNode(path);

	PathNode * p = paths -> head;

	if (p == NULL)
	{
		paths -> head = pathNode;

		return true;
	}

	PathNode * q = p -> next;

	while (q != NULL)
	{

		if (strlen(pathNode -> path) < strlen(q -> path))
		{
			p -> next = pathNode;
			pathNode -> next = q;

			return true;
		}

		else if (strlen(pathNode -> path) == strlen(q -> path))
		{
			char * pathArray = pathNode -> path;
			char * compArray = q -> path;

			int turnsPath = 0;
			int turnsComp = 0;
			int i = 0;

			while (path[i] != '\0')
			{
				if (pathArray[i] != pathArray[i + 1])
				{
					turnsPath++;
				}

				if (compArray[i] != compArray[i + 1])
				{
					turnsComp++;
				}

				i++;
			}

			if (turnsPath < turnsComp)
			{
				p -> next = pathNode;
				pathNode -> next = q;

				return true;
			}

			if (turnsPath == turnsComp)
			{
				if (strcmp(pathNode -> path, q -> path) < 0)
				{

					p -> next = pathNode;
                                        pathNode -> next = q;

					return true;
				}
			}
		}

		p = p -> next;
		q = q -> next;

	}

	if (q == NULL)
	{
		p -> next = pathNode;
		pathNode -> next = q;

		free(q);
	}

	return false;
}

bool removeNode(PathLL * paths, char * path) {

	//fill in

	PathNode * p = paths -> head;

	if (p == NULL) 
	{
		return false;
	}

	if (!strcmp(p -> path, path))
	{
		p = p -> next;
		free(paths -> head);
		paths -> head = p;

		return true;
	}

	PathNode * q = p -> next;

	while (q != NULL && strcmp(q -> path, path))
	{
		q = q -> next;
		p = p -> next;
	}

	if (q != NULL)
	{
		p -> next = q -> next;
		free(q);

		return true;
	}


	return false;
}

bool containsNode(PathLL * paths, char * path) {

	PathNode * p = paths -> head;

	while (p != NULL)
	{
		if (!strcmp(p -> path, path))
		{
			return true;
		}

		p = p -> next;
	}

	return false;
}

void printPaths(PathLL * paths, FILE * fptr) {
	PathNode * curr = paths->head;
	int i = 0;
	while (curr != NULL) {
		fprintf(fptr, "Path %2d: %s\n", i, curr->path);
		i++;
		curr = curr->next;
	}
}
