# Set

## Description

Membership or non-membership are the only values of a set.  Being able to test membership of groups as one operation is the primary means of optimizing them.

### SmallSet

The SmallSet stores its memberships as a packed array of boolean flags.  This limits it to 32 members maximum, whose names are passed in using an E-List at allocation.  Most operations have constant time complexity O(1) so it is also extremely fast.

### BitVector

The BitVector is essentially an E-List of SmallSets.  This raises the capacity of it to 65535 memberships while retaining the modest maximum storage of 2048 bytes maximum per set at the cost of raising the processing cost linearly to O(n) for most operations with a low constant term.
