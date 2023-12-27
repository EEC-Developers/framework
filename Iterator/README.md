# Iterators
Iterators provide an abstract way to traverse the items in a structure.

Some are not listed in a particular order other than they are not allowed to repeat.

## Basic Iterator

* init(structure) -- Constructor of the iterator, the structure being pointed to is maintained by the iterator once it is passed in as the structure parameter.
* next() -- This advances to the next value in the structure. Note that this method must be called at least once after initialization to contain valid data.
* get_current_item() -- This is the getter method for whatever the iterator is pointing at.

## Bidirectional Iterator
Bidirectional iterators can advance in either of two directions. Since there is still only one constructor, whether it starts at the beginning or end of the structure depends on whether `next()` or `prev()` is called first.

Optionally, a second bidirectional iterator can be supplied for reversing the direction of iteration.

* prev() -- This goes in the reverse direction from the `next()` method when an iterator is bidirectional.

### EList iterator
This is the only instantiation of an iterator in this directory. It is placed here purely because the e-list structure is the only internal data structure for the AmigaE language to iterate over. It is a child class of the bidirectional abstract iterator class and is provided as a wrapper class.

## Utility module
This module contains stand-alone functions to count the elements in an iterator and move the contents of an iterator to an elist. Both functions have O(n) time complexity.
