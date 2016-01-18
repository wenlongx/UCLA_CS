#ifndef __Project1__Game__
#define __Project1__Game__

class Pit;

class Game
{
public:
    // Constructor/destructor
    Game(int rows, int cols, int nSnakes);
    ~Game();
    
    // Mutators
    void play();
    
private:
    Pit* m_pit;
};


#endif /* defined(__Project1__Game__) */
