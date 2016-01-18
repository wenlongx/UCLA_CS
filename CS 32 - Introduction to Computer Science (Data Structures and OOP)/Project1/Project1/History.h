#ifndef __Project1__History__
#define __Project1__History__

#include "globals.h"

class History
{
public:
    History(int nRows, int nCols);
    bool record(int r, int c);
    void display() const;
private:
    int m_rows;
    int m_cols;
    char m_history[MAXROWS][MAXCOLS];
};

#endif /* defined(__Project1__History__) */