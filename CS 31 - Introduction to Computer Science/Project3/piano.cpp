#include <iostream>
#include <string>
#include <cctype>
#include <cassert>
using namespace std;

int nextNoteLength(string, int);
int nextBeatLength(string, int);
int inRange(string);
bool isTuneWellFormed(string);
int translateTune(string, string&, int&);
char translateNote(int, char, char);


int main()
{
    /*
    assert(isTuneWellFormed("D5//D/"));
    assert(!isTuneWellFormed("D5//Z/"));
    string instrs;
    int badb;
    instrs = "xxx"; badb = -999; // so we can detect whether these get changed
    assert(translateTune("D5//D/", instrs, badb) == 0  &&  instrs == "R H"  &&  badb == -999);
    instrs = "xxx"; badb = -999; // so we can detect whether these get changed
    assert(translateTune("D5//Z/", instrs, badb) == 1  &&  instrs == "xxx"  &&  badb == -999);
    assert(translateTune("D5//D8/", instrs, badb) == 2  &&  instrs == "xxx"  &&  badb == 3);
    cerr << "All tests succeeded" << endl;
    */
    
    assert(isTuneWellFormed(""));
    assert(isTuneWellFormed("/"));
    assert(isTuneWellFormed("/////////"));
    assert(isTuneWellFormed("D/"));
    assert(isTuneWellFormed("D/D/D/D/"));
    assert(isTuneWellFormed("DDD/DDD/DD/"));
    assert(isTuneWellFormed("D/"));
    assert(isTuneWellFormed("D#/"));
    assert(isTuneWellFormed("Db/"));
    assert(isTuneWellFormed("D5/"));
    assert(isTuneWellFormed("D#5/"));
    assert(isTuneWellFormed("Db5/"));
    assert(!isTuneWellFormed("D5b/"));
    assert(!isTuneWellFormed("D"));
    assert(!isTuneWellFormed("D/D"));
    assert(!isTuneWellFormed("DDDDDDDDD"));
    assert(!isTuneWellFormed("Z/"));
    assert(!isTuneWellFormed("b/"));
    assert(!isTuneWellFormed("6/"));
    assert(!isTuneWellFormed("#/"));
    assert(!isTuneWellFormed("D##/D/D/"));
    assert(!isTuneWellFormed("D88/D/D/"));
    
    string instrs;
    int badb;
    instrs = "xxx"; badb = -999; // so we can detect whether these get changed
    assert(translateTune("", instrs, badb) == 0  &&  instrs == ""  &&  badb == -999);
    
    cerr << "All tests succeeded" << endl;
}

//returns the length of the next note without '/'
//if no note, returns 0
//ex: "B3" returns length 2
//ex: "/" returns length 0
int nextNoteLength(string tune, int init)
{
    int length = 0;
    bool isNote = false;
    
    //loops through tune starting from initial index
    for (int i = init; i < (tune.length()); i++)
    {
        //beginning of note always starts with uppercase letter
        if (isalpha(tune[i]) && isupper(tune[i]))
        {
            if (!isNote)
            {
                isNote = true;
                length ++;
            }
            else
                return length;
        }
        else if ((tune[i] == '/') && isNote)
            return length;
        else if ((tune[i] == '/') && !isNote)
            return 0;                           //if no note, just '/', return 0
        else
            length++;
    }
    return length;
}

//returns the length of the next beat without '/'
//if no note, returns 0
//ex: "BC/" has length 2
//ex: "/" has length 0
int nextBeatLength(string tune, int init)
{
    int length = 0;
    for (int i = init; i < tune.length(); i++)
    {
        if (tune[i] != '/')
            length++;
        else
            break;
    }
    return length;
}

