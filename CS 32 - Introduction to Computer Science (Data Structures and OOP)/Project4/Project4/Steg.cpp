#include "provided.h"
#include <string>

using namespace std;

bool Steg::hide(const string& hostIn, const string& msg, string& hostOut) 
{
    if (hostIn == "")
        return false;
    
    int run = 0;
    vector<string> v;
    for (int k = 0; k < hostIn.length(); k++)
    {
        run++;
        if (hostIn[k] == '\n')
        {
            // run is the length of the string, with tabs and spaces
            run--;
            int temp = 0;
            while (temp<=run)
            {
                if (!(hostIn[k-temp-1] == '\t' || hostIn[k-temp-1] == '\r' || hostIn[k-temp-1] == ' '))break;
                temp++;
            }
            v.push_back(hostIn.substr(k-run, run-temp));
            run = 0;
        }
    }
    if (run != 0)
    {
        run--;
        int temp = 0;
        while (temp<=run)
        {
            if (!(hostIn[hostIn.length()-temp-2] == '\t' || hostIn[hostIn.length()-temp-2] == '\r' || hostIn[hostIn.length()-temp-2] == ' ')) break;
            temp++;
        }
        v.push_back(hostIn.substr(hostIn.length()-run-1, run-temp));
        run = 0;
    }
    
    vector<unsigned short> numbers;
    
    // compressor converts string to vector
    Compressor::compress(msg, numbers);
    
    // use binary convert to convert vector to tabs and spaces
    string encoded_msg = BinaryConverter::encode(numbers);
    
    // v now contains strings
    int N = v.size();
    int L = encoded_msg.length();
    
    hostOut = "";
    int num_substrings = 0;
    int pos = 0;
    while (!v.empty())
    {
        num_substrings++;
        if (num_substrings <= L%N)
        {
            hostOut += v.front() + encoded_msg.substr(pos, (L/N)+1) + "\n";
            v.erase(v.begin());
            pos += (L/N)+1;
        }
        else
        {
            hostOut += v.front() + encoded_msg.substr(pos, (L/N)) + "\n";
            v.erase(v.begin());
            pos += (L/N);
        }
    }
    return true;
}

bool Steg::reveal(const string& hostIn, string& msg) 
{
    int run = 0;
    vector<string> v;
    
    for (int k = 0; k < hostIn.length(); k++)
    {
        run++;
        if (hostIn[k] == '\n')
        {
            // run is the length of the string, with tabs and spaces
            run--;
            int temp = 0;
            while (temp < run)
            {
                if (!(hostIn[k-temp-1] == '\t' || hostIn[k-temp-1] == ' ')) break;
                temp++;
            }
            string temp_string = hostIn.substr(k-temp, temp);
            v.push_back(temp_string);
            run = 0;
        }
    }
    if (run != 0)
    {
        run--;
        int temp = 0;
        while (temp<=run)
        {
            if (!(hostIn[hostIn.length()-temp-2] == '\t' || hostIn[hostIn.length()-temp-2] == ' ')) break;
            temp++;
        }
        v.push_back(hostIn.substr(hostIn.length()-temp-1, temp));
        run = 0;
    }
    
    vector<unsigned short> numbers;
    string decoded_msg = "";
    while (!v.empty())
    {
        decoded_msg += v.front();
        v.erase(v.begin());
    }
    
    // use binary convert to convert tabs and spaces to binary strings
    if (BinaryConverter::decode(decoded_msg, numbers))
    {
        // compressor converts vector to string
        Compressor::decompress(numbers, decoded_msg);
        msg = decoded_msg;
        return true;
    }
	return false;  // This compiles, but may not be correct
}