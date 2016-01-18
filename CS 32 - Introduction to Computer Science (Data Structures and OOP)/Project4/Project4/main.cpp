// We have not yet produced the test driver main routine for you.

#include "HashTable.h"
#include "provided.h"
#include "http.h"
#include <iostream>
#include <cassert>
using namespace std;

unsigned int computeHash(std::string key)
{
    unsigned int hash = 0;
    for (int k = 0; k < key.size(); k++)
    {
        hash += (k+1)*key[k];
    }
    return hash;
}

unsigned int computeHash(unsigned short key)
{
    unsigned int hash = key;
    hash += 356973420734;
    hash *= 172591;
    hash += hash % 7;
    hash += hash % 13;
    hash *= 19;
    return hash;
}

int main()
{
    

    
//     HashTable<string, int> nameToAge(100, 200);
//     nameToAge.set("Carey", 43);
//     nameToAge.set("David", 97);
//     nameToAge.set("Timothy", 43, true);
//     nameToAge.set("Ivan", 28);
//     nameToAge.set("Sally", 22);
//     nameToAge.set("David", 55);
//     nameToAge.touch("Carey");
//     // let's discard the two least recently written items
//     for (int k = 0; k < 2; k++)
//     {
//     string discardedName;
//     int discardedAge;
//     if (nameToAge.discard(discardedName,discardedAge))
//     cout << "Discarded " << discardedName
//     << " who was " << discardedAge
//     << " years old.\n";
//     else
//     cout << "There are no items to discard!\n";
//     }
    
    
//     vector<unsigned short> v;
//     v.push_back(1);
//     v.push_back(5);
//     // We use the :: operator below because encode() is a static
//     // member function. You don't create a BinaryConverter object
//     // to use encode(); instead, you call it using the class name.
//     string hiddenMessage = BinaryConverter::encode(v);
//     cout << hiddenMessage; // prints tabs and spaces
//     
//     v.clear();
//     // Using the -/_ representation in this comment, the string
//     // below contains _______________-_____________-_-
//     string msg = "               \t             \t \t";
//     if (BinaryConverter::decode(msg, v))
//     {
//     cout << "The vector has " << v.size() << " numbers:";
//     for (int k = 0; k != v.size(); k++)
//     cout << ' ' << v[k];
//     cout << endl;
//     }
//     else
//     cout << "The string has a bad character or a bad length.";
//    
    
//     string str="something";
//     vector<unsigned short> numbers;
//     //Compressor::compress
//     //Compressor::decompress
//     
//     Compressor::compress(str,numbers);
//     
//     cout << "Compression is done. Values = ";
//     for(unsigned int i=0;i<numbers.size();i++)
//     cout << " " << numbers[i];
//     cout << endl;
//     
//     string output="";
//     Compressor::decompress(numbers,output);
//     cout << "Decompression is done. Output is " << output << endl;
//    

//     string str = "something";
//     vector<unsigned short> numbers;
//     Compressor::compress(str,numbers);
//    for (int i:numbers)
//        cerr << i << " ";
//    cerr << endl;
//     string hiddenMessage = BinaryConverter::encode(numbers);
//    
//    
//    
//     vector<unsigned short> num;
//     if(BinaryConverter::decode(hiddenMessage, num))
//     {
//         for (int i:num)
//             cerr << i << " ";
//     string original_msg;
//     Compressor::decompress(num,original_msg);
//     }
    
    
//     string page = "<html>   \nQ \tQQ \t \nBBB\t\t\t   \n\nGG \nBBB \n\t\nDDD\nEEE </html>   ";
//     string msg = "Hello World!";
//     string output;
//     Steg::hide(page,msg,output);
//     string msg2;
//     if (Steg::reveal(output, msg2))
//     {
//     if (msg == msg2)
//     cout << "Steg::hide() and Steg::reveal() are successfully done!" << endl;
//     }
    
    
//     string msg = "This class is finally over!";
//     string host;
//     HTTP().set("http://a.com", "<html>   \nQ \tQQ \t \nBBB\t\t\t   \n\nGG \nBBB \n\t\nDDD\nEEE </html>   ");
//     if(WebSteg::hideMessageInPage("http://a.com", msg, host) )
//     {
//     HTTP().set("http://a.com",host); // replace the original webpage by the new content
//     string msg2;
//     if(WebSteg::revealMessageInPage("http://a.com", msg2)) {
//     if(msg == msg2)
//     cout << "Successfully hide and reveal message in pages!!\n" << msg << endl;
//     else {
//     cout << "Hidden message and revealed message do not match!!" << endl;
//     cout << "Hidden message:   " << msg << endl;
//     cout << "Revealed message: " << msg2 << endl;
//     }
//     }
//     else 
//     cout << "Failed to reveal message in page!!" << endl;
//     
//     }
//     else 
//     cout << "Failed to hide message in page!!" << endl;
//    
}
