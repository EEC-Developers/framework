# Set
Membership or non-membership are the only values of a set.  Being able to test membership of groups as one operation is the primary means of optimizing them.

## SetBase
The setBase is an abstract base class that defines the methods common to all set structures.

The subset class is used to operate on membership functions of the set.

There is also an abstract set_iterator class that allows traversal of a set.

* init -- the constructor: it raises "bset" if the number of items is out of range.
* insert -- adds a member to the set
* remove -- removes a member from the set
* has_one -- returns true if any one member is common to the passed subset and the set
* has_all -- returns true only if all members of the subset are in the set
* is_empty -- returns true if no members are present in the subset

## SmallSet
The SmallSet stores its memberships as a packed array of boolean flags.  This limits it to 32 members maximum, whose names are passed in using an E-List at allocation.  Most operations have constant time complexity O(1) so it is also extremely fast.

## BitVector
The BitVector is essentially an E-List of SmallSets.  This raises the capacity of it to 65536 memberships while retaining the modest maximum storage of 8192 bytes maximum per set at the cost of raising the processing cost linearly to O(n) for most operations with a low constant term.
