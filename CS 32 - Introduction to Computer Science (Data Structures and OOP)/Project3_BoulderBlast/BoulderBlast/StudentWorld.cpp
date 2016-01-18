#include "StudentWorld.h"
#include <string>
using namespace std;

GameWorld* createStudentWorld(string assetDir)
{
    return new StudentWorld(assetDir);
}

// Students:  Add code to this file (if you wish), StudentWorld.h, Actor.h and Actor.cpp

// Can agent move to x,y?  (dx and dy indicate the direction of motion)
// returns true if the object can
// this method also moves the boulder
bool StudentWorld::canAgentMoveTo(Agent* agent, int x, int y, int dx, int dy) const
{
    if (!agent->isAlive())
        return false;
    
    for (int k = 0; k < actor_list.size(); k++)
    {
        // if the adjacent spot blocks player colocation, return false
        if (((agent->getWorld()->actor_list[k]->getX() == x+dx) &&
             (agent->getWorld()->actor_list[k]->getY() == y+dy) &&
             (agent->getWorld()->actor_list[k]->isAlive()) &&
             (!agent->getWorld()->actor_list[k]->allowsAgentColocation())) ||
            ((agent->getWorld()->m_player->getX() == x+dx) &&
             (agent->getWorld()->m_player->getY() == y+dy)))
        {
            // special case: boulder exists on the spot, and agent is player
            if (actor_list[k]->isSwallowable() && agent->canPushBoulders())
            {
                // check to see if boulder can move
                if (canBoulderMoveTo(actor_list[k]->getX()+dx, actor_list[k]->getY()+dy))
                {
                    // if boulder moves, allow player to move to spot
                    // previously occupied by boulder
                    actor_list[k]->bePushedBy(agent, actor_list[k]->getX()+dx, actor_list[k]->getY()+dy);
                    
                    // if any holes exist on the same spot as the boulder, delete both
                    for (int i = 0; i < actor_list.size(); i++)
                    {
                        if ((actor_list[i]->getX() == actor_list[k]->getX()) &&
                            (actor_list[i]->getY() == actor_list[k]->getY()) &&
                            (actor_list[i]->allowsBoulder()))
                            swallowSwallowable(actor_list[i]);
                    }
                    return true;
                }
            }
            return false;
        }
    }
    return true;
}

// Can a boulder move to x,y?
// returns true if the boulder can
// returns false if the boulder can't
bool StudentWorld::canBoulderMoveTo(int x, int y) const
{
    // check to see if any actors block colocation
    // only check actors that are
    //      alive
    //      have the same x y pos
    for (int k = 0; k < actor_list.size(); k++)
    {
        if ((actor_list[k]->getX() == x) &&
            (actor_list[k]->getY() == y) &&
            (actor_list[k]->isAlive()) &&
            (!actor_list[k]->allowsBoulder()))
            return false;
    }
    
    // if no actors block colocation, allow movement
    return true;
}

// Swallow any swallowable object at a's location.  (a is only ever
// going to be a hole.)
// if any there are any swallowable objects at a, then the first
// swallowable object and a are both set to dead.
// returns true if swallowing occurs
// returns false if no swallowable objects existed
bool StudentWorld::swallowSwallowable(Actor* a) const
{
    // if swallower is not alive, nothing happens
    if (!a->isAlive())
        return false;
    
    for (int k = 0; k < actor_list.size(); k++)
    {
        // only swallow if
        //      is a boulder
        //      x y position is the same
        //      boulder is alive
        if ((actor_list[k]->getX() == a->getX()) &&
            (actor_list[k]->getY() == a->getY()) &&
            (actor_list[k]->isSwallowable()) &&
            (actor_list[k]->isAlive()))
        {
            // swallowing means both swallowed and swallower die
            actor_list[k]->setDead();
            a->setDead();
            return true;
        }
    }
    return false;
}

// returns true if player is on said position
bool StudentWorld::isPlayerColocatedWith(int x, int y) const
{
    if ((getPlayer()->getX() == x) &&
        (getPlayer()->getY() == y))
    {
        return true;
    }
    return false;
}

// Try to cause damage to something at a's location.  (a is only ever
// going to be a bullet.)  Return true if something stops a --
// something at this location prevents a bullet from continuing.
bool StudentWorld::damageSomething(Actor *a, unsigned int damageAmt)
{
    if (!a->isAlive())
        return true;
    
    if ((m_player->getX() == a->getX()) &&
        (m_player->getY() == a->getY()))
    {
        m_player->damage(damageAmt);
        a->setDead();
        return true;
    }
    
    // attempt to damage everything on space
    for (int k = 0; k < actor_list.size(); k++)
    {
        if ((actor_list[k]->getX() == a->getX()) &&
            (actor_list[k]->getY() == a->getY()))
        {
            if (actor_list[k]->isDamageable())
            {
                actor_list[k]->damage(damageAmt);
                return true;
            }
        }
    }
    
    // stops bullet
    for (int k = 0; k < actor_list.size(); k++)
    {
        if ((actor_list[k]->getX() == a->getX()) &&
            (actor_list[k]->getY() == a->getY()))
        {
            if (actor_list[k]->stopsBullet())
            {
                a->setDead();
                return true;
            }
        }
    }
    return false;
}

// increases player ammunition by 20
void StudentWorld::increaseAmmo()
{
    m_player->increaseAmmo();
}

// return true if any jewels left in the level
bool StudentWorld::anyJewels() const
{
    if (num_jewels != 0)
        return true;
    else return false;
}

// Reduce the count of jewels on this level by 1.
bool StudentWorld::decJewels()
{
    num_jewels--;
    return true;
}

