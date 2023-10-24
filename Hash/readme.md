# Hash table classes
Since there is a longstanding bug in the AmigaE module format that makes it choke on multiple return codes this makes an enhanced solution for the Class/hash module.

## Hash/hashBase -- global abstract hash base module

### constants -- prime number sizes for hash tables

* hash_micro
* hash_tiny
* hash_small
* hash_normal
* hash_medium
* hash_large
* hash_huge

### hash_base -- abstract parent object for submodules

* init_base -- base constructor
* rehash -- alternate constructor that migrates hash table data to a different size hash table
* hash_function -- abstract method for hashing
* find -- hash lookup method that returns NIL if not found
* add -- adds a hash link to the table
* hash_slot -- modulo method for determining table slot number
* get_size -- returns table size, measured in slots
* get_num_entries -- total number of items in the table
* end_links -- method to invoke destructor on all contained objects
* end -- destructor for main structure but not for contained objects
* get_entries -- should be used by iterators only
* get_compare_key -- should also be used only by rehash
* remove_from_slot -- for internal use by end_links and rehash

### hash_link -- abstract parent class for hash-able objects

* init -- constructor
* get_key -- abstract getter method for key
* get_hash_value -- getter that returns the 16-bit hash value computed from the constructor.

## unordered_hash_base -- the common abstract hash base
This implements constructors and uses buckets whose order is not predefined by the class.

Its substructures include unordered_hash_link and unordered_hash_iterator.

## Hash/stringHash -- uses null terminated string keys
* string_hash -- actual hash table implementaton of abstract hash_base
* string_hash_link -- actual implementation of abstract hash_link

## Hash/pointerHash -- uses pointer or LONG keys
* pointer_hash -- actual hash table implementaton
* pointer_hash_link -- actual hash_link implementaton

## Hash/listHash -- uses E-Lists as keys
* list_hash -- actual hash table implementation
* list_hash_link -- combines pointer hash and string hash functions to implement hash_link

## ordered_hash_base -- alternate abstract hash base that maintains the order all items are added in
This is the equivalent of Java's linked_hash_map. It preserves the sort order of all items added. Prioritization is one reason for using this but it is heavier than a standard unordered_hash_map because it the sort order is maintained by a separate queue internally.

Its substructures include ordered_hash_link, ordered_hash_iterator, and the private, intenral queue to maintain sort order of all entries.

The ordered counterparts such as the orderedStringHash and so on, use the same hash functions as the unordered ones.