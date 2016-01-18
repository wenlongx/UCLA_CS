//
//  linear.cpp
//  Homework 3
//
//  Created by Wenlong Xiong on 2/5/15.
//  Copyright (c) 2015 Wenlong Xiong. All rights reserved.
//

bool anyTrue(const double a[], int n)
{
    if (n>0)
        if (somePredicate(a[n-1]))
            return true;
        else return anyTrue(a, n-1);
    else return false;
}


int countTrue(const double a[], int n)
{
    if (n>0)
        if (somePredicate(a[n-1]))
           return 1+countTrue(a, n-1);
        else
            return countTrue(a, n-1);
    else return 0;
}


int firstTrue(const double a[], int n)
{
    if (n>0)
    {
        int x = n-1;                // current pos
        int y = firstTrue(a, n-1);  // position of smallest
        if (somePredicate(a[n-1]))
        {
            if (y != -1)
                return y;
            else return x;
        }
        return y;
    }
    else return -1;
}


int indexOfMin(const double a[], int n)
{
    if (n > 0)
    {
        int y = indexOfMin(a, n-1);  // position of smallest
        if (y == -1)
            return n-1;
        if (a[n-1] <= a[y])
            return n-1;
        else return y;
    }
    return -1;
}


bool includes(const double a1[], int n1, const double a2[], int n2)
{
    if (n1 <= 0 && n2 > 0)
        return false;
    if (n2 <= 0)
        return true;
    if ((n2 > 0) && (n1 > 0) && (a1[n1-1] == a2[n2-1]))
        return includes(a1, n1-1, a2, n2-1);
    else
        return includes(a1, n1-1, a2, n2);
}