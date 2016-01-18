//
//  HashTable.h
//  Project 4
//
//  Created by Wenlong Xiong on 3/7/15.
//  Copyright (c) 2015 Wenlong Xiong. All rights reserved.
//

#ifndef Project_4_HashTable_h
#define Project_4_HashTable_h

#include <string>

template <typename KeyType, typename ValueType>
class HashTable
{
public:
    // constructor
    HashTable(unsigned int numBuckets, unsigned int capacity)
    : max_capacity(capacity), num_buckets(numBuckets)
    {
        buckets = new Node*[numBuckets];
        for (int k = 0; k < num_buckets; k++)
        {
            buckets[k] = nullptr;
        }
    }
    
    // destructor
    ~HashTable()
    {
        for (int k = 0; k < num_buckets; k++)
        {
            if (buckets[k] != nullptr)
            {
                Node* to_delete = buckets[k];
                Node* temp = nullptr;
                while (to_delete->next != nullptr)
                {
                    temp = to_delete->next;
                    delete to_delete;
                    to_delete = temp;
                }
                delete to_delete;
            }
        }
    }
    
    // returns true if the hash table is at its maximum capacity
    // returns false otherwise
    bool isFull() const { if (cur_capacity == max_capacity) return true; else return false; }
    
    // attempts to add key to hash table
    // returns true if key does not already exist and is added to the table
    // returns true if the key already exists and the value is overwritten
    // returns false if capacity of table is already reached
    bool set(const KeyType& key, const ValueType& value, bool permanent = false)
    {
        // function prototype
        unsigned int computeHash(KeyType);
        unsigned int index = computeHash(key) % num_buckets;
        
        // value doesn't exist in table, no node exists
        if (buckets[index] == nullptr)
        {
            if (cur_capacity >= max_capacity)
                return false;
            
            buckets[index] = new Node(key, value);
            
            // update history linked list if key is not permanent
            if (!permanent)
            {
                // add to the front of the history linked list
                if (history_head != nullptr)
                {
                    buckets[index]->hist_next = history_head;
                    history_head->hist_prev = buckets[index];
                }
                //if (history_tail == nullptr) history_tail = buckets[index];
                history_head = buckets[index];
            }
            cur_capacity++;
            return true;
        }
        // collision
        else
        {
            Node* cur_node = buckets[index];
            while ((cur_node != nullptr) && (cur_node->m_key != key))
            {
                if (cur_node->next != nullptr)
                    cur_node = cur_node->next;
                // value doesn't exist in hash table, no node exists
                else
                {
                    if (cur_capacity >= max_capacity)
                        return false;
                    
                    cur_node->next = new Node(key, value);
                    // update history linked list
                    if (!permanent)
                    {
                        // add to the front of the history linked list
                        if (history_head != nullptr)
                        {
                            cur_node->next->hist_next = history_head;
                            history_head->hist_prev = cur_node->next;
                        }
                        //if (history_tail == nullptr) history_tail = cur_node->next;
                        history_head = cur_node->next;
                    }
                    cur_capacity++;
                    return true;
                }
            }
            cur_node->m_val = value;
            touch(key);
            return true;
        }
        return false;
    }
    
    // returns true if the given key is in the hash table
    // returns false otherwise
    bool get(const KeyType& key, ValueType& value) const
    {
        unsigned int computeHash(KeyType);
        unsigned int index = computeHash(key) % num_buckets;
        
        // linked list at bucket
        if (buckets[index] != nullptr)
        {
            Node* cur_node = buckets[index];
            while (cur_node != nullptr)
            {
                if (cur_node->m_key == key)
                {
                    value = cur_node->m_val;
                    return true;
                }
                cur_node = cur_node->next;
            }
        }
        return false;
    }
    
    // if key matches a nonpermanent item in the hash table, move it to the top of
    //      the history and return true
    // return false if key does not match
    bool touch(const KeyType& key)
    {
        // iterate throught the history
        Node* cur_node = history_head;
        while (cur_node != nullptr)
        {
            // found matching value
            if (cur_node->m_key == key)
            {
                // trivial case
                if (cur_node == history_head)
                    return true;
                
                // last thing in the history list
                if (cur_node->hist_next == nullptr)
                {
                    cur_node->hist_prev->hist_next = nullptr;
                }
                else
                {
                    cur_node->hist_prev->hist_next = cur_node->hist_next;
                    cur_node->hist_next->hist_prev = cur_node->hist_prev;
                }
                
                history_head->hist_prev = cur_node;
                cur_node->hist_next = history_head;
                cur_node->hist_prev = nullptr;
                history_head = cur_node;
                
                return true;
            }
            cur_node = cur_node->hist_next;
        }
        return false;
    }
    
    bool discard(KeyType& key, ValueType& value)
    {
        if (history_head == nullptr)
            return false;
        
        // iterate throught the history
        // at the end, cur_node will point to the last in history
        Node* cur_node = history_head;
        while (cur_node->hist_next != nullptr)
        {
            cur_node = cur_node->hist_next;
        }
        
        // set the key and value
        key = cur_node->m_key;
        value = cur_node->m_val;
        
        // shift history pointers
        if (cur_node->hist_prev != nullptr)
        {
            cur_node->hist_prev->hist_next = nullptr;
        }
        else
        {
            history_head = cur_node->hist_next;
        }
        
        // function prototype
        unsigned int computeHash(KeyType);
        unsigned int index = computeHash(key) % num_buckets;
        
        // update bucket linked list
        if (cur_node->prev == nullptr)
        {
            if (cur_node->next == nullptr)
            {
                buckets[index] = cur_node->next;
                cur_node->next->prev = nullptr;
            }
            else
                buckets[index] = nullptr;
        }
        else
        {
            cur_node->prev->next = cur_node->next;
            cur_node->next->prev = cur_node->prev;
        }
        
        delete cur_node;
        cur_capacity--;
        return true;
    }
    
private:
    // We prevent a HashTable from being copied or assigned by declaring the
    // copy constructor and assignment operator private and not implementing them.
    HashTable(const HashTable&);
    HashTable& operator=(const HashTable&);
    
    struct Node
    {
        // constructor
        Node(KeyType key, ValueType value) : m_key(key), m_val(value) {}
        KeyType m_key;
        ValueType m_val;
        
        // previous and next Nodes in the bucket
        Node* next = nullptr;
        Node* prev = nullptr;
        
        // previous and next nodes in the history linked list
        Node* hist_prev = nullptr;
        Node* hist_next = nullptr;
    };
    
    // number of buckets hash table contains
    unsigned int num_buckets = 0;
    
    // current # filled
    unsigned int cur_capacity = 0;
    
    // maximum amount the hash table can hold
    unsigned int max_capacity = 0;
    
    // buckets is the array of Nodes
    // buckets[k] gives you a Node
    Node** buckets;
    
    // linked list containing the history of accessed keys
    // head is the most recently accessed, tail is the least
    Node* history_head = nullptr;
};

#endif
