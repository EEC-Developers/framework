# Hash table classes
Since there is a longstanding bug in the AmigaE module format that makes it choke on multiple return codes, this makes an enhanced solution for the Class/hash module.

## Hash/hashBase
This is the abstract base class that all other hash implementations use.

### constants
These are prime number sizes for hash tables.

* hash_micro
* hash_tiny
* hash_small
* hash_normal
* hash_medium
* hash_large
* hash_huge

### hash functions
These can be used individually or collectively using compositeHash. See the test code for examples on how to use these.

* stringHash -- pointer to char is used to generate the hash value
* longHash -- uses a long value to generate a hash value
* compositeHash -- uses an e-list of longs or hash values to generate a single hash value based on its contents

### methods
* initializer -- base constructor
* rehash -- alternate constructor that migrates hash table data to a different size hash table
* get_hash_function -- getter of dependency injected function for hashing
* find -- hash lookup method that returns NIL if not found or a pointer to hash link if found
* add -- adds a hash link to the table
* hash_slot -- modulo method for determining table slot number
* get_size -- returns table size, measured in slots
* get_num_entries -- total number of items in the table
* end_links -- method to invoke destructor on all hash links
* end -- destructor for main structure and links
* get_entries -- should be used by iterators only
* get_key_get -- internally used only used by rehash
* get_compare_key -- should also be used only by rehash
* remove_from_slot -- for internal use by end_links and rehash

### hash_link
This is the class for designating hashed objects. The hash_link has a one-to-one relationship with the value, which can be either a long or a pointer to an object.

* init_link -- constructor
* get_value -- getter for long value or pointer to the structure being hash searched
* get_hash_value -- getter that returns the 16-bit hash value computed from the constructor.

## unordered_hash
This is the common hash map.  It implements constructors and uses links whose order is not predefined by the class.

Its substructure is the unordered_hash_iterator.

## ordered_hash
This is the alternate hash base that maintains the order all items are added in. It is the equivalent of Java's linked_hash_map. It preserves the sort order of all items added. Prioritization is one reason for using this but it is heavier than a standard unordered_hash_map because it the sort order is maintained by a separate queue internally.

Its substructures include ordered_hash_iterator and the private, internal queue to maintain sort order of all entries.

## dynamic_hash
This unordered_hash derivative allows removal of hash-links although it requires a garbage-collection call to recover the freed memory from empty hash_node structures.

Any rehash will collect garbage due to the add method weeding out empty hash_link structures, however `garbage_collect()` is supplied as a convenience method.
