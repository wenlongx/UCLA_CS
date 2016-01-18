#include "newMultiset.h"
#include <iostream>

Multiset::Multiset(int size)
{
    if (size)
    array = new Element[size];
    array_size = size;
}

//destructor
Multiset::~Multiset()
{
    delete [] array;
}

//copy constructor
Multiset::Multiset(const Multiset &src)
{
    array_size = src.array_size;
    array = new Element[array_size];
    for (int i = 0; i < array_size; i++)
    {
        array[i] = src.array[i];
    }
}

Multiset &Multiset::operator= (const Multiset &src)
{
    if (this == &src)
    {
        return (*this);
    }
    else
    {
        delete [] array;
        array_size = src.array_size;
        array = new Element[array_size];
        for (int i = 0; i < array_size; i++)
        {
            array[i] = src.array[i];
        }
        return (*this);
    }
}

// Return true if the multiset is empty, otherwise false.
bool Multiset::empty() const
{
    if (this->size() == 0)
        return true;
    else
        return false;
}

// Return the number of items in the multiset.  For example, the size
// of a multiset containing "cumin", "cumin", "cumin", "turmeric" is 4.
int Multiset::size() const
{
    int count = 0;
    for (int i = 0; i < array_size; i++)
    {
        count += array[i].quantity;
    }
    return count;
}

// Return the number of distinct items in the multiset.  For example,
// the uniqueSize of a multiset containing "cumin", "cumin", "cumin",
// "turmeric" is 2.
int Multiset::uniqueSize() const
{
    int count = 0;
    for (int i = 0; i < array_size; i++)
    {
        if (array[i].quantity != 0)
            count++;
    }
    return count;
}

// Insert value into the multiset.  Return true if the value was
// actually inserted.  Return false if the value was not inserted
// (perhaps because the multiset has a fixed capacity and is full).
bool Multiset::insert(const ItemType& value)
{
    int i = 0;
    while (i < array_size)
    {
        if ((array[i].quantity != 0) && (array[i].value == value))
        {
            array[i].quantity++;
            return true;
        }
        i++;
    }
    i = 0;
    while (i < array_size)
    {
        if (array[i].quantity == 0)
        {
            array[i].value = value;
            array[i].quantity = 1;
            return true;
        }
        i++;
    }
    return false;
}

// Remove one instance of value from the multiset if present.
// Return the number of instances removed, which will be 1 or 0.
int Multiset::erase(const ItemType& value)
{
    int i = 0;
    while (i < array_size)
    {
        //values match, quantity is not 0
        if ((array[i].quantity != 0) && (array[i].value == value))
        {
            array[i].quantity = array[i].quantity-1;
            return 1;
        }
        i++;
    }
    return 0;
}

// Remove all instances of value from the multiset if present.
// Return the number of instances removed.
int Multiset::eraseAll(const ItemType& value)
{
    int i = 0;
    while (i < array_size)
    {
        //values match, quantity is not 0
        if ((array[i].quantity != 0) && (array[i].value == value))
        {
            int temp = array[i].quantity;
            array[i].quantity = 0;
            return temp;
        }
        i++;
    }
    return 0;
}

// Return true if the value is in the multiset, otherwise false.
bool Multiset::contains(const ItemType& value) const
{
    int i = 0;
    while (i < array_size)
    {
        //values match, quantity is not 0
        if ((array[i].quantity != 0) && (array[i].value == value))
        {
            return true;
        }
        i++;
    }
    return false;
}

// Return the number of instances of value in the multiset.
int Multiset::count(const ItemType& value) const
{
    int i = 0;
    while (i < array_size)
    {
        //values match, quantity is not 0
        if ((array[i].quantity != 0) && (array[i].value == value))
        {
            return array[i].quantity;
        }
        i++;
    }
    return 0;
}

// If 0 <= i < uniqueSize(), copy into value an item in the
// multiset and return the number of instances of that item in
// the multiset.  Otherwise, leave value unchanged and return 0.
// (See below for details about this function.)
int Multiset::get(int i, ItemType& value) const
{
    int skip = i, k = 0;
    while ((k < array_size) && (skip > 0))
    {
        if (array[k].quantity != 0)
        {
            skip--;
        }
        k++;
    }
    if (array[k].quantity != 0)
    {
        value = array[k].value;
        return array[k].quantity;
    }
    return 0;
}

// Exchange the contents of this multiset with the other one.
void Multiset::swap(Multiset& other)
{
    Element* temp_array = other.array;
    other.array = array;
    array = temp_array;
    
    int temp_size = other.array_size;
    other.array_size = array_size;
    array_size = temp_size;
}


