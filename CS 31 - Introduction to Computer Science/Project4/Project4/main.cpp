#include <iostream>
#include <string>
#include <cassert>
using namespace std;

int appendToAll(string[], int, string);
int lookup(const string[], int, string);
int positionOfMax(const string[], int);
int rotateLeft(string[], int, int);
int rotateRight(string[], int, int);
int flip(string[], int);
int differ(const string[], int, const string[], int);
int subsequence(const string[], int, const string[], int);
int lookupAny(const string[], int, const string[], int);
int separate(string[], int, string);


int main() {
    string h[7] = { "glenn", "carl", "carol", "rick", "", "maggie", "daryl" };
    assert(lookup(h, 7, "maggie") == 5);
    assert(lookup(h, 7, "carol") == 2);
    assert(lookup(h, 2, "carol") == -1);
    assert(positionOfMax(h, 7) == 3);
    
    string g[4] = { "glenn", "carl", "rick", "maggie" };
    assert(differ(h, 4, g, 4) == 2);
    assert(appendToAll(g, 4, "?") == 4 && g[0] == "glenn?" && g[3] == "maggie?");
    assert(rotateLeft(g, 4, 1) == 1 && g[1] == "rick?" && g[3] == "carl?");
    
    string e[4] = { "carol", "rick", "", "maggie" };
    assert(subsequence(h, 7, e, 4) == 2);
    assert(rotateRight(e, 4, 1) == 1 && e[0] == "rick" && e[2] == "");
    
    string f[3] = { "rick", "carol", "tara" };
    assert(lookupAny(h, 7, f, 3) == 2);
    assert(flip(f, 3) == 3 && f[0] == "tara" && f[2] == "rick");
    
    assert(separate(h, 7, "daryl") == 3);
    
    cout << "All tests succeeded" << endl;
}

//Done for now
//test for bad arguments (add exceptions)
int appendToAll(string a[], int n, string value)
{
    if (n < 0)
        return -1;
    else
    {
        for (int i = 0; i < n; i++)
        {
            a[i] += value;  //iterate to each value, concatenate value
        }
        return n;
    }
}

//Done for now
//test for bad arguments (add exceptions)
int lookup(const string a[], int n, string target)
{
    if (n < 0)
        return -1;
    else
    {
        for (int i = 0; i < n; i++)
        {
            //smallest position = first position the program encounters target string
            if (a[i] == target)
                return i;
        }
        return -1;
    }
}

//Done for now
//test for bad arguments (add exceptions)
int positionOfMax(const string a[], int n)
{
    if (n < 0)
        return -1;
    else
    {
        int maxPosition = 0;    //default max is 0
        for (int i = 0; i < n; i++)
        {
            if (a[maxPosition] < a[i])  //set new max position
                maxPosition = i;
        }
        return maxPosition;
    }
}

//Done for now
//test for bad arguments (add exceptions)
int rotateLeft(string a[], int n, int pos)
{
    if ((n < 0) || (pos >= n-1))    //item to move is outside range
        return -1;
    else
    {
        string posItem = a[pos];
        for (int i = pos; i < n-1; i++)
        {
            a[i] = a[i+1];  //rotate everything left
        }
        a[n-1] = posItem;   //move item at pos to the end
        return pos;
    }
}

//Done for now
//test for bad arguments (add exceptions)
int rotateRight(string a[], int n, int pos)
{
    if ((n < 0) || (pos >= n-1))
        return -1;
    else
    {
        string posItem = a[pos];
        for (int i = pos; i > 0; i--)
        {
            a[i] = a[i-1];  //rotate everything right
        }
        a[0] = posItem;     //move item at pos to beginning
        return pos;
    }
}

//Done for now
//do some more thorough tests
//test for bad arguments (add exceptions)
int flip(string a[], int n)
{
    if (n < 0)
        return -1;
    else
    {
        for (int i = 0; i < (n/2); i++)
        {
            string holdingValue = a[i];     //temporary variable while switching a[i] and a[n-1-i]
            a[i] = a[n - i - 1];
            a[n - i - 1] = holdingValue;
        }
        return n;
    }
}

//Done for now
//do some more thorough tests
//test for bad arguments (add exceptions)
int differ(const string a1[], int n1, const string a2[], int n2)
{
    if ((n1 < 0) || (n2 < 0))
        return -1;
    else
    {
        int n;
        if (n1 < n2)
            n = n1;
        else
            n = n2;
        
        int diffPos = -1;
        
        for (int i = 0; i < n; i++)
        {
            if (a1[i] != a2[i]) //
            {
                diffPos = i;
                break;
            }
        }
        
        if (diffPos != -1)      //never encountered a difference while comparing arrays
        {
            return diffPos;
        }
        else
        {
            //returns smaller n of arrays
            if (n1 < n2)
                return n1;
            else
                return n2;
        }
    }
}

//Done for now
//do some more thorough tests
//test for bad arguments (add exceptions)
int subsequence(const string a1[], int n1, const string a2[], int n2)
{
    if ((n1 < 0) || (n2 < 0) || (n2 > n1))
        return -1;
    else
    {
        if (n2 == 0)
            return 0;
        else
        {
            int position = 0;
            int initialPosition = 0;
            for (int i = 0; i < n1; i++)
            {
                if (a1[i] == a2[position])
                {
                    if (position == 0)
                        initialPosition = i;
                    position++;
                    if (position >= n2)     //reaches end of a2[], a2[] is contained in a1[]
                        return initialPosition;
                }
                else
                    position = 0;
            }
            return -1;
        }
    }
}

//Done for now
//do some more thorough tests
//test for bad arguments (add exceptions)
int lookupAny(const string a1[], int n1, const string a2[], int n2)
{
    if ((n1 < 0) || (n2 < 0))
        return -1;
    else
    {
        for (int i = 0; i < n1; i++)
        {
            for (int j = 0; j < n2; j++)
            {
                if (a1[i] == a2[j]) //check each value in a1[] with each value in a2[]
                    return i;
            }
        }
        return -1;
    }
}


int separate(string a[], int n, string separator)
{
    if (n < 0)
        return -1;
    else
    {
        //moves the values > separator to the right
        int counter = 0;
        for (int i = 0; i < n - 1; i++)
        {
            for (int j = 0; j < (n - 1 - i); j++)
            {
                if (a[j] > separator)
                {
                    string temp = a[j];
                    a[j] = a[j+1];
                    a[j+1] = temp;
                    
                    counter++;
                }
            }
        }
        
        //moves the values equal to separator to the center
        for (int i = 0; i < n - 1; i++)
        {
            for (int j = 0; j < (n - 1 - i); j++)
            {
                if ((a[j] == separator) && (a[j+1] < separator))
                {
                    string temp = a[j];
                    a[j] = a[j+1];
                    a[j+1] = temp;
                    
                    counter ++;
                }
            }
        }
        
        if (counter != 0)
        {
            for (int i = 0; i < n; i++)
            {
                if (!(a[i] < separator))    //output position of first value not <separator
                    return i;
            }
            return n;
        }
        else
            return n;
    }
}




