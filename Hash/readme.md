# Hash table classes

## Description

Since there is a longstanding bug in the AmigaE module format that makes it choke on multiple return codes this makes an enhanced solution for the Class/hash module.

## Index

### Hash/hashbase -- global base module

#### constants -- prime number sizes for hash tables
  
#### hash_base -- abstract parent object for submodules

* init -- abstract constructor
* find -- hash lookup method that returns NIL if not found
* add -- adds a hash link to the table
* hash_slot -- modulo method for determining table slot number
* get_size -- returns table size, measured in slots
* get_num_entries -- total number of items in the table
* end_links -- method to invoke destructor on all contained objects
* end -- destructor
* get_entries -- should be used by iterators only

#### hash_link -- abstract parent class for hash-able objects

* init -- constructor
* get_key -- abstract getter method for key
* hash_value -- Computed by constructor.  Treat as read-only.
* key_equality -- abstract boolean comparison for key types

#### hash_iterator -- iterates through any child class of hash_base

* init -- constructor
* next -- finds next item or returns NIL if end is reached

### Hash/stringhash -- uses null terminated string keys

#### string_hash -- actual hash table implementaton of abstract hash_base

#### string_hash_link -- actual implementation of abstract hash_link

### Hash/pointerhash -- uses pointer or LONG keys

#### pointer_hash -- actual hash_base implementaton

#### pointer_hash_link -- actual hash_link implementaton
