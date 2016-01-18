#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <cassert>
using namespace std;

const int MAX_WORD_LENGTH = 20;

int standardizeRules(int[], char[][MAX_WORD_LENGTH+1], char[][MAX_WORD_LENGTH+1], int);
int determineQuality(const int[], const char[][MAX_WORD_LENGTH+1], const char[][MAX_WORD_LENGTH+1], int, const char[]);

int main()
{
    const int TEST1_NCRITERIA = 4;
    int test1dist[TEST1_NCRITERIA] = {
        2,           4,          1,           13
    };
    char test1w1[TEST1_NCRITERIA][MAX_WORD_LENGTH+1] = {
        "mad",       "deranged", "nefarious", "have"
    };
    char test1w2[TEST1_NCRITERIA][MAX_WORD_LENGTH+1] = {
        "scientist", "robot",    "plot",      "mad"
    };
    determineQuality(test1dist, test1w1, test1w2, TEST1_NCRITERIA,
                            "The mad UCLA scientist unleashed a deranged evil giant robot.");
}

int standardizeRules(int distance[],
                     char word1[][MAX_WORD_LENGTH+1],
                     char word2[][MAX_WORD_LENGTH+1],
                     int nRules)
{
    if (nRules < 0)
        return 0;
    
    //goes through and checks that only alpha chars are allowed
    //if a word fails, the distance element is changed to -1
    for (int i = 0; i < nRules; i++)
    {
        //distance
        //checks that it's positive (zero not okay)
        if (distance[i] <= 0)
        {
            distance[i] = -1;
        }
        
        //if either word contains 0 characters
        if ((strlen(word1[i]) == 0) || (strlen(word2[i]) == 0))
            distance[i] = -1;
        
        //word1
        //checks that it's alpha only, converts to lowercase
        for (int j = 0; j < strlen(word1[i]); j++)
        {
            //increment thru each word
            if (isalpha(word1[i][j]))
                word1[i][j] = tolower(word1[i][j]);
            else if (!isalpha(word1[i][j]))
            {
                distance[i] = -1;
                break;
            }
        }
        
        //word2
        //checks that it's alpha only, converts to lowercase
        for (int j = 0; j < strlen(word2[i]); j++)
        {
            if (isalpha(word2[i][j]))
                word2[i][j] = tolower(word2[i][j]);
            else if (!isalpha(word2[i][j]))
            {
                distance[i] = -1;
                break;
            }
        }
        
    }
    
    //check for flipped duplicates (ex: 1,"mad","scientist" vs 3,"scientist","mad")
    //if duplicates, the lower distance element is changed to -1
    for (int i = 0; i < nRules; i++)
    {
        for (int j = i+1; j < nRules; j++)
        {
            if ((strcmp(word1[i], word2[j]) == 0) && (strcmp(word1[j], word2[i]) == 0))
            {
                if (distance[i] < distance[j])
                    distance[i] = -1;
                else
                    distance[j] = -1;
            }
        }
    }
    
    //check for duplicates (ex: 1,"mad","scientist vs 3,"mad","scientist")
    //if duplicates, the lower distance element is changed to -1
    for (int i = 0; i < nRules; i++)
    {
        for (int j = i+1; j < nRules; j++)
        {
            if ((strcmp(word1[i], word1[j]) == 0) && (strcmp(word2[i], word2[j]) == 0))
            {
                if (distance[i] < distance[j])
                    distance[i] = -1;
                else
                    distance[j] = -1;
            }
        }
    }
    
    //count # of items to delete
    int delCount = 0;
    for (int i = 0; i < nRules; i++)
    {
        if (distance[i] == -1)
            delCount++;
            
    }
    
    //delete the disallowed items, shift all of them forward
    int wrongCount = 1;
    while (wrongCount != 0)
    {
        wrongCount = 0;
        for (int i = 0; i < nRules - delCount; i++)
        {
            if (distance[i] == -1) //item is wrong, marked for deletion
            {
                wrongCount++;
                //delete the current value and shift everything over
                for (int j = i; j < nRules-1; j++)
                {
                    distance[j] = distance[j+1];
                    strcpy(word1[j], word1[j+1]);
                    strcpy(word2[j], word2[j+1]);
                }
            }
        }
    }
    
    return (nRules - delCount);
}

int determineQuality(const int distance[],
                     const char word1[][MAX_WORD_LENGTH+1],
                     const char word2[][MAX_WORD_LENGTH+1],
                     int nRules,
                     const char document[])
{
    char stringDoc[100][200];
    
    int curWord = 0;
    int curChar = 0;
    for (int i = 0; i < strlen(document); i++)
    {
        if ((document[i] == ' ') && (curChar != 0))
        {
            stringDoc[curWord][curChar] = '\0';
            curWord++;
            curChar = 0;
        }
        else if (isalpha(document[i]))
        {
            stringDoc[curWord][curChar] = tolower(document[i]);
            curChar++;
        }
    }
    stringDoc[curWord][curChar] = '\0';
    if (curChar != 0)
        curWord++;
    int docLength = curWord;
    
    //check each rule by iterating through the entire doc
    //i iterates thru the rules
    //j iterates thru each word of the doc
    //k looks forward in the doc and searches for word2
    int numMatches = 0;
    bool nextRule = false;
    for (int i = 0; i < nRules; i++)
    {
        for (int j = 0; j < docLength; j++)
        {
            //if word1 matches, look forward until either length distance[i]
            //or until end of document for word2
            if (strcmp(word1[i], stringDoc[j]) == 0)
            {
                int k = j;
                while ((k < docLength) && (k-j < distance[i]))
                {
                    if (strcmp(word2[i], stringDoc[k+1]) == 0)
                    {
                        numMatches++;
                        nextRule = true;
                        break;
                    }
                    k++;
                }
            }
            //if word2 matches, look forward until either length distance[i]
            //or until end of document for word1
            else if (strcmp(word2[i], stringDoc[j]) == 0)
            {
                int k = j;
                while ((k < docLength) && (k-j < distance[i]))
                {
                    if (strcmp(word1[i], stringDoc[k+1]) == 0)
                    {
                        numMatches++;
                        nextRule = true;
                        break;
                    }
                    k++;
                }
            }
            if (nextRule)
            {
                nextRule = false;
                break;
            }
        }
    }
    
    return numMatches;
}