//returns -1 if everything is in range
//else returns index of beat that contained note out of range
int inRange(string tune)
{
    //iterates through the tune, checking if notes are in range
    //assumes everything is well formed
    
    int currentBeat = 1;
    int i = 0;
    while(i < tune.length())
    {
        string note;
        if (nextNoteLength(tune, i) == 0)
        {
            //end of beat, or empty beat
            i++;            //nextNoteLength() returns 0 here, so need to increment
            currentBeat++;  //next beat
            continue;
        }
        else
            note = tune.substr(i, nextNoteLength(tune, i));

        //check if note is in range
        
        //if note length = 1
        //just a single letter note
        
        if (note.length() == 1)
            i += nextNoteLength(tune, i);
        else if (note.length() == 2)
        {
            //if note length = 2
            //can be either note + octave or note + accidental
            
            //if accidental then it's true
            //if octave then if in range (2,3,4,5) or note C6 it's true
            if ((note[1] == '#') || (note[1] == 'b'))
                i += nextNoteLength(tune, i);
            else if ((note[1] == '2') || (note[1] == '3') || (note[1] == '4') || (note[1] == '5'))
                i += nextNoteLength(tune, i);
            else if (note[1] == '6')
            {
                if (note[0] == 'C')
                    i += nextNoteLength(tune, i);
                else
                    return currentBeat;
            }
            else
                return currentBeat;
        }
        else
        {
            //if note length = 3
            //is note + octave + accidental
            
            //must be within octaves (2,3,4,5)
            //exceptions:
            //if octave 6, Cb6 is okay
            //if octave 1, B#1 is okay
            //if octave 2, Cb2 not okay
            
            if ((note[2] == '3') || (note[2] == '4') || (note[2] == '5'))
                i += nextNoteLength(tune, i);
            else if (note[2] == '6')
            {
                if ((note[0] == 'C') && (note[1] == 'b'))
                    i += nextNoteLength(tune, i);
                else
                    return currentBeat;
            }
            else if (note[2] == '1')
            {
                if ((note[0] == 'B') && (note[1] == '#'))
                    i += nextNoteLength(tune, i);
                else
                    return currentBeat;
            }
            else if (note[2] == '2')
            {
                if ((note[0] == 'C') && (note[1] == 'b'))
                    return currentBeat;
                else
                    i += nextNoteLength(tune, i);
            }
            else
                i += nextNoteLength(tune, i);
        }
    }
    return -1;
}

//returns true if tune is well formed
//returns false if not well formed
bool isTuneWellFormed(string tune)
{
    bool isNote = false;
    bool hasAccidental = false;
    bool hasDigit = false;
    bool allowedNote = false;
    string allowedChars = "ABCDEFG";
    if (tune == "")
        return true;
    else
    {
        for (int i = 0; i < (tune.length()); i++)
        {
            //not part of a note sequence (series of chars that form a note)
            if (!isNote)
                //must be uppercase letter character
                if (isalpha(tune[i]) && isupper(tune[i]))
                {
                    isNote = true;  //starts a note sequence
                    hasAccidental = false;
                    hasDigit = false;
                    
                    //checks if note letter is allowed
                    allowedNote = false;
                    for (int j = 0; j < allowedChars.length(); j++)
                    {
                        if (tune[i] == allowedChars[j])
                        {
                            allowedNote = true;
                            break;
                        }
                    }
                }
                //skips over '/'
                else if (tune[i] == '/')
                {
                    isNote = false;
                    allowedNote = true;
                }
                else
                    return false;
            else
            {
                //has digit already and current character is accidental (wrong order)
                if (hasDigit)
                {
                    if ((tune[i] == 'b') || (tune[i] == '#'))
                        return false;
                }
                    
                //check there are no double ups (double sharps/flats, double octaves)
                if ((tune[i] == 'b') || (tune[i] == '#'))
                {
                    if (hasAccidental)
                        return false;
                    else
                        hasAccidental = true;
                }
                else if (isdigit(tune[i]))
                {
                    if (hasDigit)
                        return false;
                    else
                        hasDigit = true;
                }
                //checks for end of note sequence
                else if (tune[i] == '/')
                {
                    isNote = false;
                    allowedNote = true;
                }
                
                if (!(((tune[i] == 'b') || (tune[i] == '#')) || (isdigit(tune[i])) || (tune[i] == '/')))
                {
                    //if not accidental, octave, or endbeat, then
                    //either is chord (alpha character)
                    if (isalpha(tune[i]) && isupper(tune[i]))
                    {
                        isNote = true;
                        hasAccidental = false;
                        hasDigit = false;
                        
                        allowedNote = false;
                        for (int j = 0; j < allowedChars.length(); j++)
                        {
                            if (tune[i] == allowedChars[j])
                            {
                                allowedNote = true;
                                break;
                            }
                        }
                    }
                    //or is not well formed (unreadable character)
                    else
                        return false;
                }
            }
            
            //if note not allowed, not well formed
            if (!allowedNote)
                return false;
        }
        
        //still in note sequence (no '/' to end beat)
        if (isNote)
            return false;
        else
            return true;
    }
}

