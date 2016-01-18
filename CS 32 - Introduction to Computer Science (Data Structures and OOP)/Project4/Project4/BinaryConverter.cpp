#include "provided.h"
#include <string>
#include <vector>
using namespace std;

const size_t BITS_PER_UNSIGNED_SHORT = 16;

string convertNumberToBitString(unsigned short number);
bool convertBitStringToNumber(string bitString, unsigned short& number);

string BinaryConverter::encode(const vector<unsigned short>& numbers)
{
    string temp = "";
    for (int k = 0; k < numbers.size(); k++)
    {
        temp += convertNumberToBitString(numbers[k]);
    }
    
    for (int k = 0; k < temp.length(); k++)
    {
        if (temp[k] == '1')
            temp[k] = '\t';
        else if (temp[k] == '0')
            temp[k] = ' ';
    }
    
    return temp;
}

bool BinaryConverter::decode(const string& bitString, vector<unsigned short>& numbers)
{
    if (bitString.length() % 16 != 0)
        return false;
    
    // empty the vector
    while (!numbers.empty())
    {
        numbers.pop_back();
    }
    string temp = "";
    for (int k = 0; k < bitString.length(); k++)
    {
        if (bitString[k] == ' ')
            temp += "0";
        else if (bitString[k] == '\t')
            temp += "1";
        
        if (k%16 == 15)
        {
            unsigned short temp_num = 0;
            convertBitStringToNumber(temp, temp_num);
            numbers.push_back(temp_num);
            temp = "";
        }
    }
    return true;
}

string convertNumberToBitString(unsigned short number)
{
	string result(BITS_PER_UNSIGNED_SHORT, '0');
	for (size_t k = BITS_PER_UNSIGNED_SHORT; number != 0; number /= 2)
	{
		k--;
		if (number % 2 == 1)
			result[k] = '1';
	}
	return result;
}

bool convertBitStringToNumber(string bitString, unsigned short& number)
{
	if (bitString.size() != BITS_PER_UNSIGNED_SHORT)
		return false;
	number = 0;
	for (size_t k = 0; k < bitString.size(); k++)
	{
		number *= 2;
		if (bitString[k] == '1')
			number++;
		else if (bitString[k] != '0')
			return false;
	}
	return true;
}
