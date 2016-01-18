//
//  eval.cpp
//  Homework2
//
//  Created by Wenlong Xiong on 1/29/15.
//  Copyright (c) 2015 Wenlong Xiong. All rights reserved.
//

#include <cassert>
#include <iostream>
#include <string>
#include <stack>
#include <cctype>
using namespace std;

bool precedence (char, char);
bool checkValidity(string);

static string p;

int evaluate(string infix, const bool values[], string& postfix, bool& result)
// Evaluates a boolean expression
// Postcondition: If infix is a syntactically valid infix boolean
//   expression, then postfix is set to the postfix form of that
//   expression, result is set to the value of the expression (where
//   in that expression, each digit k represents element k of the
//   values array), and the function returns zero.  If infix is not a
//   syntactically valid expression, the function returns 1.  (In that
//   case, postfix may or may not be changed, but result must be
//   unchanged.)
{
    bool valid = checkValidity(infix);
    if (!valid)
        return 1;
    
    // convert infix to postfix
    stack<char> operatorStack;
    postfix = "";
    for (int i = 0; i < infix.length(); i++)
    {
        switch (infix[i])
        {
            // operands
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                postfix += infix[i];
                break;
                
            case '(':
                operatorStack.push('(');
                break;
                
            case ')':
                while (operatorStack.top() != '(')
                {
                    postfix += operatorStack.top();
                    operatorStack.pop();
                }
                operatorStack.pop();
                break;
            
            // operators
            case '!':
            case '&':
            case '|':
                while (!operatorStack.empty() && (operatorStack.top() != '(') && precedence(infix[i], operatorStack.top()))
                {
                    postfix += operatorStack.top();
                    operatorStack.pop();
                }
                operatorStack.push(infix[i]);
                break;
            
            // ignore spaces for readability
            case ' ':
                break;
            
            // infix expression contains nonvalid characters
            default:
                return 1;
                
        }
    }
    
    while (!operatorStack.empty())
    {
        postfix += operatorStack.top();
        operatorStack.pop();
    }
    
    if (valid)
    {
        // initializer operator stack to empty
        stack<char> operandStack;
        
        // for each character in postfix string
        for (int k = 0; k < postfix.length(); k++)
        {
            if ((postfix[k] != '&') && (postfix[k] != '|') && (postfix[k] != '!'))
            {
                int n;
                switch (postfix[k])
                {
                    case '0':
                        n = 0;
                        break;
                    case '1':
                        n = 1;
                        break;
                    case '2':
                        n = 2;
                        break;
                    case '3':
                        n = 3;
                        break;
                    case '4':
                        n = 4;
                        break;
                    case '5':
                        n = 5;
                        break;
                    case '6':
                        n = 6;
                        break;
                    case '7':
                        n = 7;
                        break;
                    case '8':
                        n = 8;
                        break;
                    case '9':
                        n = 9;
                        break;
                    default:
                        return 1;
                }
                
                // push the char equivalent of the boolean value
                // 0 is false, 1 is true
                operandStack.push(values[n]);
            }
            else if (postfix[k] == '!')
            {
                char op1 = operandStack.top();
                operandStack.pop();
                operandStack.push(!op1);
            }
            else if (postfix[k] == '&')
            {
                char op2 = operandStack.top();
                operandStack.pop();
                char op1 = operandStack.top();
                operandStack.pop();
                
                operandStack.push(op1&&op2);
            }
            else if (postfix[k] == '|')
            {
                char op2 = operandStack.top();
                operandStack.pop();
                char op1 = operandStack.top();
                operandStack.pop();
                
                operandStack.push(op1||op2);
            }
        }
        
        if (operandStack.top() == 1)
            result = true;
        else
            result = false;
    }
    return 0;
}

bool precedence(char char1, char char2)
// returns true if the first character is lower or equal precedence than the second character
{
    if (char1 == '!' && char2 == '!')
        return true;
    if ((char1 == '&') && ((char2 == '!') || (char2 == '&')))
        return true;
    if (char1 == '|')
        return true;
    return false;
}

bool checkValidity(string infix)
{
    // a string consisting of   A's for operands
    //                          B's for & and |
    //                          C's for !
    // spaces from the original infix string are removed
    // any (parentheses) are converted to A's for operands
    //          and the inside of the parentheses are checked for validity recursively
    string simplifiedInfix = "";
    for (int i = 0; i < infix.length(); i++)
    {
        if (isdigit(infix[i]))
            simplifiedInfix += "A";
        else if (infix[i] == '&' || infix[i] == '|')
            simplifiedInfix += "B";
        else if (infix[i] == '(')
        {
            int k = i;
            int skip = -1;
            while (!((infix[k] == ')') && (skip <= 0)))
            {
                if (infix[k] == '(')
                    skip++;
                if (infix[k] == ')')
                    skip--;
                k++;
                // never encounter the corresponding parentheses
                if (k >= infix.length())
                    return false;
            }
            
            if (k-i == 1)
            {
                return false;
            }
            
            // if there is stuff inside the parentheses, call checkValidity recursively
            if (k-i > 1)
            {
                if (!checkValidity(infix.substr(i+1, k-i-1)))
                    return false;
                simplifiedInfix += "A";
            }
            
            i = k;
        }
        else if (infix[i] == '!')
            simplifiedInfix += "C";
        else if (infix[i] == ' ')
        {
            
        }
        else return false;
    }
    
    if ((simplifiedInfix[0] != 'A' && simplifiedInfix[0] != 'C') || (simplifiedInfix[simplifiedInfix.length()-1] != 'A'))
        return false;
    
    for (int m = 0; m < simplifiedInfix.length()-1; m++)
    {
        if (simplifiedInfix[m] == 'A')
        {
            if (simplifiedInfix[m+1] != 'B')
                return false;
        }
        else if (simplifiedInfix[m] == 'B')
        {
            if (!((simplifiedInfix[m+1] == 'A') || (simplifiedInfix[m+1] == 'C')))
                return false;
        }
        else if (simplifiedInfix[m] == 'C')
        {
            if (simplifiedInfix[m+1] == 'B')
                return false;
        }
    }
    return true;
}

