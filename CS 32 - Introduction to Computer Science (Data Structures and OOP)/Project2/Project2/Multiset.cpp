//
//  Multiset.cpp
//  Project2
//
//  Created by Wenlong Xiong on 1/22/15.
//  Copyright (c) 2015 Wenlong Xiong. All rights reserved.
//

#include "Multiset.h"

//constructor
Multiset::Multiset()
{
    head = nullptr;
    tail = nullptr;
}

//destructor
Multiset::~Multiset()
{
    Node* temp = head;          //temp pointer points to current node to delete
    while (temp != nullptr)     //increment through the linked list until the end
    {
        head = temp->next;      //next node to delete
        delete temp;            //delete current node
        temp = head;            //next node becomes current node
    }
}

//copy constructor
Multiset::Multiset(const Multiset &src)
{
    //here you need to copy every single element in the linked list
    Node* src_cur = src.head;
    
    Node* my_cur = nullptr;     //points to current node in the new linked list being constructed
    Node* my_prev = nullptr;    //points to the prev node
    
    head = nullptr;
    tail = nullptr;
    
    if (src_cur != nullptr)     //creates the first node
    {
        my_cur = new Node();
        my_cur->value = src_cur->value;         //copy over the value
        my_cur->quantity = src_cur->quantity;   //copy over the quantity
        my_cur->prev = nullptr;                 //set current node's prev
        src_cur = src_cur->next;
        
        head = my_cur;                          //sets head pointer
    }
    
    while (src_cur != nullptr)
    {
        my_prev = my_cur;
        my_cur = new Node();
        my_cur->value = src_cur->value;         //copy over the value
        my_cur->quantity = src_cur->quantity;   //copy over the quantity
        my_prev->next = my_cur;                 //set previous node's next
        my_cur->prev = my_prev;                 //set current node's prev
        
        src_cur = src_cur->next;
    }
    
    if (my_cur != nullptr)
        my_cur->next = nullptr;
    
    tail = my_cur;
}

//assignment operator
Multiset &Multiset::operator= (const Multiset &src)
{
    //check for aliasing
    if (this == &src)
    {
        return (*this);
    }
    
    //first you delete every element in the first linked list
    Node* temp;
    
    while (head != nullptr)
    {
        temp = head;
        head = head->next;
        delete temp;
    }
    
    //here you need to copy every single element in the linked list
    Node* src_cur = src.head;
    
    Node* my_cur = nullptr;
    Node* my_prev = nullptr;
    
    head = nullptr;
    tail = nullptr;
    
    if (src_cur != nullptr)     //creates the first node
    {
        my_cur = new Node();
        my_cur->value = src_cur->value;         //copy over the value
        my_cur->quantity = src_cur->quantity;   //copy over the quantity
        my_cur->prev = nullptr;                 //set current node's prev
        src_cur = src_cur->next;
        
        head = my_cur;                          //sets head pointer
    }
    
    while (src_cur != nullptr)
    {
        my_prev = my_cur;
        my_cur = new Node();
        my_cur->value = src_cur->value;         //copy over the value
        my_cur->quantity = src_cur->quantity;   //copy over the quantity
        my_prev->next = my_cur;                 //set previous node's next
        my_cur->prev = my_prev;                 //set current node's prev
        
        src_cur = src_cur->next;
    }
    if (my_cur != nullptr)
        my_cur->next = nullptr;
    
    tail = my_cur;
    
    return (*this);
}

//returns true if multiset is empty
bool Multiset::empty() const
{
    if ((head == nullptr) && (tail == nullptr))
        return true;
    else return false;
}

//returns the total # of items in a multiset
int Multiset::size() const
{
    Node* temp = head;
    int count = 0;
    while (temp != nullptr)
    {
        count += temp->quantity;
        temp = temp->next;
    }
    return count;
}

//returns the # of unique items in a multiset
int Multiset::uniqueSize() const
{
    Node* temp = head;
    int count = 0;
    while (temp != nullptr)
    {
        count++;
        temp = temp->next;
    }
    return count;
}

//insert an instance of a value into multiset
bool Multiset::insert(const ItemType& value)
{
    Node* temp = head;
    
    //value already exists, increment the quantity once
    while (temp != nullptr)
    {
        if (temp->value == value)
        {
            temp->quantity += 1;
            return true;
        }
        else temp = temp->next;
    }
    
    //value does not already exist, want to creat a new node at the start
    Node* n = new Node();   //new node at end
    n->value = value;       //fill in values for Node
    n->quantity = 1;
    
    n->next = head;         //set next
    n->prev = nullptr;      //set prev
    
    //more than one value in linked list
    if (n->next != nullptr)
    {
        head->prev = n;
    }
    
    //only one value in the linked list
    if (n->next == nullptr)
    {
        tail = n;
    }
    
    head = n;               //set head
    
    return true;
}

