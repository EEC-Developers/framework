# Set
Membership or non-membership are the only values of a set.  Being able to test membership of groups as one operation is the primary means of optimizing them.

## SetBase
The setBase is an abstract base class that defines the methods common to all set structures.

The subset class is used to operate on membership functions of the set.

There is also an abstract set_iterator class that allows traversal of a set.

* init -- the constructor: it raises "RNG" if the number of items is out of range.
* insert -- adds a member to the set
* remove -- removes a member from the set
* has_one -- returns true if any one member is common to the passed subset and the set
* has_all -- returns true only if all members of the subset are in the set
* is_empty -- returns true if no members are present in the subset

## BitVector
The BitVector is essentially an array of 32-bit bitsets.  This has a processing cost of O(n) for most operations with a low constant term. If there are less than 33 items in the set, it will operate at O(1) time complexity.