//provided functon
char translateNote(int octave, char noteLetter, char accidentalSign)
{
    // This check is here solely to report a common CS 31 student error.
    if (octave > 9)
    {
        cerr << "********** translateNote was called with first argument = "
        << octave << endl;
    }
    
    // Convert Cb, C, C#/Db, D, D#/Eb, ..., B, B#
    //      to -1, 0,   1,   2,   3, ...,  11, 12
    
    int note;
    switch (noteLetter)
    {
        case 'C':  note =  0; break;
        case 'D':  note =  2; break;
        case 'E':  note =  4; break;
        case 'F':  note =  5; break;
        case 'G':  note =  7; break;
        case 'A':  note =  9; break;
        case 'B':  note = 11; break;
        default:   return ' ';
    }
    switch (accidentalSign)
    {
        case '#':  note++; break;
        case 'b':  note--; break;
        case ' ':  break;
        default:   return ' ';
    }
    
    // Convert ..., A#1, B1, C2, C#2, D2, ... to
    //         ..., -2,  -1, 0,   1,  2, ...
    
    int sequenceNumber = 12 * (octave - 2) + note;
    
    string keymap = "Z1X2CV3B4N5M,6.7/A8S9D0FG!H@JK#L$Q%WE^R&TY*U(I)OP";
    if (sequenceNumber < 0  ||  sequenceNumber >= keymap.size())
        return ' ';
    return keymap[sequenceNumber];
}

//if playable: returns 0, sets instructions to translated tune
//if not well formed: returns 1
//if well formed but not playable: returns 2, sets badBeat to first unplayable beat
int translateTune(string tune, string& instructions, int& badBeat)
{
    
    //nextNote contains either the next full note (ex: D, D5, Db5) the tune or the string "/"
    
    //well-formed and playable
    if (isTuneWellFormed(tune))
    {
        if (inRange(tune) == -1)
        {
            bool beatEnded = true;  //true when current note was preceded by a '/'
                                    //used to determine when to add a space
            instructions = "";      //replace instructions with translated ones
            
            //translate tune and add translated tune to instructions
            int i = 0;
            while (i < tune.length())
            {
                //if there is a chord, add [] around translated notes
                if (nextNoteLength(tune, i) < nextBeatLength(tune, i))
                {
                    instructions += "[";
                    for (int j = i; tune[j] != '/'; j += nextNoteLength(tune, j))
                    {
                        string nextNote = tune.substr(j, nextNoteLength(tune, j));
                        
                        //translate the note
                        if (nextNote.length() == 1)
                            instructions += translateNote(4 , nextNote[0], ' ');
                        else if (nextNote.length() == 2)
                        {
                            if (isdigit(nextNote[1]))
                            {
                                instructions += translateNote((nextNote[1] - '0'), nextNote[0], ' ');
                            }
                            else
                                instructions += translateNote(4, nextNote[0], nextNote[1]);
                        }
                        else if (nextNote.length() == 3)
                            instructions += translateNote((nextNote[2] - '0'), nextNote[0], nextNote[1]);
                    }
                    instructions += "]";
                    
                    i += nextBeatLength(tune, i) + 1;
                    beatEnded = true;
                }
                //for single notes check to see if beat has ended ('/' character)
                else
                {
                    //if empty beat, output a space
                    //if preceded by a note, change beatEnded to true for next note
                    string nextNote;
                    if (nextNoteLength(tune, i) == 0)
                    {
                        if (beatEnded)
                        {
                            instructions += ' ';
                            i++;
                            continue;
                        }
                        else
                        {
                            beatEnded = true;
                            i++;
                            continue;
                        }
                    }
                    else
                    {
                        nextNote = tune.substr(i, nextNoteLength(tune, i));
                        beatEnded = false;
                    }
                    
                    //if note is not "/", and is a single note, translate note
                    if (nextNote.length() == 1)
                        instructions += translateNote(4 , nextNote[0], ' ');
                    else if (nextNote.length() == 2)
                    {
                        if (isdigit(nextNote[1]))
                        {
                            instructions += translateNote((nextNote[1] - '0'), nextNote[0], ' ');
                        }
                        else
                            instructions += translateNote(4, nextNote[0], nextNote[1]);
                    }
                    else if (nextNote.length() == 3)
                        instructions += translateNote((nextNote[2] - '0'), nextNote[0], nextNote[1]);
                    
                    if (nextNoteLength(tune, i) == 0)
                        i++;
                    else
                        i += nextNoteLength(tune, i);
                }
            }
            return 0;
        }
        
        //well-formed but not playable
        else
        {
            badBeat = inRange(tune);
            return 2;
        }
    }
    
    //not well-formed
    else
        return 1;
}