//erase an instance of a value from multiset
int Multiset::erase(const ItemType& value)
{
    Node* temp = head;
    while (temp != nullptr)
    {
        if (temp->value == value)
        {
            //value does exist (more than 1), remove 1, return 1
            if (temp->quantity > 1)
            {
                temp->quantity -= 1;
            }
            //value does exist (only 1) delete node and return 1
            else
            {
                //deleting from the middle
                if ((temp->next != nullptr) && (temp->prev != nullptr))
                {
                    Node* prev_node = temp->prev;   //previous node
                    prev_node->next = temp->next;   //previous node's next pointer
                    temp->next->prev = prev_node;   //next node's prev pointer
                    delete temp;
                }
                
                //delete at the front
                else if ((temp->next != nullptr) && (temp->prev == nullptr))
                {
                    temp->next->prev = nullptr;   //next node's prev pointer
                    head = temp->next;            //set new head
                    delete temp;
                }
                
                //delete at the end
                else if ((temp->next == nullptr) && (temp->prev != nullptr))
                {
                    temp->prev->next = nullptr;
                    tail = temp->prev;
                    delete temp;
                }
                
                //delete if only one item in the array
                else
                {
                    head = nullptr;
                    tail = nullptr;
                    delete temp;
                }
            }
            return 1;
        }
        else temp = temp->next;
    }
    //value doesnt exist, return 0
    return 0;
}

//erase all instances of a value from a multiset
int Multiset::eraseAll(const ItemType& value)
{
    Node* temp = head;
    while (temp != nullptr)
    {
        //value exists in array, return #of those values deleted
        if (temp->value == value)
        {
            int temp_q = temp->quantity;    //quantity of given value
            
            //deleting from the middle
            if ((temp->next != nullptr) && (temp->prev != nullptr))
            {
                Node* prev_node = temp->prev;   //previous node
                prev_node->next = temp->next;   //previous node's next pointer
                temp->next->prev = prev_node;   //next node's prev pointer
                delete temp;
            }
            
            //delete at the front
            else if ((temp->next != nullptr) && (temp->prev == nullptr))
            {
                temp->next->prev = nullptr;   //next node's prev pointer
                head = temp->next;            //set new head
                delete temp;
            }
            
            //delete at the end
            else if ((temp->next == nullptr) && (temp->prev != nullptr))
            {
                temp->prev->next = nullptr;
                tail = temp->prev;
                delete temp;
            }
            
            //delete if only one item in the array
            else
            {
                head = nullptr;
                tail = nullptr;
                delete temp;
            }
            
            return temp_q;
        }
        else temp = temp->next;
    }
    //value doesnt exist, return 0
    return 0;
}

//returns true if value is contained in muliset
bool Multiset::contains(const ItemType& value) const
{
    Node* temp = head;
    while (temp != nullptr)
    {
        //value exists in array, return true
        if (temp->value == value)
        {
            return true;
        }
        else temp = temp->next;
    }
    //value doesnt exist, return false
    return false;
}

//returns quantity of value in multiset
int Multiset::count(const ItemType& value) const
{
    Node* temp = head;
    while (temp != nullptr)
    {
        //value exists in array, return quantity contained
        if (temp->value == value)
        {
            return temp->quantity;
        }
        else temp = temp->next;
    }
    //value doesnt exist, return 0
    return 0;
}

//returns quantity of a given ItemType in multiset, and sets value to the ItemType at int i
//iterating from 0 to uniquesize will return all the values in the multiset
int Multiset::get(int i, ItemType& value) const
{
    if (i < 0)
        return 0;
    
    Node* temp = head;
    for (int skip = i; skip > 0; skip--)
    {
        temp = temp->next;
    }
    value = temp->value;
    return temp->quantity;
}

//switches one multiset with another
void Multiset::swap(Multiset& other)
{
    Node* temp_head = other.head;
    Node* temp_tail = other.tail;
    
    other.head = head;
    other.tail = tail;
    
    head = temp_head;
    tail = temp_tail;
}

void combine(const Multiset& ms1, const Multiset& ms2, Multiset& result)
{
    //temporary multiset to hold result values
    Multiset temp = *new Multiset();
    
    for (int i = 0; i < ms1.uniqueSize(); i++)
    {
        ItemType temp_val;
        int temp_quant = ms1.get(i, temp_val);
        for (int k = temp_quant; k > 0; k--)
        {
            temp.insert(temp_val);
        }
    }
    
    for (int i = 0; i < ms2.uniqueSize(); i++)
    {
        ItemType temp_val;
        int temp_quant = ms2.get(i, temp_val);
        for (int k = temp_quant; k > 0; k--)
        {
            temp.insert(temp_val);
        }
    }
    
    //replace result with temp
    temp.swap(result);
}

void subtract(const Multiset& ms1, const Multiset& ms2, Multiset& result)
{
    //temporary multiset to hold result values
    Multiset temp = *new Multiset();
    
    //may have an off by one error somewhere here, not sure
    for (int i = 0; i < ms1.uniqueSize(); i++)
    {
        ItemType temp_val;
        int ms1_quant = ms1.get(i, temp_val);
        if ((ms1_quant - (ms2.count(temp_val))) > 0)
        {
            for (int k = (ms1_quant - (ms2.count(temp_val))); k > 0; k--)
            {
                temp.insert(temp_val);
            }
        }
    }
    
    //replace result with temp
    temp.swap(result);
}
