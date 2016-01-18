//
//  maze.cpp
//  Homework 3
//
//  Created by Wenlong Xiong on 2/7/15.
//  Copyright (c) 2015 Wenlong Xiong. All rights reserved.
//

bool pathExists(std::string maze[], int nRows, int nCols, int sr, int sc, int er, int ec)
{
    // if start == end, maze is solved
    if (sr == er && sc == ec)
        return true;
    
    // marked as visited
    maze[sr][sc] = 'A';
    
    //NORTH
    if ((sr > 0) && (maze[sr-1][sc] == '.'))
        if (pathExists(maze, nRows, nCols, sr-1, sc, er, ec))
            return true;
        
    //EAST
    if ((sc < nCols-1) && (maze[sr][sc+1] == '.'))
        if (pathExists(maze, nRows, nCols, sr, sc+1, er, ec))
            return true;
        
    //SOUTH
    if ((sr < nRows-1) && (maze[sr+1][sc] == '.'))
        if (pathExists(maze, nRows, nCols, sr+1, sc, er, ec))
            return true;
        
    //WEST
    if ((sr < nCols-1) && (maze[sr][sc-1] == '.'))
        if (pathExists(maze, nRows, nCols, sr, sc-1, er, ec))
            return true;
    
    return false;
}