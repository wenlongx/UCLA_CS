#ifndef ACTOR_H_
#define ACTOR_H_

#include "GraphObject.h"
#include "GameConstants.h"

#include <cstdlib>
#include <iostream>

class StudentWorld;
class GameWorld;
class Agent;

class Actor : public GraphObject
{
public:
    Actor(StudentWorld* world, int startX, int startY, int imageID, unsigned int hitPoints, Direction startDir) : GraphObject(imageID, startX, startY, startDir)
    {
        m_world = world;
        setVisible(true);
        hp = hitPoints;
    }
    virtual ~Actor() {}
    
    enum GoodieType { no_goodie, extra_life_goodie, restore_health_goodie, ammo_goodie};
    
    // Action to perform each tick
    virtual void doSomething() = 0;
    
    // Is this actor alive?
    bool isAlive() const { return alive; }
    
    // Mark this actor as dead
    void setDead() { alive = false; setVisible(false); }
    
    // Get this actor's world
    StudentWorld* getWorld() const { return m_world; }
    
    // Can an agent occupy the same square as this actor?
    virtual bool allowsAgentColocation() const { return false; }
    
    // Return true if this agent can push boulders (which means it's the
    // player).
    virtual bool canPushBoulders() const { return false; }
    
    // Can a boulder occupy the same square as this actor?
    virtual bool allowsBoulder() const { return false; }
    
    // Does this actor count when a factory counts items near it?
    virtual bool countsInFactoryCensus() const { return false; }
    
    // Does this actor stop bullets from continuing?
    virtual bool stopsBullet() const { return true; }
    
    // Can this actor be damaged by bullets?
    virtual bool isDamageable() const { return false; }
    
    // Cause this Actor to sustain damageAmt hit points of damage.
    // If this kills the actor, it sets it to dead
    virtual void damage(unsigned int damageAmt) { hp -= damageAmt; if (hp <= 0) setDead(); }
    
    // Can this actor be pushed by a to location x,y?
    bool bePushedBy(Agent* a, int x, int y);
    
    // Can this actor be swallowed by a hole?
    virtual bool isSwallowable() const { return false; }
    
    // Can this actor be picked up by a KleptoBot?
    virtual bool isStealable() const { return false; }
    
    // How many hit points does this actor have left?
    unsigned int getHitPoints() const { return hp; }
    
    // Set this actor's hit points to amt.
    virtual void setHitPoints(int amt) { hp = amt; }
    
    // used to determine if actor is a goodie
    void setGoodieType(GoodieType x) { goodie_type = x; }
    virtual GoodieType getGoodieType() const { return goodie_type; }
    
private:
    StudentWorld* m_world;
    int hp = 0;
    bool alive = true;
    
    // goodie_type determines if actor is goodie
    GoodieType goodie_type = no_goodie;
};

class Agent : public Actor
{
public:
    Agent(StudentWorld* world, int startX, int startY, int imageID,
          unsigned int hitPoints, Direction startDir) : Actor(world, startX, startY, imageID, hitPoints, startDir) {}
    virtual ~Agent() {}
    
    // Move to the adjacent square in the direction the agent is facing
    // if it is not blocked, and return true.  Return false if the agent
    // can't move.
    bool moveIfPossible();
    
    // Return true if can only shoot if there is a clear line of sight between it and the target
    virtual bool needsClearShot() const = 0;
    
    // Return the sound effect ID for a shot from this agent.
    // player).
    virtual int shootingSound() const = 0;
    
    bool shoot();
};

class Player : public Agent
{
public:
    Player(StudentWorld* world, int startX, int startY) : Agent(world, startX, startY, IID_PLAYER, 20, right) { ammo = 20; }
    virtual ~Player() {}
    virtual void doSomething();
    virtual bool isDamageable() const { return true; }
    virtual void damage(unsigned int damageAmt);
    virtual bool canPushBoulders() const { return true; }
    virtual int shootingSound() const { return SOUND_PLAYER_FIRE; };
    virtual bool needsClearShot() const { return false; }
    