// makes the level finished
void StudentWorld::setLevelFinished()
{
    game_status = GWSTATUS_FINISHED_LEVEL;
}

// If a bullet were at x,y moving in direction dx,dy, could it hit the
// player without encountering any obstructions?
// if obstructions, return false
bool StudentWorld::existsClearShotToPlayer(int x, int y, int dx, int dy) const
{
    // switch the direction to know if its horizontal or vertical
    if (dx == 0 && dy == 0)
        return false;
    
    // vertical robot
    if ((dy != 0) && (m_player->getX() == x))
    {
        for (int k = 0; k < actor_list.size(); k++)
        {
            if (actor_list[k]->getX() == x)
            {
                if ((dy > 0) &&
                    (actor_list[k]->getY() >= y) &&
                    (actor_list[k]->getY() <= m_player->getY()) &&
                    (actor_list[k]->stopsBullet()))
                    return false;
                if ((dy < 0) &&
                    (actor_list[k]->getY() <= y) &&
                    (actor_list[k]->getY() >= m_player->getY()) &&
                    (actor_list[k]->stopsBullet()))
                    return false;
            }
        }
        if (((dy > 0) && (m_player->getY() >= y)) || ((dy < 0) && (m_player->getY() <= y)))
            return true;
    }
    
    // horizontal robot
    else if ((dx != 0) && (m_player->getY() == y))
    {
        for (int k = 0; k < actor_list.size(); k++)
        {
            if (actor_list[k]->getY() == y)
            {
                if ((dx > 0) &&
                    (actor_list[k]->getX() >= x) &&
                    (actor_list[k]->getX() <= m_player->getX()) &&
                    (actor_list[k]->stopsBullet()))
                    return false;
                if ((dx < 0) &&
                    (actor_list[k]->getX() <= x) &&
                    (actor_list[k]->getX() >= m_player->getX()) &&
                    (actor_list[k]->stopsBullet()))
                    return false;
            }
            
        }
        if (((dx > 0) && (m_player->getX() >= x)) || ((dx < 0) && (m_player->getX() <= x)))
            return true;
    }
    
    return false;
}

// If an item a that can be stolen is at x,y, return a pointer to it and delete
// the item off the Actor* vector; otherwise, return a null pointer.  (Stealable
// items are only ever going be goodies.)
// If the function returns a stealable item, delete the item off the Actor* vector
Actor::GoodieType StudentWorld::steal(int x, int y)
{
    for (int k = 0; k < actor_list.size(); k++)
    {
        if ((actor_list[k]->getX() == x) &&
            (actor_list[k]->getY() == y) &&
            (actor_list[k]->isStealable()))
        {
            // store type of goodie picked up in the kleptobot
            Actor::GoodieType temp = actor_list[k]->getGoodieType();
            
            // delete goodie that's picked up
            // remove from the actor_list
            delete actor_list[k];
            actor_list.erase(actor_list.begin()+k);
            
            // play sound
            playSound(SOUND_ROBOT_MUNCH);
            
            return temp;
        }
    }
    return Actor::no_goodie;
}


// If a factory is at x,y, how many items of the type that should be
// counted are in the rectangle bounded by x-distance,y-distance and
// x+distance,y+distance?  Set count to that number and return true,
// unless an item is on the factory itself, in which case return false
// and don't care about count.  (The items counted are only ever going
// KleptoBots.)
bool StudentWorld::doFactoryCensus(int x, int y, int distance, int& count) const
{
    int m_count = 0;
    int low_x = x-distance, high_x = x+distance, low_y = y-distance, high_y = y+distance;
    if (low_x < 0) low_x = 0;
    if (low_y < 0) low_y = 0;
    if (high_x > VIEW_WIDTH) high_x = VIEW_WIDTH;
    if (high_y > VIEW_HEIGHT) high_y = VIEW_HEIGHT;
    for (int k = 0; k < actor_list.size(); k++)
    {
        if ((actor_list[k]->getX() >= low_x) &&
            (actor_list[k]->getX() <= high_x) &&
            (actor_list[k]->getY() >= low_y) &&
            (actor_list[k]->getY() <= high_y) &&
            (actor_list[k]->countsInFactoryCensus()))
        {
            // kleptobot exists on the factory
            if ((actor_list[k]->getX() == x) &&
                (actor_list[k]->getY() == y) &&
                (actor_list[k]->countsInFactoryCensus()))
            {
                return false;
            }
            m_count++;
        }
    }
    count = m_count;
    return true;
}


// composes a string
string StudentWorld::composeString() const
{
    string status = "";
    
    // score
    status += "Score: ";
    string score = to_string(getScore());
    for (int k = 0; k < (7-score.size()); k++)
    {
        status += "0";
    }
    status += score;
    
    // level
    status += "  Level: ";
    string lev = to_string(getLevel());
    for (int k = 0; k < (2-lev.size()); k++)
    {
        status += "0";
    }
    status += lev;
    
    // lives
    status += "  Lives: ";
    string live = to_string(getLives());
    for (int k = 0; k < (2-live.size()); k++)
    {
        status += " ";
    }
    status += live;
    
    // health
    status += "  Health: ";
    string health = to_string(m_player->getHealthPct());
    for (int k = 0; k < (3-health.size()); k++)
    {
        status += " ";
    }
    status += health + "%";
    
    // ammo
    status += "  Ammo: ";
    string ammo = to_string(m_player->getAmmo());
    for (int k = 0; k < (3-ammo.size()); k++)
    {
        status += " ";
    }
    status += ammo;
    
    // bonus
    status += "  Bonus: ";
    string bonus = to_string(m_bonus);
    for (int k = 0; k < (4-bonus.size()); k++)
    {
        status += "0";
    }
    status += bonus;
    
    return status;
}

















