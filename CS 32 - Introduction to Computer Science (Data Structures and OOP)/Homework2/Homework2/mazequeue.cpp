//
//  mazequeue.cpp
//  Homework2
//
//  Created by Wenlong Xiong on 1/29/15.
//  Copyright (c) 2015 Wenlong Xiong. All rights reserved.
//

#include <string>
#include <queue>
using namespace std;

bool pathExists(string maze[], int nRows, int nCols, int sr, int sc, int er, int ec);
// Return true if there is a path from (sr,sc) to (er,ec)
// through the maze; return false otherwise

class Coord
{
public:
    Coord(int rr, int cc) : m_r(rr), m_c(cc) {}
    int r() const { return m_r; }
    int c() const { return m_c; }
private:
    int m_r;
    int m_c;
};

bool pathExists(string maze[], int nRows, int nCols, int sr, int sc, int er, int ec)
{
    //initialize stack
    queue<Coord> coordQueue;
    
    //push source onto stack
    Coord init(sr, sc);
    coordQueue.push(init);
    
    //mark as visited
    maze[init.r()][init.c()] = 'a';
    
    //while stack is not empty
    while (!coordQueue.empty())
    {
        //remove the top
        Coord temp = coordQueue.front();
        coordQueue.pop();
        
        //mark as visited
        maze[temp.r()][temp.c()] = 'a';
        
        if (temp.r() == er && temp.c() == ec)
            return true;
        
        //NORTH
        if ((temp.r() > 0) && (maze[temp.r()-1][temp.c()] == '.'))
            coordQueue.push(Coord(temp.r()-1, temp.c()));
        
        //EAST
        if ((temp.r() < nCols-1) && (maze[temp.r()][temp.c()+1] == '.'))
            coordQueue.push(Coord(temp.r(), temp.c()+1));
        
        //SOUTH
        if ((temp.r() < nRows-1) && (maze[temp.r()+1][temp.c()] == '.'))
            coordQueue.push(Coord(temp.r()+1, temp.c()));
        
        //WEST
        if ((temp.r() < nCols-1) && (maze[temp.r()][temp.c()-1] == '.'))
            coordQueue.push(Coord(temp.r(), temp.c()-1));
    }
    
    return false;
}
