#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include "solver.h"
#include "path.h"
#include "mazehelper.h"

char * solveMaze(Maze * m) {
    //An obvious upper bound on the size of the solution path is the number
    //of squares in the maze + 1 (to account for the '\0'). You could make
    //this a tighter bound by accounting for how many walls there are, but
    //this approach is good enough!
	char * retval = malloc(sizeof(char) * ((m->width * m->height) + 1));

	MazePos mp = {.xpos = m->start.xpos, .ypos = m->start.ypos};
	if (!depthFirstSolve(m, mp, retval, 0)) {
		fprintf(stderr, "No solution found!\n");
	} else {
		printf("Solution found: %s\n", retval);
	}
	
	return retval;
}

bool depthFirstSolve(Maze * m, MazePos curpos, char * path, int step) {

	// FILL IN

	if (!squareOK(curpos, m))
	{
		path[step] = '\0';
		return false;
	}

	if (atEnd(curpos, m))
	{
		path[step] = '\0';
		return true;
	}

	MazePos NorthPos = curpos;
	MazePos EastPos = curpos;
	MazePos WestPos = curpos;
	MazePos SouthPos = curpos;

	NorthPos.ypos = curpos.ypos - 1;
	EastPos.xpos = curpos.xpos + 1;
	WestPos.xpos = curpos.xpos - 1;
	SouthPos.ypos = curpos.ypos + 1;

	m->maze[curpos.ypos][curpos.xpos].visited = true;
	
	if(depthFirstSolve(m, NorthPos, path, step + 1))
	{
		path[step] = NORTH;
		return true;
	}

	if (depthFirstSolve(m, EastPos, path, step + 1))
	{
		path[step] = EAST;
		return true;
	}
	
	if (depthFirstSolve(m, WestPos, path, step + 1))
	{
		path[step] = WEST;
		return true;
	}

	if(depthFirstSolve(m, SouthPos, path, step + 1))
	{
		path[step] = SOUTH;
		return true;
	}

	path[step] = '\0';

	return false;
}
