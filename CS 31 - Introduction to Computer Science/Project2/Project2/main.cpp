#include <iostream>
#include <string>
using namespace std;

int main()
{
    int NUM_FREE_MINS = 500;
    int NUM_FREE_TEXTS = 200;
    double BASIC_PLAN_CHARGE = 40.0;
    double COST_PER_MIN = .45;
    double COST_PER_TEXT_REGULAR = .03;
    double COST_PER_TEXT_SUMMER = .02;
    double COST_PER_TEXT_BEYOND_400 = .11;
    
    int numMinutes;
    int numTexts;
    int month;
    double bill = BASIC_PLAN_CHARGE;
    string customerName;
    
    
    cout << "Minutes used: ";
    cin >> numMinutes;
    
    cout << "Text messages: ";
    cin >> numTexts;
    cin.ignore(1000, '\n');
    
    cout << "Customer name: ";
    getline(cin, customerName);
    
    cout << "Month number (1=Jan, 2=Feb, etc.): ";
    cin >> month;
    
    cout << "---\n";
    
    if (numMinutes < 0)
        cout << "The number of minutes used must be nonnegative.\n";
    else if (numTexts < 0)
        cout << "The number of text messages must be nonnegative.\n";
    else if (customerName == "")
        cout << "You must enter a customer name.\n";
    else if (!((month == 1) || (month == 2) || (month == 3) || (month == 4) || (month == 5) || (month == 6) || (month == 7) || (month == 8) || (month == 9) || (month == 10) || (month == 11) || (month == 12)))
        cout << "The month number must be in the range 1 through 12.\n";
    else
    {
        if (numMinutes > NUM_FREE_MINS)
            bill += (numMinutes - NUM_FREE_MINS) * COST_PER_MIN;
        else if (numTexts > NUM_FREE_TEXTS)
        {
            if (numTexts > 400)
            {
                bill += (numTexts - 400) * COST_PER_TEXT_BEYOND_400;
                numTexts = 400;
            }
            
            if ((month == 6) || (month == 7) || (month == 8) || (month == 9)) //if summer
                bill += (numTexts - NUM_FREE_TEXTS) * COST_PER_TEXT_SUMMER;
            else
                bill += (numTexts - NUM_FREE_TEXTS) * COST_PER_TEXT_REGULAR;
        }
        
        cout.setf(ios::fixed);
        cout.precision(2);
        cout << "The bill for " << customerName << " is $" << bill << endl;
    }
    
}
