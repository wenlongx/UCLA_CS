#include "History.h"
#include "globals.h"
#include <cctype>
#include <iostream>

using namespace std;

History::History(int nRows, int nCols)
{
    m_rows = nRows;
    m_cols = nCols;
    
    //initialize the history
    for (int j = 1; j <= m_rows; j++)
    {
        for (int k = 1; k <= m_cols; k++)
        {
            m_history[j][k] = '.';
        }
    }
}

bool History::record(int r, int c)
{
    if ((r > m_rows) || (r <= 0) || (c > m_cols) || (c <= 0))
        return false;
    else
    {
        if (!isalpha(m_history[r][c]))
            m_history[r][c] = 'A';
        else if (m_history[r][c] != 'Z')
            m_history[r][c]++;
        
        return true;
    }
}

void History::display() const
{
    clearScreen();
    for (int j = 1; j <= m_rows; j++)
    {
        for (int k = 1; k <= m_cols; k++)
        {
            cout << m_history[j][k];
        }
        cout << endl;
    }
    cout << endl;
}