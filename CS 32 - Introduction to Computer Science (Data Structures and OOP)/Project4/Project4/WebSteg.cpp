#include "provided.h"
#include <string>
#include "http.h"
using namespace std;

unsigned int computeHash(std::string key)
{
    unsigned int hash = 0;
    for (int k = 0; k < key.size(); k++)
    {
        hash += (k+1)*key[k];
    }
    return hash;
}

unsigned int computeHash(unsigned short key)
{
    unsigned int hash = key;
    hash += 356973420734;
    hash *= 172591;
    hash += hash % 7;
    hash += hash % 13;
    hash *= 19;
    return hash;
}

bool WebSteg::hideMessageInPage(const string& url, const string& msg, string& host)
{
    string web_page;
    string temp;
    
    if (HTTP().get(url, web_page))
    {
        Steg::hide(web_page, msg, temp);
        host = temp;
        return true;
    }
    return false;
}

bool WebSteg::revealMessageInPage(const string& url, string& msg)
{
    string web_page;
    string temp;
    if (HTTP().get(url, web_page))
    {
        Steg::reveal(web_page, temp);
        msg = temp;
        return true;
    }
    return false;
}
