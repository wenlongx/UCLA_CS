#include "Multiset.h"
#include "StudentMultiset.h"
#include <iostream>
#include <cassert>
using namespace std;

int main()
{
    StudentMultiset m;          //constructor
    
    assert(m.size() == 0);      //checks size function
    
    assert(m.add(123456789));   //add single item
    assert(m.add(987654321));
    assert(m.add(123456789));   //add duplicate item
    
    assert(m.size() == 3);      //checks size function
    
    m.print();                  //prints out
}