#ifndef STUDENTWORLD_H_
#define STUDENTWORLD_H_

#include "GameWorld.h"
#include "GameConstants.h"
#include <string>

#include "Actor.h"
#include "Level.h"
#include <vector>

#include <iostream>
#include <string>

using namespace std;

// Students:  Add code to this file, StudentWorld.cpp, Actor.h, and Actor.cpp

class StudentWorld : public GameWorld
{
public:
    //constructor
    StudentWorld(std::string assetDir)
    : GameWorld(assetDir)
    {}
    
    // destructor
    ~StudentWorld()
    {
        cleanUp();
    }
    
    virtual int init()
    {
        m_bonus = 1000;
        
        // load the level file
        Level lev(assetDirectory());
        string cur_lev = "level";
        int temp = getLevel();
        
        if (temp < 10) cur_lev += "0";
        cur_lev = cur_lev + to_string(temp) + ".dat";
        Level::LoadResult result = lev.loadLevel(cur_lev);
        if (result == Level::load_fail_file_not_found)
            return GWSTATUS_PLAYER_WON;
        else if (result == Level::load_fail_bad_format)
            return GWSTATUS_LEVEL_ERROR;
        else if (result == Level::load_success)
        {
            for (int col = 0; col < 15; col++)
            {
                for (int row = 0; row < 15; row++)
                {
                    // create initial actors based on level file
                    Level::MazeEntry item = lev.getContentsOf(col, row);
                    switch (item)
                    {
                        case Level::player:
                            m_player = new Player(this, col, row);
                            break;
                        case Level::wall:
                            addActor(new Wall(this, col, row));
                            break;
                        case Level::boulder:
                            addActor(new Boulder(this, col, row));
                            break;
                        case Level::hole:
                            addActor(new Hole(this, col, row));
                            break;
                        case Level::jewel:
                            num_jewels++;
                            addActor(new Jewel(this, col, row));
                            break;
                        case Level::extra_life:
                            addActor(new ExtraLifeGoodie(this, col, row));
                            break;
                        case Level::restore_health:
                            addActor(new RestoreHealthGoodie(this, col, row));
                            break;
                        case Level::ammo:
                            addActor(new AmmoGoodie(this, col, row));
                            break;
                        case Level::exit:
                            addActor(new Exit(this, col, row));
                            break;
                        case Level::horiz_snarlbot:
                            addActor(new SnarlBot(this, col, row, GraphObject::right));
                            break;
                        case Level::vert_snarlbot:
                            addActor(new SnarlBot(this, col, row, GraphObject::down));
                            break;
                        case Level::kleptobot_factory:
                            addActor(new KleptoBotFactory(this, col, row, KleptoBotFactory::REGULAR));
                            break;
                        case Level::angry_kleptobot_factory:
                            addActor(new KleptoBotFactory(this, col, row, KleptoBotFactory::ANGRY));
                            break;
                        case Level::empty:
                        default:
                            break;
                    }
                }
            }
        }
        
        // continue game
        return GWSTATUS_CONTINUE_GAME;
    }
    
    virtual int move()
    {
        // if finished level, don't continue the game
        if (game_status != GWSTATUS_CONTINUE_GAME)
        {
            switch (game_status)
            {
                case GWSTATUS_FINISHED_LEVEL:
                    game_status = GWSTATUS_CONTINUE_GAME;
                    return GWSTATUS_FINISHED_LEVEL;
                    break;
                case GWSTATUS_PLAYER_DIED:
                    game_status = GWSTATUS_CONTINUE_GAME;
                    return GWSTATUS_PLAYER_DIED;
                    break;
            }
        }
        
        // decrement bonus score at each tick
        if (m_bonus > 0)
            m_bonus--;
        
        // player does something
        m_player->doSomething();
        
        // if finished level, don't continue the game
        if (game_status != GWSTATUS_CONTINUE_GAME)
        {
            switch (game_status)
            {
                case GWSTATUS_FINISHED_LEVEL:
                    game_status = GWSTATUS_CONTINUE_GAME;
                    return GWSTATUS_FINISHED_LEVEL;
                    break;
                case GWSTATUS_PLAYER_DIED:
                    game_status = GWSTATUS_CONTINUE_GAME;
                    return GWSTATUS_PLAYER_DIED;
                    break;
            }
        }
        
        // everyone does something
        for (int k = 0; k < actor_list.size(); k++)
        {
            actor_list[k]->doSomething();
        }
        
        // delete dead actors
        for (int k = 0; k < actor_list.size(); k++)
        {
            // current actor is dead
            if (!actor_list[k]->isAlive())
            {
                delete actor_list[k];
                actor_list.erase(actor_list.begin() + k);
                k--;
            }
        }
        
        setGameStatText(composeString());
        
        return GWSTATUS_CONTINUE_GAME;
    }
    
