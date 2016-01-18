#include "Actor.h"
#include "StudentWorld.h"
#include "GameConstants.h"

#include <cstdlib>

// Students:  Add code to this file (if you wish), Actor.h, StudentWorld.h, and StudentWorld.cpp

// helper function
// converts a GraphObject Direction to dx and dy
void dirToDeltas(GraphObject::Direction d, int& dx, int& dy)
{
    dx = 0, dy = 0;
    switch(d)
    {
        case GraphObject::up:
            dy = 1;
            break;
        case GraphObject::down:
            dy = -1;
            break;
        case GraphObject::left:
            dx = -1;
            break;
        case GraphObject::right:
            dx = 1;
        default:
            break;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Agent
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// move forward 1 space in current direction
bool Agent::moveIfPossible()
{
    // only move if avent is alive
    if (!isAlive())
        return false;
    
    int dx = 0, dy = 0;
    dirToDeltas(getDirection(), dx, dy);
    
    if (getWorld()->canAgentMoveTo(this, getX(), getY(), dx, dy))
    {
        moveTo(getX()+dx, getY()+dy);
        return true;
    }
    else return false;
}


// attempt to shoot a bullet in front of you
// returns true if bullet is shot
bool Agent::shoot()
{
    int dx = 0, dy = 0;
    dirToDeltas(getDirection(), dx, dy);
    
    if (needsClearShot() && !getWorld()->existsClearShotToPlayer(getX()+dx, getY()+dy, dx, dy))
        return false;
    
    else
    {
        getWorld()->playSound(shootingSound());
        getWorld()->addActor(new Bullet(getWorld(), getX()+dx, getY()+dy, getDirection()));
        return true;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Player
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// reads inputs, acts accordingly
// can either
//      shoot
//      move/change direction
//      restart current level (lose a life)
void Player::doSomething()
{
    // if not alive, then dont do anything
    if (!isAlive())
    {
        getWorld()->setGameStatus(GWSTATUS_PLAYER_DIED);
        return;
    }
    
    // take in any inputs
    int ch;
    if (getWorld()->getKey(ch))
    {
        int dx = 0, dy = 0;
        dirToDeltas(getDirection(), dx, dy);
        
        switch (ch)
        {
                // change direction
            case KEY_PRESS_UP:
                setDirection(GraphObject::up);
                moveIfPossible();
                break;
            case KEY_PRESS_DOWN:
                setDirection(GraphObject::down);
                moveIfPossible();
                break;
            case KEY_PRESS_LEFT:
                setDirection(GraphObject::left);
                moveIfPossible();
                break;
            case KEY_PRESS_RIGHT:
                setDirection(GraphObject::right);
                moveIfPossible();
                break;
                
                // shoot a bullet
            case KEY_PRESS_SPACE:
                if (getAmmo() > 0)
                {
                    shoot();
                    decreaseAmmo();
                }
                break;
                
                // lose a life
            case KEY_PRESS_ESCAPE:
                setDead();
                return;
            default:
                break;
        }
    }
}

// Damages player by calling base damage method
// plays corresponding sounds (for impact and death)
void Player::damage(unsigned int damageAmt)
{
    Actor::damage(damageAmt);
    if (!isAlive())
    {
        getWorld()->decLives();
        getWorld()->playSound(SOUND_PLAYER_DIE);
    }
    else getWorld()->playSound(SOUND_PLAYER_IMPACT);
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Boulder
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// x and y are the target position of the boulder
// moves the boulder the target position, only if boulder is alive
// this function returns false if the agent being pushed is not a boulder
bool Actor::bePushedBy(Agent* a, int x, int y)
{
    if (a->isAlive() && a->isSwallowable())
    {
        moveTo(x, y);
        return true;
    }
    else
        return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Hole
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// attempts to swallow any objects on its space
void Hole::doSomething()
{
    if (!isAlive())
        return;
    
    getWorld()->swallowSwallowable(this);
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Jewel
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// attempts to be picked up by player
// if picked up, plays the corresponding sounds
// and increments the score
void Jewel::doSomething()
{
    // if jewel is alive and same spot as player
    //      add to the game score
    //      delete itself
    if ((isAlive()) &&
        (getWorld()->isPlayerColocatedWith(getX(), getY())))
    {
        getWorld()->increaseScore(returnScore());
        getWorld()->decJewels();
        getWorld()->playSound(SOUND_GOT_GOODIE);
        setDead();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Goodies
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// goodie base class attempts to be picked up by player and play corresponding sounds
void Goodie::doSomething()
{
    if (!isAlive()) return;
    
    if (getWorld()->isPlayerColocatedWith(getX(), getY()))
    {
        getWorld()->increaseScore(returnScore());
        getWorld()->playSound(SOUND_GOT_GOODIE);
        setDead();
    }
}

// extra life increases lives by 1 if picked up
void ExtraLifeGoodie::doSomething()
{
    if (isAlive() && getWorld()->isPlayerColocatedWith(getX(), getY()))
        getWorld()->incLives();
    
    Goodie::doSomething();
}

// restore health restores health to full if picked up
void RestoreHealthGoodie::doSomething()
{
    if (isAlive() && getWorld()->isPlayerColocatedWith(getX(), getY()))
        getWorld()->restorePlayerHealth();
    
    Goodie::doSomething();
}

// ammo increases ammo by 20 if picked up
void AmmoGoodie::doSomething()
{
    if (isAlive() && getWorld()->isPlayerColocatedWith(getX(), getY()))
        getWorld()->increaseAmmo();
    
    Goodie::doSomething();
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Exit
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
void Exit::doSomething()
{
    // first time getting revealed
    if (!getWorld()->anyJewels() && !isVisible())
    {
        this->setVisible(true);
        getWorld()->playSound(SOUND_REVEAL_EXIT);
    }
    
    // normal operation
    if (getWorld()->isPlayerColocatedWith(getX(), getY()) && isVisible())
    {
        getWorld()->increaseScore(2000);
        getWorld()->increaseScore(getWorld()->getBonus());
        getWorld()->playSound(SOUND_FINISHED_LEVEL);
        getWorld()->setLevelFinished();
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Bullet
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
void Bullet::doSomething()
{
    // if not alive, don't do anything
    if (!isAlive())
        return;
    
    // convert direction to deltas
    int dx = 0, dy = 0;
    dirToDeltas(getDirection(), dx, dy);
    
    // if bullet hits something (colocated with)
    //      attempt to damage it
    //      delete the bullet
    
    if (isAlive() && getWorld()->damageSomething(this, 2))
        setDead();
    
    // first time it's created, don't move the bullet
    // this allows the bullet to be drawn in front of the player (be visible)
    if (!just_created)
    {
        moveTo(getX()+dx, getY()+dy);
        if (isAlive() && getWorld()->damageSomething(this, 2))
            setDead();
    }
    just_created = false;
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Robot
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
Robot::Robot(StudentWorld* world, int startX, int startY, int imageID,
             unsigned int hitPoints, unsigned int score, Direction startDir) : Agent(world, startX, startY, imageID, hitPoints, startDir)
{
    ticks = (28 - getWorld()->getLevel()) / 4;  // levelNumber is the current // level number (0, 1, 2, etc.)
    if (ticks < 3)
        ticks = 3;                              // no Robot moves more frequently than this
    m_score = score;
}

void Robot::damage(unsigned int damageAmt)
{
    Actor::damage(damageAmt);
    if (!isAlive())
    {
        if (this->countsInFactoryCensus())
            dropHeld();
        getWorld()->playSound(SOUND_ROBOT_DIE);
        getWorld()->increaseScore(returnScore());
    }
    else getWorld()->playSound(SOUND_ROBOT_IMPACT);
}

// handles resting, checks if robot is alive
void Robot::doSomething()
{
    if (!isAlive())
    {
        isResting = true;
    }
    else if (cur_tick < ticks)
    {
        cur_tick++;
        isResting = true;
    }
    else if (cur_tick >= ticks)
    {
        cur_tick = 1;
        isResting = false;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      SnarlBot
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
void SnarlBot::doSomething()
{
    Robot::doSomething();
    
    if (!isAlive())
        return;
    
    if (performAction())
    {
        // shoot
        if (shoot())
            return;
        
        // attempt to move, if you can't, then turn
        if (!moveIfPossible())
        {
            switch(getDirection())
            {
                case up:
                    setDirection(down);
                    break;
                case down:
                    setDirection(up);
                    break;
                case left:
                    setDirection(right);
                    break;
                case right:
                    setDirection(left);
                    break;
                default:
                    break;
            }
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      KleptoBots
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
// drop the held item if possible
void KleptoBot::dropHeld()
{
    if (getHeld() != Actor::no_goodie)
    {
        if (getHeld() == Actor::extra_life_goodie)
        {
            getWorld()->addActor(new ExtraLifeGoodie(getWorld(), getX(), getY()));
            setHeld(Actor::no_goodie);
        }
        if (getHeld() == Actor::ammo_goodie)
        {
            getWorld()->addActor(new AmmoGoodie(getWorld(), getX(), getY()));
            setHeld(Actor::no_goodie);
        }
        if (getHeld() == Actor::restore_health_goodie)
        {
            getWorld()->addActor(new RestoreHealthGoodie(getWorld(), getX(), getY()));
            setHeld(Actor::no_goodie);
        }
        setHeld(Actor::no_goodie);
    }
}

void KleptoBot::doSomething()
{
    if (!isAlive())
        return;
    
    if (performAction())
    {
        // pick up item if possible
        if ((rand()%10 == 0) && (getHeld() == Actor::no_goodie))
        {
            setHeld(getWorld()->steal(getX(), getY()));
        }
        
        // move if possible
        // if moved, then decrement distance before turning
        if ((distance_before_turning > 0) && moveIfPossible())
        {
            distance_before_turning--;
        }
        // if you can't move, then turn and move
        // if you can't turn and move, just turn
        else
        {
            // set the new distance
            distance_before_turning = rand()%6 + 1;
            
            // temporary direction
            GraphObject::Direction d = GraphObject::up;
            
            // keep track of attempted Directions
            bool attempted_up = false, attempted_down = false, attempted_left = false, attempted_right = false;
            
            while (!attempted_up || !attempted_down || !attempted_left || !attempted_right)
            {
                // switch random numbers into Direction
                int int_d = rand()%4 + 1;
                switch (int_d)
                {
                    case 1:
                        d = GraphObject::up;
                        attempted_up = true;
                        break;
                    case 2:
                        d = GraphObject::down;
                        attempted_down = true;
                        break;
                    case 3:
                        d = GraphObject::left;
                        attempted_left = true;
                        break;
                    case 4:
                        d = GraphObject::right;
                        attempted_right = true;
                        break;
                    default:
                        break;
                }
                
                // set new direction
                setDirection(d);
                
                // attempt to move
                if (moveIfPossible())
                {
                    distance_before_turning--;
                    // if it does move, exit
                    return;
                }
            }
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Regular KleptoBots
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
void RegularKleptoBot::doSomething()
{
    // handle sleeping
    Robot::doSomething();
    
    // normal kleptobot actions
    KleptoBot::doSomething();
}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      Angry KleptoBots
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
void AngryKleptoBot::doSomething()
{
    // handle sleeping
    Robot::doSomething();
    
    // convert direction to deltas
    int dx = 0, dy = 0;
    dirToDeltas(getDirection(), dx, dy);
    
    // attempt to shoot
    if (isAlive() && performAction() && shoot())
        return;
    
    // pickup items, move, turn (normal kleptobot actions)
    KleptoBot::doSomething();
}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//      KleptoBot Factories
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
void KleptoBotFactory::doSomething()
{
    // 1 in 50 chance
    if (rand()%50 == 0)
    {
        // if the census is less than 3 and there are no kleptobots on the factory space
        int count = 0;
        if (getWorld()->doFactoryCensus(getX(), getY(), 3, count) && count < 3)
        {
            // play sound for robot born
            getWorld()->playSound(SOUND_ROBOT_BORN);
            
            // create a kleptobot according to type
            if (p_type == REGULAR)
                getWorld()->addActor(new RegularKleptoBot(getWorld(), getX(), getY()));
            else
                getWorld()->addActor(new AngryKleptoBot(getWorld(), getX(), getY()));
        }
        
    }
}


















