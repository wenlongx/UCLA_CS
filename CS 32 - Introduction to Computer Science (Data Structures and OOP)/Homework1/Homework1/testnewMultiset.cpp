#include "newMultiset.h"
#include <iostream>
#include <string>
#include <cassert>
using namespace std;

int main()
{
    Multiset a(1000);   // a can hold at most 1000 distinct items
    Multiset b(5);      // b can hold at most 5 distinct items
    Multiset c;         // c can hold at most DEFAULT_MAX_ITEMS distinct items
    ItemType v[6] = { 1,3,4,5,6,7 };
    // No failures inserting 5 distinct items twice each into b
    for (int k = 0; k < 5; k++)
    {
        assert(b.insert(v[k]));
        assert(b.insert(v[k]));
    }
    assert(b.size() == 10  &&  b.uniqueSize() == 5  &&  b.count(v[0]) == 2);
    // Failure if we try to insert a sixth distinct item into b
    assert(!b.insert(v[5]));
    
    // When two Multisets' contents are swapped, their capacities are swapped
    // as well:
    a.swap(b);
    assert(!a.insert(v[5])  &&  b.insert(v[5]));
    
    //Multiset a;     //default constructor
    //Multiset b(1);  //passing arguments
    
    Multiset d(a);  //copy constructor
    
    a = b;          //assignment operator
    b = a;
    
    Multiset m;
    
    //insert()
    assert(m.insert(42));   //insert one item
    assert(m.insert(10));
    assert(m.insert(42));   //insert duplicate items
    assert(m.insert(42));

    //erase() and eraseAll()
    assert(m.erase(10));    //erase works
    assert(m.erase(42));
    assert(m.eraseAll(42)); //eraseAll works
    
    //empty()
    Multiset n;
    assert(n.empty());
    assert(m.empty());
    
    //get()
    unsigned long x = 999;
    assert(m.get(0, x) == 0  &&  x == 999); // x unchanged by get failure
    m.insert(42);
    assert(m.get(0, x) == 1  &&  x == 42);  //x changed by get
    
    //contains()
    assert(m.contains(42));
    m.eraseAll(42);
    assert(!m.contains(42));
    
    //size() and uniqueSize()
    m.insert(42);
    m.insert(10);
    assert(m.size() == 2  &&  m.uniqueSize() == 2);
    m.insert(42);
    assert(m.size() == 3  &&  m.uniqueSize() == 2);
    
    //swap()
    Multiset ms1;
    ms1.insert(42);
    ms1.insert(42);
    ms1.insert(42);
    ms1.insert(10);
    Multiset ms2;
    ms2.insert(2);
    ms2.insert(4);
    ms2.insert(6);
    ms1.swap(ms2);  // exchange contents of ms1 and ms2
    assert(ms1.size() == 3  &&  ms1.uniqueSize() == 3  &&  ms1.count(2) == 1  &&
           ms1.count(4) == 1  &&  ms1.count(6) == 1);
    assert(ms2.size() == 4  &&  ms2.uniqueSize() == 2  &&  ms2.count(42) == 3  &&
           ms2.count(10) == 1);
    
    //count()
    assert(ms2.count(42) == 3);
    assert(ms2.count(10) == 1);
    assert(ms1.count(2) == 1);
    assert(ms1.count(4) == 1);
    assert(ms1.count(6) == 1);
}