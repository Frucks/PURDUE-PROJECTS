#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include "solver.h"
#include "mazehelper.h"
#include "path.h"
#include "list.h"

PathLL * solveMaze(Maze * m) {

	PathLL * successPaths = buildPaths();
	char * retval = malloc(((m->height * m->width) + 1) * sizeof(char));

	MazePos mp = {.xpos = m->start.xpos, .ypos = m->start.ypos};
	depthFirstSolve(m, mp, retval, 0, successPaths);

	free(retval);

	return successPaths;
}

void depthFirstSolve(Maze * m, MazePos curpos, char * path, int step, PathLL * successPaths) {

	//Fill in. (Your best bet is to modify a working implementation from PA08)

	if (!squareOK(curpos, m))
	{
		return;
	}

	if (atEnd(curpos, m))
	{
		path[step] = '\0';
		addNode(successPaths, path);
		
		return;
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

        path[step] = NORTH;

	depthFirstSolve(m, NorthPos, path, step + 1, successPaths);

        path[step] = EAST;

	depthFirstSolve(m, EastPos, path, step + 1, successPaths);	

        path[step] = SOUTH;

	depthFirstSolve(m, SouthPos, path, step + 1, successPaths);
	
        path[step] = WEST;

	depthFirstSolve(m, WestPos, path, step + 1, successPaths);

	m->maze[curpos.ypos][curpos.xpos].visited = false;

	return;
}
