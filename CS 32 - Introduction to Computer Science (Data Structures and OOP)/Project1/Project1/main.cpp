#include "Game.h"
#include "Game.h"
#include "Pit.h"
#include "Pit.h"
#include "History.h"
#include "History.h"
#include "Player.h"
#include "Player.h"
#include "Snake.h"
#include "Snake.h"
#include "globals.h"
#include "globals.h"
#include <cstdlib>
#include <ctime>

int main()
{
    // Initialize the random number generator.  (You don't need to
    // understand how this works.)
    srand(static_cast<unsigned int>(time(0)));
    
    // Create a game
    // Use this instead to create a mini-game:   Game g(3, 3, 2);
    Game g(9, 10, 40);
    
    // Play the game
    g.play();
}