    virtual void cleanUp()
    {
        delete m_player;
        
        while (!actor_list.empty())
        {
            delete actor_list[0];
            actor_list.erase(actor_list.begin());
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    // helper functions
    //////////////////////////////////////////////////////////////////////////////////////////////
    // Can agent move to x,y?  (dx and dy indicate the direction of motion)
    bool canAgentMoveTo(Agent* agent, int x, int y, int dx, int dy) const;
    
    // Can a boulder move to x,y?
    bool canBoulderMoveTo(int x, int y) const;
    
    // Swallow any swallowable object at a's location.  (a is only ever
    // going to be a hole.)
    bool swallowSwallowable(Actor* a) const;
    
    // Is the player on the same square as an Actor?
    bool isPlayerColocatedWith(int x, int y) const;
    
    // Try to cause damage to something at a's location.  (a is only ever
    // going to be a bullet.)  Return true if something stops a --
    // something at this location prevents a bullet from continuing.
    bool damageSomething(Actor* a, unsigned int damageAmt);
    
    // If a bullet were at x,y moving in direction dx,dy, could it hit the
    // player without encountering any obstructions?
    bool existsClearShotToPlayer(int x, int y, int dx, int dy) const;
    
    // If a factory is at x,y, how many items of the type that should be
    // counted are in the rectangle bounded by x-distance,y-distance and
    // x+distance,y+distance?  Set count to that number and return true,
    // unless an item is on the factory itself, in which case return false
    // and don't care about count.  (The items counted are only ever going
    // KleptoBots.)
    bool doFactoryCensus(int x, int y, int distance, int& count) const;
    
    // If an item a that can be stolen is at x,y, return a pointer to it and delete
    // the item off the Actor* vector; otherwise, return a null pointer.  (Stealable
    // items are only ever going be goodies.)
    // If the function returns a stealable item, delete the item off the Actor* vector
    Actor::GoodieType steal(int x, int y);
    
    // Restore player's health to the full amount.
    void restorePlayerHealth() { getPlayer()->setHitPoints(20); }
    
    // Increase the amount of ammunition the player has by 20
    void increaseAmmo();
    
    // Are there any jewels left on this level?
    bool anyJewels() const;
    
    // Reduce the count of jewels on this level by 1.
    bool decJewels();
    
    // Indicate that the player has finished the level.
    void setLevelFinished();
    
    // Add an actor to the world
    void addActor(Actor* a)
    {
        if (a != nullptr) actor_list.push_back(a);
        Actor* b = dynamic_cast<Bullet*>(a);
        if (b != nullptr) damageSomething(b, 2);
    }
    
    // sets the game status
    void setGameStatus(int stat) { game_status = stat; }
    
    // returns a pointer to the player if player exists
    // otherwise returns nullptr
    Actor* getPlayer() const { return m_player; }
    
    string composeString() const;
    
    int getBonus() const { return m_bonus; }
    
private:
    // vector holds all the actors
    vector<Actor*> actor_list;
    
    // player pointer points to the player, isnt on the actor list
    Player* m_player = nullptr;
    
    int game_status = GWSTATUS_CONTINUE_GAME;
    int num_jewels = 0;
    int m_bonus = 1000;
};

#endif // STUDENTWORLD_H_