    // Get player's health percentage
    unsigned int getHealthPct() const { return 5*getHitPoints(); }
    
    // Get player's amount of ammunition
    unsigned int getAmmo() const { return ammo; }
    
    // Restore player's health to the full amount.
    void restoreHealth() { setHitPoints(20); }
    
    // Increase player's amount of ammunition by 20
    void increaseAmmo() { ammo += 20; }
    
    // Decrease player's amount of ammunition by 1
    void decreaseAmmo()
    {
        if (ammo >= 0)
            ammo -= 1;
    }
    
private:
    int ammo;
};


////////////////////////////////////////////////////////////////////////////////////////////////
//      Game environment
////////////////////////////////////////////////////////////////////////////////////////////////
class Wall : public Actor
{
public:
    Wall(StudentWorld* world, int startX, int startY) : Actor(world, startX, startY, IID_WALL, 1, Direction::none) {}
    virtual ~Wall() {}
    virtual void doSomething() {};
};

class Boulder : public Actor
{
public:
    Boulder(StudentWorld* world, int startX, int startY) : Actor(world, startX, startY, IID_BOULDER, 10, none) {}
    virtual ~Boulder() {}
    virtual void doSomething() {}
    virtual bool isDamageable() const { return true; }
    virtual bool isSwallowable() const { return true; }
};

class Hole : public Actor
{
public:
    Hole(StudentWorld* world, int startX, int startY) : Actor(world, startX, startY, IID_HOLE, 1, none) {}
    virtual ~Hole() {}
    virtual void doSomething();
    virtual bool allowsBoulder() const { return true; }
    virtual bool stopsBullet() const { return false; }
};

class Exit : public Actor
{
public:
    Exit(StudentWorld* world, int startX, int startY) : Actor(world, startX, startY, IID_EXIT, 1, none)
    {
        setVisible(false);
    }
    virtual ~Exit() {}
    virtual void doSomething();
    virtual bool allowsAgentColocation() const { return true; }
    virtual bool stopsBullet() const { return false; }
private:
};

class Bullet : public Actor
{
public:
    Bullet(StudentWorld* world, int startX, int startY, Direction startDir) : Actor(world, startX, startY, IID_BULLET, 1, startDir) {}
    virtual ~Bullet() {}
    virtual void doSomething();
    virtual bool allowsAgentColocation() const { return true; }
    virtual bool stopsBullet() const { return false; }
private:
    bool just_created = true;
};




////////////////////////////////////////////////////////////////////////////////////////////////
//      Pickups
////////////////////////////////////////////////////////////////////////////////////////////////
class PickupableItem : public Actor
{
public:
    PickupableItem(StudentWorld* world, int startX, int startY, int imageID, unsigned int score) : Actor(world, startX, startY, imageID, 1, none) { m_score = score; }
    virtual ~PickupableItem() {}
    virtual void doSomething() = 0;
    unsigned int returnScore() const { return m_score; }
    virtual bool allowsAgentColocation() const { return true; }
    virtual bool stopsBullet() const { return false; }
private:
    unsigned int m_score;
};

class Jewel : public PickupableItem
{
public:
    Jewel(StudentWorld* world, int startX, int startY) : PickupableItem(world, startX, startY, IID_JEWEL, 50) {}
    virtual ~Jewel() {}
    virtual void doSomething();
};

class Goodie : public PickupableItem
{
public:
    Goodie(StudentWorld* world, int startX, int startY, int imageID,
           unsigned int score) : PickupableItem(world, startX, startY, imageID, score) {}
    virtual ~Goodie() {}
    virtual void doSomething();
    virtual bool isStealable() const { return true; }
    
};

class ExtraLifeGoodie : public Goodie
{
public:
    ExtraLifeGoodie(StudentWorld* world, int startX, int startY) : Goodie(world, startX, startY, IID_EXTRA_LIFE, 1000)
    {
        // type 1 is extra life goodie
        setGoodieType(Actor::extra_life_goodie);
    }
    virtual ~ExtraLifeGoodie() {};
    virtual void doSomething();
    
};

