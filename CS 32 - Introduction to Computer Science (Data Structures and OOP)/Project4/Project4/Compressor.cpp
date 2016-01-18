#include "provided.h"
#include <string>
#include <vector>
#include "HashTable.h"
using namespace std;

void Compressor::compress(const string& s, vector<unsigned short>& numbers)
{
    // clear the vector
    while (!numbers.empty())
    {
        numbers.pop_back();
    }
    
    unsigned long capacity = s.length();
    if (((capacity/2) + 512) < 16384)
        capacity = ((capacity/2) + 512);
    else capacity = 16384;
    
    HashTable<string, unsigned short> h(2*capacity, capacity);
    for (unsigned short j = 0; j <= 255; j++)
    {
        string temp = " ";
        temp[0] = static_cast<char>(j);
        h.set(temp, j, true);
    }
    
    unsigned short nextFreeID = 256;
    string runSoFar = "";
    
    for (unsigned short k = 0; k < s.length(); k++)
    {
        string expandedRun = runSoFar + s[k];
        unsigned short x = 0;
        if (h.get(expandedRun, x))
        {
            runSoFar = expandedRun;
            continue;
        }
        h.get(runSoFar, x);
        numbers.push_back(x);
        h.touch(runSoFar);
        runSoFar = "";
        
        string t = " ";
        t[0] = static_cast<char>(s[k]);
        unsigned short cv = 0;
        h.get(t, cv);
        numbers.push_back(cv);
        
        if (h.set(expandedRun, nextFreeID)) nextFreeID++;
        else
        {
            h.discard(t, cv);
            h.set(expandedRun, cv);
        }
    }
    if (runSoFar != "")
    {
        unsigned short x = 0;
        h.get(runSoFar, x);
        numbers.push_back(x);
    }
    // append capacity so decompressor knows how big to make hash table
    numbers.push_back(capacity);
}

bool Compressor::decompress(const vector<unsigned short>& numbers, string& s)
{
    int capacity = numbers.back();
    HashTable<unsigned short, string> h(2*capacity, capacity);
    for (unsigned short j = 0; j <= 255; j++)
    {
        string temp = " ";
        temp[0] = static_cast<char>(j);
        h.set(j, temp, true);
    }
    string runSoFar = "";
    string output = "";
    unsigned short us;
    unsigned short nextFreeID = 256;
    for (unsigned short k = 0; k < numbers.size()-1; k++)
    {
        string temp;
        us = numbers[k];
        if (us <= 255)
        {
            h.get(us, temp);
            output += temp;
            if (runSoFar == "")
            {
                runSoFar += temp;
                continue;
            }
            string expandedRun = runSoFar + temp;
            if (h.set(nextFreeID, expandedRun)) nextFreeID++;
            else
            {
                unsigned short key = 0;
                string val;
                h.discard(key, val);
                h.set(key, expandedRun);
            }
            runSoFar = "";
        }
        else
        {
            if (!h.get(us, temp)) return false;
            h.touch(us);
            
            output += temp;
            runSoFar = temp;
        }
    }
    s = output;
    return true;
}
