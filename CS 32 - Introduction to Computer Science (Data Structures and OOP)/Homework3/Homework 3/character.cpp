// Character superclass
class Character
{
public:
    Character(std::string name) : m_name(name) {};
    virtual ~Character() {};
    std::string name() const {return m_name;};
    virtual void printWeapon() const = 0;
    virtual std::string attackAction() const {return "rushes toward the enemy";};
private:
    std::string m_name;
};

// Dwarf subclass
class Dwarf : public Character
{
public:
    Dwarf(std::string name) : Character(name) {};
    virtual ~Dwarf()
    {
        std::cout << "Destroying " << name() << " the dwarf" << std::endl;
    };
    virtual void printWeapon() const
    {
        std::cout << "an axe";
    };
};

// Elf subclass
class Elf : public Character
{
public:
    Elf(std::string name, int arrows) : Character(name), m_arrows(arrows) {};
    virtual ~Elf()
    {
        std::cout << "Destroying " << name() << " the elf" << std::endl;
    };
    int getArrows() const {return m_arrows;};
    virtual void printWeapon() const
    {
        std::cout << "a bow and quiver of " << getArrows() <<" arrows";
    };
private:
    int m_arrows;
};

// Boggie subclass
class Boggie : public Character
{
public:
    Boggie(std::string name) : Character(name) {};
    virtual ~Boggie()
    {
        std::cout << "Destroying " << name() << " the boggie" << std::endl;
    };
    virtual void printWeapon() const
    {
        std::cout << "a short sword";
    };
    virtual std::string attackAction() const
    {
        return "whimpers";
    };
};