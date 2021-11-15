# Hash table classes

## Description

Since there is a longstanding bug in the AmigaE module format that makes it choke on multiple return codes this makes an enhanced solution for the Class/hash module.

## Index

### Hash/hashbase -- global base module

#### constants -- prime number sizes for hash tables

* hash_micro
* hash_tiny
* hash_small
* hash_normal
* hash_medium
* hash_large
* hash_huge

#### hash_base -- abstract parent object for submodules

* init_base -- abstract constructor
* hash_function -- abstract method for hashing
* find -- hash lookup method that returns NIL if not found
* add -- adds a hash link to the table
* hash_slot -- modulo method for determining table slot number
* get_size -- returns table size, measured in slots
* get_num_entries -- total number of items in the table
* end_links -- method to invoke destructor on all contained objects
* end -- destructor for main structure but not for contained objects
* rehash -- changes hash table to a different size
* get_entries -- should be used by iterators only

#### hash_link -- abstract parent class for hash-able objects

* init -- constructor
* get_key -- abstract getter method for key
* get_hash_value -- getter that returns the 16-bit hash value computed from the constructor.

#### hash_iterator -- iterates through any child class of hash_base

* init -- constructor
* get_current_item -- getter for item currently referenced by the iterator
* next -- finds next item and returns TRUE or returns FALSE if end is reached

### Hash/stringhash -- uses null terminated string keys

#### string_hash -- actual hash table implementaton of abstract hash_base

#### string_hash_link -- actual implementation of abstract hash_link

### Hash/pointerhash -- uses pointer or LONG keys

#### pointer_hash -- actual hash table implementaton

#### pointer_hash_link -- actual hash_link implementaton

### Hash/listhash -- uses E-Lists as keys

#### list_hash -- actual hash table implementation

#### list_hash_link -- combines pointer hash and string hash functions to implement hash_link