class RestoreHealthGoodie : public Goodie
{
public:
    RestoreHealthGoodie(StudentWorld* world, int startX, int startY) : Goodie(world, startX, startY, IID_RESTORE_HEALTH, 500)
    {
        // type 2 is restore health goodie
        setGoodieType(Actor::restore_health_goodie);
    }
    virtual ~RestoreHealthGoodie() {}
    virtual void doSomething();
    
};

class AmmoGoodie : public Goodie
{
public:
    AmmoGoodie(StudentWorld* world, int startX, int startY) : Goodie(world, startX, startY, IID_AMMO, 100)
    {
        // type 3 is extra life goodie
        setGoodieType(Actor::ammo_goodie);
    }
    virtual ~AmmoGoodie() {}
    virtual void doSomething();
    
};




////////////////////////////////////////////////////////////////////////////////////////////////
//      Robots and Enemies
////////////////////////////////////////////////////////////////////////////////////////////////
class Robot : public Agent
{
public:
    Robot(StudentWorld* world, int startX, int startY, int imageID,
          unsigned int hitPoints, unsigned int score, Direction startDir);
    virtual ~Robot() {}
    virtual void doSomething();
    virtual bool isDamageable() const { return true; }
    virtual void damage(unsigned int damageAmt);
    virtual bool needsClearShot() const { return true; }
    virtual int shootingSound() const { return SOUND_ENEMY_FIRE; }
    virtual int returnScore() const { return m_score; }
    
    virtual int getTick() const { return ticks; }
    virtual int getCurTick() const { return cur_tick; }
    virtual void setCurTick(int t) { cur_tick = t; }
    virtual bool performAction() const { return !isResting; }
    
    // Does this robot shoot?
    virtual bool isShootingRobot() const { return false; }
    
    virtual void dropHeld() {}
private:
    int m_score;
    int ticks;
    int cur_tick = 0;
    bool isResting = true;
};

class SnarlBot : public Robot
{
public:
    SnarlBot(StudentWorld* world, int startX, int startY, Direction startDir) : Robot(world, startX, startY, IID_SNARLBOT, 10, 100, startDir) {}
    virtual ~SnarlBot() {}
    virtual void doSomething();
    virtual bool isShootingRobot() const { return true; }
};

class KleptoBot : public Robot
{
public:
    KleptoBot(StudentWorld* world, int startX, int startY, int imageID,
              unsigned int hitPoints, unsigned int score) : Robot(world, startX, startY, imageID, hitPoints, score, right)
    {
        distance_before_turning = rand()%6 + 1;
    }
    virtual ~KleptoBot() {}
    virtual void doSomething();
    virtual bool countsInFactoryCensus() const { return true; }
    virtual GoodieType getHeld() const { return held; }
    virtual void setHeld(GoodieType n) { held = n; }
    virtual void dropHeld();
private:
    GoodieType held = no_goodie;
    
    // distance before turning is 1 to 6 inclusive
    // when distance == 0, that means you must turn
    int distance_before_turning;
};

class RegularKleptoBot : public KleptoBot
{
public:
    RegularKleptoBot(StudentWorld* world, int startX, int startY) : KleptoBot(world, startX, startY, IID_KLEPTOBOT, 5, 10) {}
    virtual ~RegularKleptoBot() {}
    virtual void doSomething();
    virtual bool isShootingRobot() const { return false; }
};

class AngryKleptoBot : public KleptoBot
{
public:
    AngryKleptoBot(StudentWorld* world, int startX, int startY) : KleptoBot(world, startX, startY, IID_KLEPTOBOT, 8, 20) {}
    virtual ~AngryKleptoBot() {}
    virtual void doSomething();
};

class KleptoBotFactory : public Actor
{
public:
    enum ProductType { REGULAR, ANGRY };
    
    KleptoBotFactory(StudentWorld* world, int startX, int startY, ProductType type) : Actor(world, startX, startY, IID_ROBOT_FACTORY, 1, none) { p_type = type;}
    virtual void doSomething();
    virtual bool stopsBullet() const { return true; }
private:
    ProductType p_type;
};

#endif // ACTOR_H_
