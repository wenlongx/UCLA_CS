//
//  Multiset.h
//  Project2
//
//  Created by Wenlong Xiong on 1/22/15.
//  Copyright (c) 2015 Wenlong Xiong. All rights reserved.
//

#ifndef __Project2__Multiset__
#define __Project2__Multiset__
#include <string>

typedef std::string ItemType;

class Multiset
{
public:
    //constructor
    Multiset(int m = 1) {n = m;};
    
    //destructor
    ~Multiset();
    
    //copy constructor
    Multiset(const Multiset &src);
    
    //assignment operator
    Multiset &operator= (const Multiset &src);
    
    //returns true if multiset is empty
    bool empty() const;
    
    //returns the # of unique items in a multiset
    int size() const;
    
    //returns the total # of items in a multiset
    int uniqueSize() const;
    
    int something() const {return 1;};
    
    //insert an instance of a value into multiset
    bool insert(const ItemType& value);
    
    //erase an instance of a value from multiset
    int erase(const ItemType& value);
    
    //erase all instances of a value from a multiset
    int eraseAll(const ItemType& value);
    
    //returns true if value is contained in muliset
    bool contains(const ItemType& value) const;
    
    //returns quantity of value in multiset
    int count(const ItemType& value) const;
    
    //returns quantity of a given ItemType in multiset, and sets value to the ItemType at int i
    //iterating from 0 to uniquesize will return all the values in the multiset
    int get(int i, ItemType& value) const;
    
    //switches one multiset with another
    void swap(Multiset& other);
    
private:
    struct Node
    {
    public:
        Node()
        {
            prev = nullptr;
            next = nullptr;
            quantity = 0;
        };
        ItemType value;
        int quantity;
        Node* prev;
        Node* next;
    };
    
    Node* head;
    Node* tail;
    
    int n;
};

void combine(const Multiset& ms1, const Multiset& ms2, Multiset& result);

void subtract(const Multiset& ms1, const Multiset& ms2, Multiset& result);

#endif /* defined(__Project2__Multiset__) */
