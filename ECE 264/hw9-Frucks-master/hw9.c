#include <stdio.h>
#include <stdlib.h>
#include "maze.h"
#include "path.h"
#include "solver.h"

int main(int argc, char ** argv) {
	if (argc != 3) {
		fprintf(stderr, "Wrong number of command line args\n");
		fprintf(stderr, "Usage: ./hw9 [mazeFile] [pathFile]\n");
		return EXIT_FAILURE;
	}
	
	Maze * m = readMaze(argv[1]);
	
	if (m == NULL) {
		return EXIT_FAILURE;
	}

	char * path = solveMaze(m);
	
	if (writePath(argv[2], path)) {
		freeMaze(m);
		free(m);
		free(path);
		return EXIT_FAILURE;
	}
	
    /* You can use the code below to *read in*
       a path from a pathFile, and check if it's
       a solution to the maze. This is a good way
       to check the outputs that your solver is producing */
    
	// char * path = readPath(argv[2]);
	// if (path == NULL) {
	// 	freeMaze(m);
	// 	free(m);
	// 	return EXIT_FAILURE;
	// }
	
	// if (checkPath(m, path)) {
	// 	printf("Success!\n");
	// } else {
	// 	printf("Failure!\n");
	// }
	
	//Clean up memory
	freeMaze(m);
	free(m);
	free(path);
	
	return EXIT_SUCCESS;
}
