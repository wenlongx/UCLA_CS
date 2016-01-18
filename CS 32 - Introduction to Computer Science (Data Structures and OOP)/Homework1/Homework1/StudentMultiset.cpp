#include "StudentMultiset.h"
#include "Multiset.h"
#include <iostream>

// Create an empty student multiset.
StudentMultiset::StudentMultiset()
{
    my_m = *new Multiset();
}

// Add a student id to the StudentMultiset.  Return true if and only
// if the id was actually added.
bool StudentMultiset::add(unsigned long id)
{
    return my_m.insert(id);
}

// Return the number of items in the StudentMultiset.  If an id was
// added n times, it contributes n to the size.
int StudentMultiset::size() const
{
    return my_m.size();
}

// Print to cout every student id in the StudentMultiset one per line;
// print as many lines for each id as it occurs in the StudentMultiset.
void StudentMultiset::print() const
{
    for (int i = 0; i < my_m.uniqueSize(); i++)
    {
        ItemType val;
        int quant = my_m.get(i, val);
        for (int k = 0; k < quant; k++)
        {
            std::cout << val << std::endl;
        }
    }
}
